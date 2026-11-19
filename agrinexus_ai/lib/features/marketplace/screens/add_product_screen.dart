// Add Product / Listing Screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../../../providers/marketplace_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../data/models/models.dart';
import '../../../data/services/mock_data_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedCategory = AppConstants.cropCategories.first;
  File? _imageFile;
  String? _aiGrade;
  bool _isAssessing = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _qtyCtrl.dispose(); _priceCtrl.dispose();
    _locationCtrl.dispose(); _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (img == null) return;
    setState(() { _imageFile = File(img.path); _aiGrade = null; });
    _assessQuality();
  }

  Future<void> _assessQuality() async {
    setState(() => _isAssessing = true);
    final result = await MockDataService.assessQuality();
    setState(() { _aiGrade = result['grade']; _isAssessing = false; });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final user = context.read<AuthProvider>().currentUser!;
    final product = ProductModel(
      id: const Uuid().v4(),
      farmerId: user.id,
      farmerName: user.name,
      name: _nameCtrl.text.trim(),
      category: _selectedCategory,
      quantity: double.tryParse(_qtyCtrl.text) ?? 0,
      unitPrice: double.tryParse(_priceCtrl.text) ?? 0,
      qualityGrade: _aiGrade ?? 'B',
      imageUrl: _imageFile?.path,
      location: _locationCtrl.text.trim(),
      status: 'Available',
      rating: 0,
      ratingCount: 0,
      createdAt: DateTime.now(),
      description: _descCtrl.text.trim(),
    );
    await context.read<MarketplaceProvider>().addProduct(product);
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Listing published successfully!'), backgroundColor: AppTheme.successGreen),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Listing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppTheme.lightBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: _imageFile != null
                      ? Stack(
                          children: [
                            ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.file(_imageFile!, width: double.infinity, fit: BoxFit.cover)),
                            if (_isAssessing)
                              const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)),
                            if (_aiGrade != null)
                              Positioned(
                                top: 10, right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: AppTheme.primaryGreen, borderRadius: BorderRadius.circular(20)),
                                  child: Text('AI Grade: $_aiGrade', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                ),
                              ),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 48, color: AppTheme.textGrey),
                            SizedBox(height: 8),
                            Text('Tap to add crop photo', style: TextStyle(color: AppTheme.textGrey)),
                            Text('AI will assess quality automatically', style: TextStyle(color: AppTheme.primaryGreen, fontSize: 12)),
                          ],
                        ),
                ),
              ),
              if (_aiGrade != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Text('🤖', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text('AI Quality Grade: $_aiGrade — Added to your listing', style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryGreen)),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Crop Name *', prefixIcon: Icon(Icons.grass, color: AppTheme.primaryGreen)),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category_outlined, color: AppTheme.primaryGreen)),
                items: AppConstants.cropCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Quantity (kg) *', prefixIcon: Icon(Icons.scale, color: AppTheme.primaryGreen)),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Price/kg (₹) *', prefixIcon: Icon(Icons.currency_rupee, color: AppTheme.primaryGreen)),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _locationCtrl,
                decoration: const InputDecoration(labelText: 'Location *', prefixIcon: Icon(Icons.location_on_outlined, color: AppTheme.primaryGreen)),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description (Optional)', prefixIcon: Icon(Icons.notes, color: AppTheme.primaryGreen), alignLabelWithHint: true),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.publish),
                label: Text(_isSaving ? 'Publishing...' : 'Publish Listing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
