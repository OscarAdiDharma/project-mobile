import os
import tensorflow as tf
from .ncf_model import build_ncf_model

class Trainer:
    def __init__(self):
        self.model = None
        self.history = None
        
    def train(self, X_train, y_train_cls, y_train_reg, X_val, y_val_cls, y_val_reg):
        input_dim = X_train.shape[1]
        
        # Num classes is unique classes in y_train_cls
        import numpy as np
        num_classes = len(np.unique(y_train_cls))
        
        self.model = build_ncf_model(input_dim, num_classes)
        
        # Callbacks
        os.makedirs('saved_models', exist_ok=True)
        checkpoint = tf.keras.callbacks.ModelCheckpoint(
            'saved_models/best_ncf_model.h5', 
            monitor='val_loss', 
            save_best_only=True,
            mode='min'
        )
        early_stopping = tf.keras.callbacks.EarlyStopping(
            monitor='val_loss',
            patience=10,
            restore_best_weights=True
        )
        
        # Train
        self.history = self.model.fit(
            X_train, 
            {'classification_head': y_train_cls, 'regression_head': y_train_reg},
            validation_data=(X_val, {'classification_head': y_val_cls, 'regression_head': y_val_reg}),
            epochs=100,
            batch_size=32,
            callbacks=[checkpoint, early_stopping],
            verbose=1
        )
        
        return self.history.history

    def get_model(self):
        return self.model
