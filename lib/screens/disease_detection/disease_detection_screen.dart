import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../theme/app_theme.dart';

enum DetectionResult { healthy, disease, noPlant }

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;
  Interpreter? _interpreterDisease;
  Interpreter? _interpreterPlant;
  List<String> _labelsDisease = [];

  @override
  void initState() {
    super.initState();
    _loadModels();
  }

  @override
  void dispose() {
    _interpreterDisease?.close();
    _interpreterPlant?.close();
    super.dispose();
  }

  Future<void> _loadModels() async {
    try {
      debugPrint('Loading Disease Model...');
      // Load Disease Model (Binary: Healthy vs Disease)
      _interpreterDisease = await Interpreter.fromAsset(
        'assets/models/final_multicrop_model.tflite',
      );
      debugPrint('Disease Model loaded.');

      debugPrint('Loading Disease Labels...');
      final diseaseLabelsData = await rootBundle.loadString(
        'assets/models/labels.txt',
      );
      _labelsDisease = diseaseLabelsData.split('\n');
      debugPrint('Disease Labels loaded.');
    } catch (e) {
      debugPrint('Error loading Disease model: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading Disease model: $e')),
        );
      }
    }

    try {
      debugPrint('Loading Plant Model (MobileNet)...');
      // Load Plant Detection Model (MobileNet: 1001 classes)
      // Note: Trying explicit v1 model if available, otherwise default
      _interpreterPlant = await Interpreter.fromAsset(
        'assets/models/mobilenet.tflite',
      );
      debugPrint('Plant Model loaded.');

      debugPrint('Loading Plant Labels...');
      debugPrint('Plant Labels loaded.');
    } catch (e) {
      debugPrint('Error loading Plant model: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading Plant model: $e')),
        );
      }
    }

    if (_interpreterDisease != null && _interpreterPlant != null) {
      debugPrint('All models and labels loaded successfully');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error capturing image: $e')));
    }
  }

  Future<void> _analyzeImageWithApi() async {
    debugPrint('Analyzing image with API...');
    if (_image == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final uri = Uri.parse(
        'http://172.20.10.4:5001/predict',
      ); // Updated with your detected IP
      var request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath('file', _image!.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String label = data['label'];
        final double confidence = data['confidence'];

        DetectionResult result;
        if (label.toLowerCase() == 'healthy') {
          result = DetectionResult.healthy;
        } else {
          result = DetectionResult.disease;
        }

        if (mounted) {
          _showResultDialog(result, label: label, confidence: confidence);
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Re-throw to trigger fallback in _analyzeImage
      throw Exception('API Failed: $e');
    } finally {
      // Only reset state if we are NOT falling back (i.e. success or critical error)
      // But since we re-throw, the catch block in _analyzeImage will handle the fallback
      // We should NOT set _isAnalyzing to false here if we are going to fallback immediately.
      // However, for simplicity, let's let the caller handle the loading state.
    }
  }

  Future<void> _analyzeImage() async {
    // Try API first
    try {
      await _analyzeImageWithApi();
    } catch (e) {
      debugPrint(
        'API analysis failed: $e. Falling back to local TFLite model.',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Server unreachable. Using offline mode.'),
          ),
        );
      }
      await _analyzeImageWithTFLite();
    }
  }

  Future<void> _analyzeImageWithTFLite() async {
    debugPrint('Analyzing image locally with TFLite...');
    if (_image == null) return;

    if (_interpreterDisease == null || _interpreterPlant == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offline models not loaded.')),
        );
      }
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // 1. Read and resize image
      final imageData = await _image!.readAsBytes();
      final image = img.decodeImage(imageData);
      if (image == null) throw Exception('Could not decode image');

      final imageInput = img.copyResize(image, width: 224, height: 224);

      // 2. Prepare input tensor
      final input = [
        List.generate(
          224,
          (y) => List.generate(224, (x) {
            final pixel = imageInput.getPixel(x, y);
            return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
          }),
        ),
      ];

      // --- Step 1: Check if it's a plant using MobileNet ---
      // (Optional: You can uncomment this if you want strict plant checking offline too)
      /*
      final plantOutput = [List<double>.filled(1001, 0.0)];
      _interpreterPlant!.run(input, plantOutput);
      ...
      */

      // --- Step 2: Detect disease ---
      final outputTensor = _interpreterDisease!.getOutputTensor(0);
      final outputShape = outputTensor.shape;
      final int numClasses = outputShape[1];
      final outputList = [List<double>.filled(numClasses, 0.0)];

      _interpreterDisease!.run(input, outputList);

      final result = outputList[0];

      // Determine result (assuming Index 0 = Disease, Index 1 = Healthy from previous knowledge)
      // Or finding max score
      int maxIndex = 0;
      double maxScore = 0;
      for (int i = 0; i < result.length; i++) {
        if (result[i] > maxScore) {
          maxScore = result[i];
          maxIndex = i;
        }
      }

      final label = _labelsDisease.length > maxIndex
          ? _labelsDisease[maxIndex]
          : 'Unknown';

      DetectionResult finalResult;
      if (label.toLowerCase().contains('healthy')) {
        finalResult = DetectionResult.healthy;
      } else {
        finalResult = DetectionResult.disease;
      }

      if (mounted) {
        _showResultDialog(finalResult, label: label, confidence: maxScore);
      }
    } catch (e) {
      debugPrint('Local analysis error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Offline analysis failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  void _showResultDialog(
    DetectionResult result, {
    required String label,
    required double confidence,
  }) {
    String title;
    String content;
    IconData icon;
    Color color;

    switch (result) {
      case DetectionResult.noPlant:
        title = 'No Plant Detected';
        content =
            'The image does not appear to contain a plant. Detected: ${label ?? "Unknown"} (${((confidence ?? 0) * 100).toStringAsFixed(1)}%).\nPlease ensure the plant is clearly visible and centered in the frame.';
        icon = Icons.warning_amber_rounded;
        color = Colors.orange;
        break;
      case DetectionResult.healthy:
        title = 'Plant Detected';
        content =
            'Identified as: Plant (${((confidence ?? 0) * 100).toStringAsFixed(1)}%).\n\nNote: This is a generic object detection model. For disease detection, please provide a specialized model.';
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case DetectionResult.disease:
        title = 'Disease Detected';
        content = 'Potential issues found. We recommend further inspection.';
        icon = Icons.error_outline;
        color = Colors.red;
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(color: color)),
          ],
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disease Detection')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(_image!, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No image selected',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _getImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Capture'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _getImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppTheme.primaryGreen),
                      foregroundColor: AppTheme.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_image != null)
              ElevatedButton(
                onPressed: _isAnalyzing ? null : _analyzeImage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: _isAnalyzing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Analyze Image',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
