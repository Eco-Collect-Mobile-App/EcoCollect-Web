import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_web/webapp/screens/dRegistration.dart';
import 'package:eco_web/webapp/screens/driverDetails.dart';
import 'package:eco_web/webapp/screens/home_screen.dart';
import 'package:eco_web/webapp/screens/userDetails.dart';
import 'package:flutter/material.dart';

class DriverDetailsPage extends StatefulWidget {
  @override
  _DriverDetailsPageState createState() => _DriverDetailsPageState();
}

class _DriverDetailsPageState extends State<DriverDetailsPage> {
  Stream<QuerySnapshot> getDriversStream() {
    return FirebaseFirestore.instance.collection('drivers').snapshots();
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
            const Icon(Icons.fire_truck, color: Colors.white)
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
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Registered Drivers',
                    style:
                        TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot>(
                    stream: getDriversStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: DataTable(
                          columnSpacing: 20.0,
                          headingRowColor: MaterialStateProperty.all(
                              const Color(0xff27AE60)),
                          headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                          dataTextStyle: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black87,
                          ),
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('NIC')),
                            DataColumn(label: Text('License No')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('Actions')), // For delete
                          ],
                          rows: snapshot.data!.docs.map((doc) {
                            return DataRow(
                              cells: [
                                DataCell(Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(doc['name']),
                                )),
                                DataCell(Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(doc['nic']),
                                )),
                                DataCell(Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(doc['driving_license_number']),
                                )),
                                DataCell(Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(doc['phone']),
                                )),
                                DataCell(
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.red, // Delete button color
                                    ),
                                    onPressed: () async {
                                      // Delete the driver from Firestore
                                      await FirebaseFirestore.instance
                                          .collection('drivers')
                                          .doc(doc.id)
                                          .delete();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
