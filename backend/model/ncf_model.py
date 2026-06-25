import tensorflow as tf
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Input, Dense, Dropout

def build_ncf_model(input_dim, num_classes=3):
    # Input
    inputs = Input(shape=(input_dim,), name='employee_features')
    
    # Shared layers (The "NCF" MLP part)
    x = Dense(128, activation='relu', name='shared_dense_1')(inputs)
    x = Dropout(0.3)(x)
    x = Dense(64, activation='relu', name='shared_dense_2')(x)
    x = Dropout(0.2)(x)
    x = Dense(32, activation='relu', name='shared_dense_3')(x)
    
    # Output Head 1: Classification (Performance Rating)
    classification_out = Dense(num_classes, activation='softmax', name='classification_head')(x)
    
    # Output Head 2: Regression (Overall Score)
    regression_out = Dense(1, activation='linear', name='regression_head')(x)
    
    model = Model(inputs=inputs, outputs=[classification_out, regression_out])
    
    # Compile
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
        loss={
            'classification_head': 'sparse_categorical_crossentropy',
            'regression_head': 'mse'
        },
        loss_weights={
            'classification_head': 1.0,
            'regression_head': 0.1  # Downweight regression loss slightly
        },
        metrics={
            'classification_head': 'accuracy',
            'regression_head': ['mae', 'mse']
        }
    )
    
    return model
