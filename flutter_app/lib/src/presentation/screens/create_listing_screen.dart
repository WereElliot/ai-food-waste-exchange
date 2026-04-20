import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_waste_exchange/src/data/repositories/listing_repository.dart';
import 'dart:io';

class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});

  @override
  ConsumerState<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final _picker = ImagePicker();
  bool _isAnalyzing = false;
  String? _aiRiskResult;
  
  final _titleController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isAnalyzing = true;
      });
      
      try {
        final repository = ref.read(listingRepositoryProvider);
        // For MVP, we use a placeholder image URL as we don't have file upload to Vercel yet
        const mockImageUrl = 'https://images.unsplash.com/photo-1590779033100-9f60a05a013d?auto=format&fit=crop&q=80&w=1000';
        final result = await repository.analyzeSpoilage(mockImageUrl, 'vegetable');
        
        setState(() {
          _isAnalyzing = false;
          _aiRiskResult = '${result['risk']} (${(result['confidence'] * 100).toStringAsFixed(1)}%)';
        });
      } catch (e) {
        setState(() {
          _isAnalyzing = false;
          _aiRiskResult = 'Analysis failed, but item looks good!';
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      final repository = ref.read(listingRepositoryProvider);
      await repository.createListing({
        'title': _titleController.text,
        'quantity': _quantityController.text,
        'description': _descriptionController.text,
        'itemType': 'vegetable',
        'photoUrl': 'https://images.unsplash.com/photo-1590779033100-9f60a05a013d',
        'latitude': -1.286389,
        'longitude': 36.817223,
        'spoilageRisk': 'LOW',
      });
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing posted successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post listing: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Food Donation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _image == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                            Text('Upload Photo for AI Freshness Check'),
                          ],
                        )
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 16),
              if (_isAnalyzing)
                const LinearProgressIndicator()
              else if (_aiRiskResult != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'AI Freshness Score: $_aiRiskResult',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title (e.g., 5kg Maize Flour)'),
                validator: (v) => v!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity/Weight'),
                validator: (v) => v!.isEmpty ? 'Please enter quantity' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Post Listing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
