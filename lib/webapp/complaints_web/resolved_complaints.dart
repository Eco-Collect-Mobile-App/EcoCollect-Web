import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_web/webapp/complaints_web/pending_complaints.dart';
import 'package:eco_web/webapp/complaints_web/report_complaints.dart';
import 'package:eco_web/webapp/screens/dRegistration.dart';
import 'package:eco_web/webapp/screens/driverDetails.dart';
import 'package:eco_web/webapp/screens/home_screen.dart';
import 'package:eco_web/webapp/screens/userDetails.dart';
import 'package:flutter/material.dart';

class ResolvedComplaints extends StatefulWidget {
  const ResolvedComplaints({super.key});

  @override
  _ResolvedComplaintsState createState() => _ResolvedComplaintsState();
}

class _ResolvedComplaintsState extends State<ResolvedComplaints> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff27AE60),
        title: const Row(
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
            Icon(Icons.person_rounded, color: Colors.white),
          ],
        ),
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 300, // Width of the sidebar
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PendingComplaints()),
                    );
                  },
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResolvedComplaints()),
                    );
                  },
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ComplaintsReportPage()),
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                ListTile(
                  leading: const Icon(Icons.person, color: Color(0xff27AE60)),
                  title: const Text(
                    'App Users',
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
                    'Driver Registration',
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
                    'Contact',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {},
                ),
                // Log out button at the bottom
                const Spacer(), // Pushes the logout button to the bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                    icon: const Icon(Icons.logout, color: Color(0xff27AE60)),
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
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start, 
                children: [
                  const SizedBox(height: 15),
                  const Text(
                    'Resolved User Complaints',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 20),

                  // Search TextField
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Complaints',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),

                  const SizedBox(height: 40),

                  // Complaints Data Table
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Complaints')
                        .where('Status', isEqualTo: 'resolved')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('No resolved complaints found.'));
                      }

                      // Filter the data based on the search query
                      var filteredDocs = snapshot.data!.docs.where((doc) {
                        String name = doc['Name'].toLowerCase();
                        String email = doc['Email'].toLowerCase();
                        String location = doc['Location'].toLowerCase();
                        String description = doc['Description'].toLowerCase();
                        return name.contains(_searchQuery) ||
                            email.contains(_searchQuery) ||
                            location.contains(_searchQuery) ||
                            description.contains(_searchQuery);
                      }).toList();

                      // Check if filtered results are empty
                      if (filteredDocs.isEmpty) {
                        return const Center(
                            child: Text('No search results found.'));
                      }

                      return SingleChildScrollView(
                        scrollDirection:Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20,
                          columns: const [
                            DataColumn(
                                label: Text('Name',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87))),
                            DataColumn(
                                label: Text('Email',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87))),
                            DataColumn(
                                label: Text('Location',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87))),
                            DataColumn(
                                label: Text('Description',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87))),
                            DataColumn(
                                label: Text('Date',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87))),
                          ],
                          rows: filteredDocs.map((complaint) {
                            return DataRow(cells: [
                              DataCell(SizedBox(
                                width: 100, // Fixed width for the Name column
                                child: Text(complaint['Name']),
                              )),
                              DataCell(SizedBox(
                                width: 200, // Fixed width for the Email column
                                child: Text(complaint['Email']),
                              )),
                              DataCell(SizedBox(
                                width: 250, // Fixed width for the Location column
                                child: Text(complaint['Location']),
                              )),
                              DataCell(SizedBox(
                                width: 400, // Fixed width for the Description column
                                child: Text(
                                  complaint['Description'],
                                  maxLines: 3, // Limit to 3 lines for readability
                                  overflow: TextOverflow.ellipsis, // Handle text overflow
                                ),
                              )),
                              DataCell(SizedBox(
                                width: 100, // Fixed width for the Date column
                                child: Text(complaint['Date']),
                              )),
                            ]);
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
