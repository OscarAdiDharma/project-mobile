"""
Lightweight NCF Model Evaluation
No TensorFlow required - uses h5py + numpy for inference
"""
import numpy as np
import pandas as pd
import h5py
import joblib
from sklearn.metrics import (
    confusion_matrix, accuracy_score, precision_score,
    recall_score, f1_score, mean_squared_error, mean_absolute_error
)

# --- Load model weights from h5 ---
def load_weights(h5_path):
    weights = {}
    with h5py.File(h5_path, 'r') as f:
        wg = f['model_weights']
        for layer_name in ['shared_dense_1', 'shared_dense_2', 'shared_dense_3',
                           'classification_head', 'regression_head']:
            key = f'{layer_name}/{layer_name}'
            weights[f'{layer_name}_kernel'] = np.array(wg[key]['kernel'])
            weights[f'{layer_name}_bias'] = np.array(wg[key]['bias'])
    return weights

# --- Forward pass (inference) ---
def relu(x):
    return np.maximum(0, x)

def softmax(x):
    e_x = np.exp(x - np.max(x, axis=1, keepdims=True))
    return e_x / e_x.sum(axis=1, keepdims=True)

def predict(X, weights):
    x = X
    # shared_dense_1: (input, 128)
    x = relu(x @ weights['shared_dense_1_kernel'] + weights['shared_dense_1_bias'])
    # dropout 0.3 at inference = scale by 0.7
    x = x * 0.7
    # shared_dense_2: (128, 64)
    x = relu(x @ weights['shared_dense_2_kernel'] + weights['shared_dense_2_bias'])
    # dropout 0.2 at inference = scale by 0.8
    x = x * 0.8
    # shared_dense_3: (64, 32)
    x = relu(x @ weights['shared_dense_3_kernel'] + weights['shared_dense_3_bias'])
    # classification head: (32, 3) softmax
    cls_logits = x @ weights['classification_head_kernel'] + weights['classification_head_bias']
    cls_probs = softmax(cls_logits)
    # regression head: (32, 1) linear
    reg_pred = x @ weights['regression_head_kernel'] + weights['regression_head_bias']
    return cls_probs, reg_pred.flatten()

# --- Main ---
print("=" * 60)
print("LIGHTWEIGHT NCF MODEL EVALUATION")
print("=" * 60)

# 1. Load data
print("\n[1] Loading dataset...")
df = pd.read_csv('backend/dataset/employee_kpi_data.csv')
print(f"    Total records: {len(df)}")
print(f"    Columns: {len(df.columns)}")

# 2. Load preprocessor artifacts
print("\n[2] Loading preprocessor artifacts...")
scaler = joblib.load('backend/saved_models/scaler.pkl')
label_encoder = joblib.load('backend/saved_models/label_encoder.pkl')
print(f"    Scaler: {scaler.__class__.__name__}")
print(f"    Classes: {label_encoder.classes_.tolist()}")

# 3. Preprocess
print("\n[3] Preprocessing...")
df_proc = df.drop(columns=['employee_id'])
y_true_str = df_proc['performance_rating'].values
y_true = label_encoder.transform(y_true_str)
X = df_proc.drop(columns=['performance_rating']).values
X_scaled = scaler.transform(X)
print(f"    Features shape: {X_scaled.shape}")
print(f"    Class distribution: {dict(zip(*np.unique(y_true_str, return_counts=True)))}")

# 4. Split (70/15/15) — same random_state=42 as training
from sklearn.model_selection import train_test_split
y_combined = np.column_stack((y_true, np.zeros(len(y_true))))  # dummy reg target for stratify
X_train, X_temp, y_train, y_temp = train_test_split(
    X_scaled, y_combined, test_size=0.3, random_state=42, stratify=y_true
)
X_val, X_test, y_val, y_test = train_test_split(
    X_temp, y_temp, test_size=0.5, random_state=42, stratify=y_temp[:, 0].astype(int)
)
y_test_cls = y_test[:, 0].astype(int)
print(f"    Train: {len(X_train)}, Val: {len(X_val)}, Test: {len(X_test)}")

# 5. Load model weights & predict
print("\n[4] Loading model weights & predicting on test set...")
weights = load_weights('backend/saved_models/best_ncf_model.h5')
cls_probs, reg_pred = predict(X_test, weights)
y_pred = np.argmax(cls_probs, axis=1)

# 6. Classification metrics
print("\n" + "=" * 60)
print("CLASSIFICATION RESULTS")
print("=" * 60)

accuracy = accuracy_score(y_test_cls, y_pred)
print(f"\n  Accuracy: {accuracy:.4f} ({accuracy*100:.2f}%)")

target_names = label_encoder.classes_.tolist()
precision = precision_score(y_test_cls, y_pred, average=None)
recall = recall_score(y_test_cls, y_pred, average=None)
f1 = f1_score(y_test_cls, y_pred, average=None)

macro_p = precision_score(y_test_cls, y_pred, average='macro')
macro_r = recall_score(y_test_cls, y_pred, average='macro')
macro_f1 = f1_score(y_test_cls, y_pred, average='macro')

print(f"\n  Per-class metrics:")
print(f"  {'Class':<10} {'Precision':>10} {'Recall':>10} {'F1-Score':>10}")
print(f"  {'-'*40}")
for i, name in enumerate(target_names):
    print(f"  {name:<10} {precision[i]:>10.4f} {recall[i]:>10.4f} {f1[i]:>10.4f}")
print(f"  {'-'*40}")
print(f"  {'Macro Avg':<10} {macro_p:>10.4f} {macro_r:>10.4f} {macro_f1:>10.4f}")

# Confusion matrix
cm = confusion_matrix(y_test_cls, y_pred)
print(f"\n  Confusion Matrix:")
print(f"  {'':>15}", end='')
for name in target_names:
    print(f" {'Pred '+name:>12}", end='')
print()
for i, name in enumerate(target_names):
    print(f"  {'Aktual '+name:>15}", end='')
    for j in range(len(target_names)):
        print(f" {cm[i][j]:>12}", end='')
    print()

# Manual validation
print(f"\n  Manual Validation:")
total = cm.sum()
diagonal = np.trace(cm)
manual_acc = diagonal / total
print(f"    Accuracy = {diagonal}/{total} = {manual_acc:.4f}")
print(f"    Matches sklearn: {np.isclose(accuracy, manual_acc)}")

# 7. Regression metrics
print("\n" + "=" * 60)
print("REGRESSION RESULTS")
print("=" * 60)

# Compute regression target from original data
# The preprocessor calculates it as mean of score_cols * 10
score_cols = [c for c in df_proc.columns if 'score' in c and c not in ['speech_sentiment_score', 'client_satisfaction_score', 'performance_rating']]
print(f"  Score columns for regression target: {score_cols}")

df_scores = df_proc[score_cols]
y_reg_full = df_scores.mean(axis=1).values * 10

# Split same way with same indices
idx_all = np.arange(len(X_scaled))
idx_train, idx_temp, _, _ = train_test_split(
    idx_all, y_true, test_size=0.3, random_state=42, stratify=y_true
)
idx_val, idx_test, _, _ = train_test_split(
    idx_temp, y_temp[:, 0].astype(int), test_size=0.5, random_state=42, stratify=y_temp[:, 0].astype(int)
)
y_test_reg = y_reg_full[idx_test]

mse = mean_squared_error(y_test_reg, reg_pred)
rmse = np.sqrt(mse)
mae = mean_absolute_error(y_test_reg, reg_pred)

print(f"\n  MSE:  {mse:.4f}")
print(f"  RMSE: {rmse:.4f}")
print(f"  MAE:  {mae:.4f}")

# 8. Summary
print("\n" + "=" * 60)
print("SUMMARY FOR REPORT")
print("=" * 60)
print(f"""
Classification:
  Accuracy:       {accuracy:.4f} ({accuracy*100:.2f}%)
  Macro Precision: {macro_p:.4f}
  Macro Recall:    {macro_r:.4f}
  Macro F1:        {macro_f1:.4f}

Regression:
  MSE:  {mse:.4f}
  RMSE: {rmse:.4f}
  MAE:  {mae:.4f}

Confusion Matrix:
{cm}
""")
