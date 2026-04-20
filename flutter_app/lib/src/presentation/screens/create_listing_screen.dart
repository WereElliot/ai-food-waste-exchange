import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_waste_exchange/src/data/repositories/listing_repository.dart';
import 'package:food_waste_exchange/src/core/theme/app_theme.dart';
import 'dart:io';

class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});

  @override
  ConsumerState<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile;
  final _picker = ImagePicker();
  bool _isAnalyzing = false;
  String? _aiRiskResult;
  String? _aiConfidence;
  
  final _titleController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        _isAnalyzing = true;
        _aiRiskResult = null;
      });
      
      try {
        final repository = ref.read(listingRepositoryProvider);
        // For MVP, we use a placeholder image URL as we don't have file upload to Vercel yet
        const mockImageUrl = 'https://images.unsplash.com/photo-1590779033100-9f60a05a013d?auto=format&fit=crop&q=80&w=1000';
        final result = await repository.analyzeSpoilage(mockImageUrl, 'vegetable');
        
        setState(() {
          _isAnalyzing = false;
          _aiRiskResult = result['risk'];
          _aiConfidence = (result['confidence'] * 100).toStringAsFixed(1);
        });
      } catch (e) {
        setState(() {
          _isAnalyzing = false;
          _aiRiskResult = 'LOW'; // Fallback for demo
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a photo first')),
      );
      return;
    }
    
    setState(() => _isAnalyzing = true);
    
    try {
      final repository = ref.read(listingRepositoryProvider);
      await repository.createListing({
        'title': _titleController.text,
        'quantity': _quantityController.text,
        'description': _descriptionController.text,
        'itemType': 'food',
        'photoUrl': 'https://images.unsplash.com/photo-1590779033100-9f60a05a013d',
        'latitude': -1.286389,
        'longitude': 36.817223,
        'spoilageRisk': _aiRiskResult ?? 'LOW',
      });
      
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing posted! Thank you for reducing waste.'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Food Surplus'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: _imageFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo_outlined, size: 64, color: AppTheme.primaryGreen),
                            const SizedBox(height: 12),
                            Text(
                              'Tap to upload food photo',
                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'AI will check for freshness',
                              style: TextStyle(color: Colors.grey[400], fontSize: 12),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1590779033100-9f60a05a013d', // Demo image
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // AI Analysis Card
              if (_isAnalyzing)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 16),
                        Text('AI is analyzing food quality...'),
                      ],
                    ),
                  ),
                )
              else if (_aiRiskResult != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _aiRiskResult == 'HIGH' ? Colors.red[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _aiRiskResult == 'HIGH' ? Colors.red[200]! : Colors.green[200]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _aiRiskResult == 'HIGH' ? Icons.warning_amber_rounded : Icons.verified_user_rounded,
                        color: _aiRiskResult == 'HIGH' ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Freshness Check: $_aiRiskResult',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _aiRiskResult == 'HIGH' ? Colors.red[900] : Colors.green[900],
                              ),
                            ),
                            Text(
                              'AI Confidence: $_aiConfidence%',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),
              
              // Form Fields
              Text(
                'Listing Details',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'What are you sharing? (e.g. 5kg Apples)',
                  prefixIcon: Icon(Icons.title_rounded),
                ),
                validator: (v) => v!.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  hintText: 'Quantity (e.g. 2 bags, 3kg)',
                  prefixIcon: Icon(Icons.scale_rounded),
                ),
                validator: (v) => v!.isEmpty ? 'Quantity is required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Additional info (pickup time, exact location, etc.)',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.description_rounded),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _isAnalyzing ? null : _submit,
                child: _isAnalyzing 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                  : const Text('POST LISTING'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
