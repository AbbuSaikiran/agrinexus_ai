// Price Prediction & Crop Recommendation Screen
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/models.dart';
import '../../../data/services/mock_data_service.dart';
import '../../../core/theme/app_theme.dart';

class PredictScreen extends StatefulWidget {
  const PredictScreen({super.key});
  @override
  State<PredictScreen> createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  // Price prediction
  String _selectedCrop = 'Tomatoes';
  String _selectedMarket = 'Warangal APMC';
  PricePrediction? _prediction;
  List<Map<String, dynamic>>? _priceHistory;
  bool _isPredicting = false;
  // Crop recommendation
  double _nitrogen = 60;
  double _phosphorus = 50;
  double _potassium = 70;
  double _rainfall = 120;
  double _temperature = 25;
  List<CropRecommendation>? _recommendations;
  bool _isRecommending = false;

  final _crops = ['Tomatoes', 'Onions', 'Rice', 'Wheat', 'Mangoes', 'Bananas', 'Potatoes', 'Chilies', 'Turmeric'];
  final _markets = ['Warangal APMC', 'Hyderabad APMC', 'Guntur APMC', 'Nizamabad Market', 'Karimnagar Market'];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    setState(() { _isPredicting = true; _prediction = null; });
    final p = await MockDataService.predictPrice(_selectedCrop, _selectedMarket);
    final h = MockDataService.getPriceHistory(_selectedCrop);
    setState(() { _prediction = p; _priceHistory = h; _isPredicting = false; });
  }

  Future<void> _recommend() async {
    setState(() { _isRecommending = true; _recommendations = null; });
    final r = await MockDataService.recommendCrops(
      nitrogen: _nitrogen, phosphorus: _phosphorus, potassium: _potassium,
      rainfall: _rainfall, temperature: _temperature,
    );
    setState(() { _recommendations = r; _isRecommending = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandi Price Trends & Advisory'),
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: const [
            Tab(icon: Icon(Icons.query_stats_rounded), text: 'Market Forecast'),
            Tab(icon: Icon(Icons.eco_rounded), text: 'Crop Advisory'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [_buildPriceTab(), _buildRecommendTab()],
      ),
    );
  }

  Widget _buildPriceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Selectors
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Crop & Market', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _selectedCrop,
                    decoration: const InputDecoration(labelText: 'Crop', prefixIcon: Icon(Icons.grass, color: AppTheme.primaryGreen)),
                    items: _crops.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _selectedCrop = v!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedMarket,
                    decoration: const InputDecoration(labelText: 'Market', prefixIcon: Icon(Icons.store, color: AppTheme.primaryGreen)),
                    items: _markets.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (v) => setState(() => _selectedMarket = v!),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: _isPredicting ? null : _predict,
                    icon: _isPredicting ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.analytics_rounded),
                    label: Text(_isPredicting ? 'Fetching Live Mandi Trends...' : 'Analyze Market Rates'),
                  ),
                ],
              ),
            ),
          ),
          if (_prediction != null) ...[
            const SizedBox(height: 16),
            // Prediction Result Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppTheme.primaryGreen, Color(0xFF1B5E20)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text('Predicted Price', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text('₹${_prediction!.predictedPrice.toStringAsFixed(2)}/kg', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                  Text(_prediction!.trend, style: const TextStyle(color: Colors.white70, fontSize: 18)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _priceBadge('Min', '₹${_prediction!.minPrice.toStringAsFixed(0)}'),
                      const SizedBox(width: 10),
                      _priceBadge('Max', '₹${_prediction!.maxPrice.toStringAsFixed(0)}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Recommendation
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_prediction!.recommendation, style: const TextStyle(fontWeight: FontWeight.w500))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Price Chart
            if (_priceHistory != null) _buildChart(),
          ],
        ],
      ),
    );
  }

  Widget _buildChart() {
    final spots = _priceHistory!.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value['price'] as double))).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('7-Day Price History — $_selectedCrop', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.shade200, strokeWidth: 1)),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 44, getTitlesWidget: (v, _) => Text('₹${v.toInt()}', style: const TextStyle(fontSize: 10, color: AppTheme.textGrey)))),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                      final i = v.toInt();
                      if (i >= 0 && i < _priceHistory!.length) return Text(_priceHistory![i]['date'] as String, style: const TextStyle(fontSize: 9, color: AppTheme.textGrey));
                      return const SizedBox();
                    })),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: AppTheme.primaryGreen,
                      barWidth: 2.5,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: true, color: AppTheme.primaryGreen.withOpacity(0.1)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceBadge(String label, String val) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
    child: Column(children: [Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)), Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))]),
  );

  Widget _buildRecommendTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter Soil & Climate Data', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  _slider('Nitrogen (N)', _nitrogen, 0, 140, (v) => setState(() => _nitrogen = v)),
                  _slider('Phosphorus (P)', _phosphorus, 0, 145, (v) => setState(() => _phosphorus = v)),
                  _slider('Potassium (K)', _potassium, 0, 205, (v) => setState(() => _potassium = v)),
                  _slider('Rainfall (mm)', _rainfall, 20, 300, (v) => setState(() => _rainfall = v)),
                  _slider('Temperature (°C)', _temperature, 8, 44, (v) => setState(() => _temperature = v)),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: _isRecommending ? null : _recommend,
                    icon: _isRecommending ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.recommend),
                    label: Text(_isRecommending ? 'Analyzing...' : 'Get Recommendations'),
                  ),
                ],
              ),
            ),
          ),
          if (_recommendations != null) ...[
            const SizedBox(height: 20),
            const Text('Recommended Crops', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            ..._recommendations!.map(_buildRecommendCard),
          ],
        ],
      ),
    );
  }

  Widget _slider(String label, double value, double min, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text(value.toStringAsFixed(0), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen)),
          ],
        ),
        Slider(value: value, min: min, max: max, onChanged: onChanged, activeColor: AppTheme.primaryGreen, inactiveColor: Colors.grey.shade200),
      ],
    );
  }

  Widget _buildRecommendCard(CropRecommendation crop) {
    final color = crop.suitabilityScore >= 85 ? AppTheme.primaryGreen : crop.suitabilityScore >= 70 ? AppTheme.accentGold : AppTheme.textGrey;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.grass_rounded, color: AppTheme.primaryGreen, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(crop.cropName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    Text('${crop.season} • ${crop.expectedYield}', style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.1), border: Border.all(color: color, width: 2)),
                    child: Center(child: Text('${crop.suitabilityScore.toInt()}%', style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 12))),
                  ),
                  const Text('Match', style: TextStyle(fontSize: 10, color: AppTheme.textGrey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(crop.reason, style: const TextStyle(fontSize: 13, color: AppTheme.textGrey, height: 1.4)),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.currency_rupee, size: 14, color: AppTheme.primaryGreen),
            Text(' Expected price: ₹${crop.expectedPrice.toStringAsFixed(0)}/kg', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryGreen)),
          ]),
        ],
      ),
    );
  }
}
