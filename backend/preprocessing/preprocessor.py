import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder
import os
import joblib

class Preprocessor:
    def __init__(self):
        self.scaler = StandardScaler()
        self.label_encoder = LabelEncoder()
        
    def process_and_split(self, df):
        # Drop ID
        if 'employee_id' in df.columns:
            df = df.drop(columns=['employee_id'])
            
        # Target
        y_class = df['performance_rating']
        y_class_encoded = self.label_encoder.fit_transform(y_class)
        
        # Calculate a pseudo "overall score" for the regression head
        # Based on average of the 1-10 scores, multiplied by 10 to make it 0-100
        score_cols = [c for c in df.columns if 'score' in c and c not in ['speech_sentiment_score', 'client_satisfaction_score']]
        if score_cols:
            y_reg = df[score_cols].mean(axis=1) * 10
        else:
            y_reg = np.random.uniform(50, 100, size=len(df))
            
        y_combined = np.column_stack((y_class_encoded, y_reg))
        
        # Features
        X = df.drop(columns=['performance_rating'])
        
        # Scale
        X_scaled = self.scaler.fit_transform(X)
        
        # Save models
        os.makedirs('saved_models', exist_ok=True)
        joblib.dump(self.scaler, 'saved_models/scaler.pkl')
        joblib.dump(self.label_encoder, 'saved_models/label_encoder.pkl')
        
        # Split 70/15/15
        # First split into 70% train and 30% temp
        X_train, X_temp, y_train, y_temp = train_test_split(X_scaled, y_combined, test_size=0.3, random_state=42, stratify=y_class_encoded)
        
        # Then split temp into 50% val and 50% test (which is 15% / 15% of total)
        X_val, X_test, y_val, y_test = train_test_split(X_temp, y_temp, test_size=0.5, random_state=42, stratify=y_temp[:, 0])
        
        # Extract back to separated targets
        y_train_cls, y_train_reg = y_train[:, 0], y_train[:, 1]
        y_val_cls, y_val_reg = y_val[:, 0], y_val[:, 1]
        y_test_cls, y_test_reg = y_test[:, 0], y_test[:, 1]
        
        return X_train, X_val, X_test, y_train_cls, y_val_cls, y_test_cls, y_train_reg, y_val_reg, y_test_reg
        
    def prepare_inference(self, df):
        # Load scaler
        scaler = joblib.load('saved_models/scaler.pkl')
        
        if 'employee_id' in df.columns:
            df = df.drop(columns=['employee_id'])
        if 'performance_rating' in df.columns:
            df = df.drop(columns=['performance_rating'])
            
        return scaler.transform(df)
