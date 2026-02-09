import os
import numpy as np
from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import io
from PIL import Image

app = Flask(__name__)

# Configuration
MODEL_PATH = 'assets/models/final_multicrop_model.keras'
# Define your classes here based on model training
# Example: ['Disease', 'Healthy'] or specific diseases
CLASS_LABELS = ['Disease', 'Healthy'] 

# Load Model
print(f"Loading model from {MODEL_PATH}...")
try:
    model = load_model(MODEL_PATH)
    print("Model loaded successfully!")
except Exception as e:
    print(f"Error loading model: {e}")
    model = None

def prepare_image(img_bytes):
    # Load image from bytes
    img = Image.open(io.BytesIO(img_bytes))
    
    # Resize to model input size (usually 224x224 for MobileNet/ResNet)
    # Check your model's expected input shape!
    img = img.resize((224, 224))
    
    # Convert to array and normalize
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array /= 255.0  # Normalize pixel values to [0,1]
    
    return img_array

@app.route('/predict', methods=['POST'])
def predict():
    if model is None:
        return jsonify({'error': 'Model not loaded'}), 500
        
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
        
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
        
    try:
        # Prepare image
        img_bytes = file.read()
        processed_image = prepare_image(img_bytes)
        
        # Predict
        prediction = model.predict(processed_image)
        
        # Process result
        # Assuming binary classification [Disease, Healthy] or similar
        # Adjust based on your model's specific output structure
        confidence_scores = prediction[0].tolist()
        
        # Find class with highest score
        max_score_index = np.argmax(confidence_scores)
        predicted_label = CLASS_LABELS[max_score_index] if max_score_index < len(CLASS_LABELS) else "Unknown"
        confidence = confidence_scores[max_score_index]
        
        response = {
            'label': predicted_label,
            'confidence': confidence,
            'raw_scores': confidence_scores
        }
        
        return jsonify(response)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy', 'model_loaded': model is not None})

if __name__ == '__main__':
    # Run on all interfaces so mobile app can access it via IP
    # Port 5000 is often taken by AirPlay on macOS, using 5001
    app.run(host='0.0.0.0', port=5001, debug=True)
