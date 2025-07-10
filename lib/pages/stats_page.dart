import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trackwise/json/day_month.dart';
import 'package:trackwise/theme/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int activeMonth = 0;
  String selectedYear = '2024';
  String? tappedValue;

  final ScreenshotController screenshotController = ScreenshotController();

  late final Map<String, List<Map<String, dynamic>>> yearData;

  @override
  void initState() {
    super.initState();
    yearData = {
      '2024': List.generate(
        12,
        (index) => {
          'income': 6000.0 + index * 500,
          'expense': 3000.0 + index * 300,
          'trend': List<double>.generate(
            5,
            (i) => 2000.0 + i * 100 + index * 100,
          ),
          'categories': {
            'Food': 2500 + index * 50,
            'Rent': 3000 - index * 20,
            'Travel': 2000 + index * 30,
            'Others': 1500,
          },
        },
      ),
      '2025': List.generate(
        12,
        (index) => {
          'income': 7000.0 + index * 600,
          'expense': 4000.0 + index * 400,
          'trend': List<double>.generate(
            5,
            (i) => 2500.0 + i * 150 + index * 120,
          ),
          'categories': {
            'Food': 2800,
            'Rent': 2600,
            'Travel': 2900,
            'Others': 1300,
          },
        },
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = yearData[selectedYear]![activeMonth];
    final income = data['income'] as double;
    final expense = data['expense'] as double;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/stats.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: white.withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        color: grey.withOpacity(0.01),
                        spreadRadius: 10,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 60,
                      right: 20,
                      left: 20,
                      bottom: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Stats",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: exportChart,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Year dropdown & Month chips
                        Row(
                          children: [
                            DropdownButton<String>(
                              value: selectedYear,
                              items: yearData.keys.map((String year) {
                                return DropdownMenuItem<String>(
                                  value: year,
                                  child: Text(year),
                                );
                              }).toList(),
                              onChanged: (String? newYear) {
                                setState(() {
                                  selectedYear = newYear!;
                                  activeMonth = 0;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(months.length, (
                                    index,
                                  ) {
                                    return GestureDetector(
                                      onTap: () =>
                                          setState(() => activeMonth = index),
                                      child: Container(
                                        width: 50,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              months[index]['label']!,
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: activeMonth == index
                                                    ? primary
                                                    : black.withOpacity(0.02),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: activeMonth == index
                                                      ? primary
                                                      : black.withOpacity(0.1),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6,
                                                    ),
                                                child: Text(
                                                  months[index]['day']!,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: activeMonth == index
                                                        ? white
                                                        : black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (tappedValue != null)
                          Text(
                            "Tapped: $tappedValue",
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Income vs Expense",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      toY: income,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: expense,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ],
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) =>
                                        Text('₹${value.toInt()}'),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return const Text("Income");
                                        case 1:
                                          return const Text("Expense");
                                        default:
                                          return const Text("");
                                      }
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: false),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Spending Categories",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 250,
                          child: PieChart(
                            PieChartData(
                              sections:
                                  (data['categories'] as Map<String, dynamic>)
                                      .entries
                                      .map((entry) {
                                        return PieChartSectionData(
                                          value: entry.value.toDouble(),
                                          title: entry.key,
                                          color: _getCategoryColor(entry.key),
                                          radius: 60,
                                          titleStyle: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        );
                                      })
                                      .toList(),
                              sectionsSpace: 2,
                              centerSpaceRadius: 30,
                            ),
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
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orange;
      case 'Rent':
        return Colors.blue;
      case 'Travel':
        return Colors.green;
      case 'Others':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Future<void> exportChart() async {
    try {
      final Uint8List? image = await screenshotController.capture();
      if (image == null) return;
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/stats_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(image);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Chart exported to ${file.path}')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to export chart')));
    }
  }
}
