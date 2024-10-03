import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_web/webapp/screens/dRegistration.dart';
import 'package:eco_web/webapp/screens/driverDetails.dart';
import 'package:eco_web/webapp/screens/userDetails.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _ComplaintsWebHomeState();
}

class _ComplaintsWebHomeState extends State<HomeScreen> {
  int pendingCount = 0;
  int resolvedCount = 0;
  int userCount = 0; // Add variable for user count
  int driverCount = 0; // Add variable for driver count
  List<int> monthlyComplaints =
      List.generate(12, (_) => 0); // Initialize for 12 months

  @override
  void initState() {
    super.initState();
    _fetchComplaintCounts();
    _fetchMonthlyComplaints();
    _fetchUserAndDriverCounts(); // Fetch user and driver counts
  }

  Future<void> _fetchComplaintCounts() async {
    try {
      QuerySnapshot pendingSnapshot = await FirebaseFirestore.instance
          .collection('Complaints')
          .where('Status', isEqualTo: 'pending')
          .get();
      QuerySnapshot resolvedSnapshot = await FirebaseFirestore.instance
          .collection('Complaints')
          .where('Status', isEqualTo: 'resolved')
          .get();
      setState(() {
        pendingCount = pendingSnapshot.size;
        resolvedCount = resolvedSnapshot.size;
      });
    } catch (e) {
      print('Error fetching complaints: $e');
    }
  }

  Future<void> _fetchMonthlyComplaints() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Complaints').get();

      List<int> monthlyData =
          List.generate(12, (_) => 0); // Initialize for 12 months

      for (var doc in snapshot.docs) {
        String dateString =
            doc['Date']; // Assuming you have a 'Date' field as a string
        DateTime date =
            DateFormat('yyyy-MM-dd').parse(dateString); // Parse date string
        int month = date.month - 1; // Get month (January is 1)
        monthlyData[month]++;
      }

      setState(() {
        monthlyComplaints = monthlyData;
      });
    } catch (e) {
      print('Error fetching monthly complaints: $e');
    }
  }

  // New method to fetch user and driver counts
  Future<void> _fetchUserAndDriverCounts() async {
    try {
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      QuerySnapshot driverSnapshot =
          await FirebaseFirestore.instance.collection('drivers').get();

      setState(() {
        userCount = userSnapshot.size;
        driverCount = driverSnapshot.size;
      });
    } catch (e) {
      print('Error fetching user and driver counts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff27AE60),
        title: Row(
          children: [
            Expanded(
              child: Text(
                "EcoCollect",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.person_rounded, color: Colors.white)
          ],
        ),
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 300, // Set the width of the sidebar
            color: const Color.fromARGB(
                255, 224, 248, 225), // Sidebar background color
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30.0),
                ListTile(
                  leading:
                      const Icon(Icons.dashboard, color: Color(0xff27AE60)),
                  title: const Text(
                    'Dashboard',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                ListTile(
                  leading: const Icon(Icons.pending, color: Color(0xff27AE60)),
                  title: const Text(
                    'Pending Complaints',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: 10.0),
                ListTile(
                  leading: const Icon(Icons.check_circle_rounded,
                      color: Color(0xff27AE60)),
                  title: const Text(
                    'Resolved Complaints',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: 10.0),
                ListTile(
                  leading:
                      const Icon(Icons.bar_chart, color: Color(0xff27AE60)),
                  title: const Text(
                    'Complaint Reports',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: 10.0),
                ListTile(
                  leading: const Icon(Icons.person, color: Color(0xff27AE60)),
                  title: const Text(
                    'App usres',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                ListTile(
                  leading:
                      const Icon(Icons.fire_truck, color: Color(0xff27AE60)),
                  title: const Text(
                    'Drivers',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DriverDetailsPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                ListTile(
                  leading: const Icon(Icons.app_registration,
                      color: Color(0xff27AE60)),
                  title: const Text(
                    'Drever registration',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DriverRegistrationPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                ListTile(
                  leading:
                      const Icon(Icons.contact_phone, color: Color(0xff27AE60)),
                  title: const Text(
                    'Contatact',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {},
                ),

                // Log out button at the bottom
                Spacer(), // Pushes the logout button to the bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                    icon: Icon(Icons.logout, color: Color(0xff27AE60)),
                    tooltip: 'Log out',
                    onPressed: () {
                      // Add logout logic here
                      // You can navigate to a login page or clear any session info
                      Navigator.pop(context); // Example action to pop the page
                    },
                  ),
                ),
              ],
            ),
          ),
          // Main content area with scrolling
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  const Text(
                    'Complaints Dashboard',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    'Monitor and manage the status of all customer complaints, review pending cases and ensure prompt resolutions for improved service efficiency.',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30.0), // Space before cards

                  // Display complaint counts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildComplaintTab('Pending Complaints', pendingCount),
                      _buildComplaintTab('Resolved Complaints', resolvedCount),
                    ],
                  ),
                  const SizedBox(
                      height: 30.0), // Space before user and driver counts

                  // Display user and driver counts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildComplaintTab('Number of Users', userCount),
                      _buildComplaintTab('Number of Drivers', driverCount),
                    ],
                  ),
                  const SizedBox(height: 50.0), // Space before bar chart

                  // Bar chart showing complaints by month
                  const Text(
                    'Complaints Received Per Month',
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    height: 250.0,
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const months = [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'May',
                                  'Jun',
                                  'Jul',
                                  'Aug',
                                  'Sep',
                                  'Oct',
                                  'Nov',
                                  'Dec'
                                ];
                                return Text(months[value.toInt()]);
                              },
                            ),
                          ),
                        ),
                        barGroups: List.generate(12, (index) {
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: monthlyComplaints[index].toDouble(),
                                color: const Color(0xff27AE60),
                                width: 20,
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintTab(String title, int count) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: 300.0,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 205, 245, 206),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 22.0,
                color: Color.fromARGB(255, 16, 109, 19),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
