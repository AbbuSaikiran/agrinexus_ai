// Crop Scan Screen — Disease Detection & Quality Assessment
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../data/models/models.dart';
import '../../../data/services/mock_data_service.dart';
import '../../../core/theme/app_theme.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  File? _imageFile;
  bool _isLoading = false;
  DiseaseReport? _diseaseResult;
  Map<String, dynamic>? _qualityResult;
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() { _activeTab = _tabCtrl.index; _diseaseResult = null; _qualityResult = null; _imageFile = null; }));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: source, imageQuality: 70);
    if (img == null) return;
    setState(() { _imageFile = File(img.path); _diseaseResult = null; _qualityResult = null; });
    _analyze();
  }

  Future<void> _analyze() async {
    setState(() => _isLoading = true);
    if (_activeTab == 0) {
      final r = await MockDataService.detectDisease();
      setState(() { _diseaseResult = r; _isLoading = false; });
    } else {
      final r = await MockDataService.assessQuality();
      setState(() { _qualityResult = r; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Health & Quality Scanner'),
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: const [
            Tab(icon: Icon(Icons.bug_report_outlined), text: 'Disease Detection'),
            Tab(icon: Icon(Icons.grade_outlined), text: 'Quality Grade'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Image Area
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.lightBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: _imageFile != null
                  ? Stack(
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(_imageFile!, width: double.infinity, fit: BoxFit.cover)),
                        if (_isLoading)
                          Container(
                            decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(color: Colors.white),
                                  SizedBox(height: 10),
                                  Text('Diagnosing Crop Health...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.document_scanner_rounded, size: 44, color: AppTheme.primaryGreen),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _activeTab == 0 ? 'Take a photo of a leaf' : 'Take a photo of your crop',
                          style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark),
                        ),
                        const SizedBox(height: 4),
                        const Text('AI will analyze it instantly', style: TextStyle(color: AppTheme.textGrey, fontSize: 13)),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            // Camera / Gallery buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Results
            if (_diseaseResult != null) _buildDiseaseResult(_diseaseResult!),
            if (_qualityResult != null) _buildQualityResult(_qualityResult!),
            if (!_isLoading && _imageFile == null) _buildTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseResult(DiseaseReport r) {
    final isHealthy = r.disease == 'Healthy Plant';
    final isHigh = r.severity == 'High';
    final color = isHealthy ? AppTheme.successGreen : isHigh ? AppTheme.errorRed : AppTheme.warningOrange;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(isHealthy ? '✅' : isHigh ? '🔴' : '🟡', style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(r.disease, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: color))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _resultBadge('Confidence', '${r.confidence.toStringAsFixed(1)}%', Colors.blue),
                      const SizedBox(width: 10),
                      _resultBadge('Severity', r.severity, color),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Recommendation:', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(r.advice, style: const TextStyle(height: 1.5, color: AppTheme.textDark)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityResult(Map<String, dynamic> r) {
    final grade = r['grade'] as String;
    final score = r['score'] as int;
    final gradeColor = grade == 'A+' ? AppTheme.successGreen : grade == 'A' ? AppTheme.primaryGreen : grade == 'B' ? AppTheme.accentGold : AppTheme.textGrey;
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: gradeColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: gradeColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 70, height: 70,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: gradeColor),
                    child: Center(child: Text(grade, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Quality Grade', style: TextStyle(fontSize: 13, color: AppTheme.textGrey)),
                        Text('Grade $grade', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: gradeColor)),
                        Text('Score: $score / 100', style: const TextStyle(fontSize: 13, color: AppTheme.textGrey)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LinearProgressIndicator(value: score / 100, backgroundColor: Colors.grey.shade200, color: gradeColor, minHeight: 8, borderRadius: BorderRadius.circular(4)),
              const SizedBox(height: 14),
              Text(r['notes'] as String, style: const TextStyle(height: 1.5, color: AppTheme.textDark)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultBadge(String label, String val, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.3))),
    child: Text('$label: $val', style: TextStyle(fontWeight: FontWeight.w600, color: color, fontSize: 12)),
  );

  Widget _buildTips() => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tips for best results:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 10),
        ...[
          '📸 Take photos in good natural light',
          '🍃 Focus on the affected area of the leaf',
          '📏 Keep camera 20–30 cm from the plant',
          '🔄 Take multiple photos for better accuracy',
        ].map((t) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(children: [Text(t, style: const TextStyle(color: AppTheme.textGrey, fontSize: 13))]),
        )),
      ],
    ),
  );
}
