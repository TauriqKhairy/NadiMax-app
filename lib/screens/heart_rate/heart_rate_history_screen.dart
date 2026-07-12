import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../providers/heart_rate_provider.dart';
import '../../models/heart_rate_model.dart';

class HeartRateHistoryScreen extends StatefulWidget {
  const HeartRateHistoryScreen({super.key});

  @override
  State<HeartRateHistoryScreen> createState() => _HeartRateHistoryScreenState();
}

class _HeartRateHistoryScreenState extends State<HeartRateHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HeartRateProvider>().fetchHistory();
    });
  }

  String _formatTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd MMM, HH:mm').format(date);
    } catch (e) {
      return isoDate;
    }
  }

  Color _bpmColor(int bpm) {
    if (bpm < 100) return Colors.green;
    if (bpm < 140) return Colors.orange;
    return const Color(0xFFE53950);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History BPM')),
      body: SafeArea(
        child: Consumer<HeartRateProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFE53950)),
              );
            }

            if (provider.history.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.show_chart_outlined,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada data BPM',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            // Urutkan dari lama ke baru khusus untuk grafik (biar garis maju ke kanan)
            final chartData = provider.history.reversed.toList();

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Grafik
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey[200]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Grafik BPM Terakhir',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(
                                show: true,
                                drawVerticalLine: false,
                              ),
                              titlesData: const FlTitlesData(
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 32,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              minY: 50,
                              maxY: 180,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: List.generate(chartData.length, (i) {
                                    return FlSpot(
                                      i.toDouble(),
                                      chartData[i].bpm.toDouble(),
                                    );
                                  }),
                                  isCurved: true,
                                  color: const Color(0xFFE53950),
                                  barWidth: 3,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: const Color(
                                      0xFFE53950,
                                    ).withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Riwayat Detail',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                ...provider.history.map((hr) => _buildHistoryTile(hr)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHistoryTile(HeartRateModel hr) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bpmColor(hr.bpm).withOpacity(0.1),
          child: Icon(Icons.favorite, color: _bpmColor(hr.bpm), size: 20),
        ),
        title: Text(
          '${hr.bpm} BPM',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_formatTime(hr.measuredAt)),
        trailing: hr.spo2 != null
            ? Text(
                'SpO2 ${hr.spo2}%',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              )
            : null,
      ),
    );
  }
}
