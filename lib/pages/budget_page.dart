import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trackwise/theme/colors.dart';
import 'package:trackwise/json/day_month.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int activeMonth = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset('assets/images/budget.jpg', fit: BoxFit.cover),
          ),
          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                AppBar(
                  title: const Text('Budget Manager'),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: true,
                ),
                buildMonthSelector(),
                chartCard("Weekly Budget Usage", buildLineChart()),
                chartCard("Category Allocation", buildBarChart()),
                chartCard("Spending Breakdown", buildPieChart()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMonthSelector() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => setState(() => activeMonth = index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: activeMonth == index ? primary : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: activeMonth == index ? primary : Colors.grey.shade300,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    months[index]['label']!,
                    style: TextStyle(
                      color: activeMonth == index ? white : black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    months[index]['day']!,
                    style: TextStyle(
                      color: activeMonth == index ? white : Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget chartCard(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: grey.withOpacity(0.05),
              spreadRadius: 10,
              blurRadius: 3,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(height: 200, child: child),
          ],
        ),
      ),
    );
  }

  Widget buildLineChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: primary,
            barWidth: 4,
            spots: const [
              FlSpot(0, 200),
              FlSpot(1, 300),
              FlSpot(2, 250),
              FlSpot(3, 400),
              FlSpot(4, 350),
              FlSpot(5, 450),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                return Text(
                  days[value.toInt()],
                  style: const TextStyle(fontSize: 10),
                );
              },
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget buildBarChart() {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [BarChartRodData(toY: 300, color: blue, width: 15)],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [BarChartRodData(toY: 150, color: red, width: 15)],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [BarChartRodData(toY: 200, color: primary, width: 15)],
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Food');
                  case 1:
                    return const Text('Rent');
                  case 2:
                    return const Text('Others');
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget buildPieChart() {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 30,
        sections: [
          PieChartSectionData(value: 40, title: "Food", color: red, radius: 50),
          PieChartSectionData(
            value: 30,
            title: "Rent",
            color: blue,
            radius: 50,
          ),
          PieChartSectionData(
            value: 20,
            title: "Bills",
            color: primary,
            radius: 50,
          ),
          PieChartSectionData(
            value: 10,
            title: "Other",
            color: Colors.green,
            radius: 50,
          ),
        ],
      ),
    );
  }
}
