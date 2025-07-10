import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showBalance = false;
  bool showBankDetails = false;

  String bankName = "HDFC Bank";
  double balance = 500.90;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/profile.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              color: Colors.black.withOpacity(0.4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "TrackWise",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Profile Picture + Credit
                  Row(
                    children: [
                      SizedBox(
                        width: (size.width - 40) * 0.4,
                        child: Stack(
                          children: [
                            RotatedBox(
                              quarterTurns: -2,
                              child: CircularPercentIndicator(
                                circularStrokeCap: CircularStrokeCap.round,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                radius: 100.0,
                                lineWidth: 6.0,
                                percent: 0.73,
                                progressColor: Colors.blueAccent,
                              ),
                            ),
                            const Positioned(
                              top: 12,
                              left: 14,
                              child: CircleAvatar(
                                radius: 45.5,
                                backgroundImage: AssetImage(
                                  "assets/images/dp.jpg",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: (size.width - 40) * 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Lakshya Mehndiratta",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Credit Score: 79.50",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(179, 247, 243, 243),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Show Bank Button
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() => showBankDetails = !showBankDetails);
                    },
                    icon: const Icon(Icons.account_balance),
                    label: Text(
                      showBankDetails
                          ? "Hide Bank Details"
                          : "Click to See Your Bank",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (showBankDetails)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bankName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                showBalance
                                    ? "\$${balance.toStringAsFixed(2)}"
                                    : "********",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              showBalance
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() => showBalance = !showBalance);
                            },
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 30),

                  // Navigation Buttons
                  navButton(
                    context,
                    "OCR Scanner",
                    "/ocr",
                    Icons.document_scanner,
                  ),
                  const SizedBox(height: 10),
                  navButton(
                    context,
                    "Chatbot Assistant",
                    "/chat",
                    Icons.chat_bubble_outline,
                  ),
                  const SizedBox(height: 10),
                  navButton(
                    context,
                    "Budget Manager",
                    "/budget",
                    Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 10),
                  navButton(
                    context,
                    "Spending Stats",
                    "/stats",
                    Icons.bar_chart,
                  ),
                  const SizedBox(height: 10),
                  navButton(
                    context,
                    "Daily Transactions",
                    "/daily",
                    Icons.today,
                  ),
                  const SizedBox(height: 10),
                  navButton(
                    context,
                    "Personal Details",
                    "/personal_details",
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget navButton(
    BuildContext context,
    String title,
    String route,
    IconData icon,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 99, 108, 255),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
