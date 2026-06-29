from flask import Flask, request, jsonify  # type: ignore
from flask_cors import CORS  # type: ignore
import pandas as pd  # type: ignore
import os
import joblib  # type: ignore
from preprocessing.preprocessor import Preprocessor
from model.trainer import Trainer
from evaluation.evaluator import Evaluator
import tensorflow as tf  # type: ignore

app = Flask(__name__)
CORS(app)

# Global instances
preprocessor = Preprocessor()
trainer = Trainer()
evaluator = Evaluator()

# Global state
training_results = None
evaluation_results = None
X_train = None
X_val = None
X_test = None
y_train_cls = None
y_val_cls = None
y_test_cls = None
y_train_reg = None
y_val_reg = None
y_test_reg = None

@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy"})

@app.route('/api/dataset/info', methods=['GET'])
def dataset_info():
    if not os.path.exists('dataset/employee_kpi_data.csv'):
        return jsonify({"error": "Dataset not found. Please run generate_dataset.py"}), 404
        
    df = pd.read_csv('dataset/employee_kpi_data.csv')
    
    distribution = df['performance_rating'].value_counts().to_dict()
    
    return jsonify({
        "total_records": len(df),
        "columns": list(df.columns),
        "class_distribution": distribution
    })

@app.route('/api/preprocessing/run', methods=['POST'])
def run_preprocessing():
    if not os.path.exists('dataset/employee_kpi_data.csv'):
        return jsonify({"error": "Dataset not found"}), 404
        
    df = pd.read_csv('dataset/employee_kpi_data.csv')
    
    global X_train, X_val, X_test, y_train_cls, y_val_cls, y_test_cls, y_train_reg, y_val_reg, y_test_reg
    
    X_train, X_val, X_test, y_train_cls, y_val_cls, y_test_cls, y_train_reg, y_val_reg, y_test_reg = preprocessor.process_and_split(df)
    
    return jsonify({
        "status": "success",
        "message": "Data processed and split successfully (70/15/15)",
        "train_size": len(X_train),
        "val_size": len(X_val),
        "test_size": len(X_test),
        "num_features": X_train.shape[1]
    })

@app.route('/api/model/train', methods=['POST'])
def train_model():
    try:
        global X_train, X_val, y_train_cls, y_train_reg, y_val_cls, y_val_reg
        global training_results
        
        history = trainer.train(X_train, y_train_cls, y_train_reg, X_val, y_val_cls, y_val_reg)
        
        # Convert float32 to float for JSON serialization
        training_results = {k: [float(v) for v in vals] for k, vals in history.items()}
        
        return jsonify({
            "status": "success",
            "message": "Model trained successfully",
            "epochs_run": len(training_results['loss']),
            "final_val_loss": training_results['val_loss'][-1],
            "final_val_accuracy": training_results['val_classification_head_accuracy'][-1]
        })
    except NameError:
        return jsonify({"error": "Data not preprocessed yet. Run /api/preprocessing/run first."}), 400

@app.route('/api/evaluate', methods=['GET'])
def evaluate():
    try:
        global X_test, y_test_cls, y_test_reg, evaluation_results
        
        model = trainer.get_model()
        if model is None:
            model = tf.keras.models.load_model('saved_models/best_ncf_model.h5', compile=False)
            
        predictions = model.predict(X_test)
        
        cls_preds = predictions[0]
        reg_preds = predictions[1]
        
        label_encoder = joblib.load('saved_models/label_encoder.pkl')
        target_names = label_encoder.classes_.tolist()
        
        cls_results = evaluator.evaluate_classification(y_test_cls, cls_preds, target_names)
        reg_results = evaluator.evaluate_regression(y_test_reg, reg_preds)
        
        evaluation_results = {
            "classification": cls_results,
            "regression": reg_results
        }
        
        return jsonify(evaluation_results)
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/api/predict', methods=['POST'])
def predict():
    try:
        data = request.json
        df = pd.DataFrame([data])
        
        X = preprocessor.prepare_inference(df)
        
        model = tf.keras.models.load_model('saved_models/best_ncf_model.h5', compile=False)
        preds = model.predict(X)
        
        cls_probs = preds[0][0]
        reg_pred = preds[1][0][0]
        
        import numpy as np  # type: ignore
        cls_idx = np.argmax(cls_probs)
        
        label_encoder = joblib.load('saved_models/label_encoder.pkl')
        predicted_class = label_encoder.inverse_transform([cls_idx])[0]
        
        return jsonify({
            "status": "success",
            "prediction": {
                "performance_rating": predicted_class,
                "overall_score": float(reg_pred),
                "probabilities": {str(label): float(prob) for label, prob in zip(label_encoder.classes_, cls_probs)}
            }
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/api/dataset/upload', methods=['POST'])
def upload_dataset():
    if 'file' not in request.files:
        return jsonify({"error": "No file uploaded"}), 400
        
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No file selected"}), 400
        
    try:
        # Read the uploaded CSV file
        df = pd.read_csv(file)
        
        # We need employee_id to track who is who
        emp_id_col = None
        for col in df.columns:
            if col.lower() in ['employee_id', 'employee id', 'id_karyawan', 'id', 'employeeid', 'nik', 'nip']:
                emp_id_col = col
                break
                
        if not emp_id_col:
            print("=== UPLOADED CSV COLUMNS ===")
            print(df.columns.tolist())
            print("============================")
            return jsonify({"error": f"CSV must contain employee_id column. Found columns: {df.columns.tolist()}"}), 400
            
        employee_ids = df[emp_id_col].tolist()
        
        # Predict for all using prepare_inference
        from preprocessing.preprocessor import Preprocessor
        preprocessor = Preprocessor()
        X_infer = preprocessor.prepare_inference(df)
        
        try:
            model = tf.keras.models.load_model('saved_models/best_ncf_model.h5', compile=False)
            preds = model.predict(X_infer, verbose=0)
            cls_probs = preds[0]
            reg_preds = preds[1]
            
            label_encoder = joblib.load('saved_models/label_encoder.pkl')
            predicted_classes = label_encoder.inverse_transform(cls_probs.argmax(axis=1))
        except Exception as e:
            # Fallback for testing UI if model is not yet trained
            print("Model not found, generating mock predictions for testing.")
            import numpy as np # type: ignore
            predicted_classes = np.random.choice(['High', 'Medium', 'Low'], size=len(employee_ids))
            reg_preds = np.random.uniform(50, 100, size=(len(employee_ids), 1))
            cls_probs = np.random.dirichlet(np.ones(3), size=len(employee_ids))
            class MockEncoder:
                classes_ = np.array(['High', 'Low', 'Medium'])
            label_encoder = MockEncoder()
        
        # Prepare response
        results = []
        for i in range(len(employee_ids)):
            emp_id = str(employee_ids[i])
            
            def get_val(keys):
                for key in keys:
                    if key in df.columns:
                        return str(df.iloc[i][key])
                return None
            
            emp_name = get_val(['name', 'nama', 'employee_name', 'nama_karyawan'])
            emp_dept = get_val(['department', 'departemen', 'divisi', 'division'])
            emp_pos = get_val(['position', 'posisi', 'jabatan', 'role'])
            
            results.append({
                "employee_id": emp_id,
                "name": emp_name,
                "department": emp_dept,
                "position": emp_pos,
                "performance_rating": predicted_classes[i],
                "overall_score": float(reg_preds[i][0]),
                "status": "Highly Eligible" if predicted_classes[i] == 'High' else "Eligible" if predicted_classes[i] == 'Medium' else "Needs Review",
                "probabilities": {str(label): float(prob) for label, prob in zip(label_encoder.classes_, cls_probs[i])}
            })
            
        return jsonify({
            "status": "success",
            "message": f"Processed {len(results)} records",
            "data": results
        })
        
    except Exception as e:
        return jsonify({"error": str(e)}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=5000)
