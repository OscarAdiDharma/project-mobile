from sklearn.metrics import confusion_matrix, accuracy_score, precision_score, recall_score, f1_score, mean_squared_error, mean_absolute_error
import numpy as np

class Evaluator:
    def __init__(self):
        pass
        
    def evaluate_classification(self, y_true, y_pred_probs, target_names=['Low', 'Medium', 'High']):
        y_pred = np.argmax(y_pred_probs, axis=1)
        
        # Confusion Matrix 3x3
        cm = confusion_matrix(y_true, y_pred)
        
        # Metrics
        accuracy = accuracy_score(y_true, y_pred)
        precision = precision_score(y_true, y_pred, average=None)
        recall = recall_score(y_true, y_pred, average=None)
        f1 = f1_score(y_true, y_pred, average=None)
        
        macro_precision = precision_score(y_true, y_pred, average='macro')
        macro_recall = recall_score(y_true, y_pred, average='macro')
        macro_f1 = f1_score(y_true, y_pred, average='macro')
        
        results = {
            'confusion_matrix': cm.tolist(),
            'accuracy': float(accuracy),
            'per_class': {
                name: {
                    'precision': float(p),
                    'recall': float(r),
                    'f1_score': float(f)
                } for name, p, r, f in zip(target_names, precision, recall, f1)
            },
            'macro_avg': {
                'precision': float(macro_precision),
                'recall': float(macro_recall),
                'f1_score': float(macro_f1)
            }
        }
        return results

    def evaluate_regression(self, y_true, y_pred):
        y_pred = y_pred.flatten()
        
        mse = mean_squared_error(y_true, y_pred)
        rmse = np.sqrt(mse)
        mae = mean_absolute_error(y_true, y_pred)
        
        results = {
            'mse': float(mse),
            'rmse': float(rmse),
            'mae': float(mae)
        }
        return results
