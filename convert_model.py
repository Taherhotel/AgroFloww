import os
import tensorflow as tf

def convert_keras_to_tflite(keras_path, tflite_path):
    print(f"Loading Keras model from {keras_path}...")
    try:
        model = tf.keras.models.load_model(keras_path)
        
        print("Converting to TFLite...")
        converter = tf.lite.TFLiteConverter.from_keras_model(model)
        # Optional: Optimizations
        # converter.optimizations = [tf.lite.Optimize.DEFAULT]
        
        tflite_model = converter.convert()
        
        with open(tflite_path, 'wb') as f:
            f.write(tflite_model)
            
        print(f"Success! Model saved to {tflite_path}")
        
    except Exception as e:
        print(f"Error converting model: {e}")

if __name__ == "__main__":
    keras_file = "assets/models/final_multicrop_model.keras"
    tflite_file = "assets/models/final_multicrop_model.tflite"
    
    if os.path.exists(keras_file):
        convert_keras_to_tflite(keras_file, tflite_file)
    else:
        print(f"Error: {keras_file} not found.")
