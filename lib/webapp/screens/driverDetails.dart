import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_web/webapp/complaints_web/pending_complaints.dart';
import 'package:eco_web/webapp/complaints_web/report_complaints.dart';
import 'package:eco_web/webapp/complaints_web/resolved_complaints.dart';
import 'package:eco_web/webapp/screens/dRegistration.dart';
import 'package:eco_web/webapp/screens/driverDetails.dart';
import 'package:eco_web/webapp/screens/home_screen.dart';
import 'package:eco_web/webapp/screens/userDetails.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DriverDetailsPage extends StatefulWidget {
  @override
  _DriverDetailsPageState createState() => _DriverDetailsPageState();
}

class _DriverDetailsPageState extends State<DriverDetailsPage> {
  String searchQuery = '';

  Stream<QuerySnapshot> getDriversStream() {
    return FirebaseFirestore.instance.collection('drivers').snapshots();
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final snapshot =
        await FirebaseFirestore.instance.collection('drivers').get();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text('Driver Details', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Name', 'NIC', 'License No', 'Phone'],
              data: snapshot.docs.map((doc) {
                return [
                  doc['name'],
                  doc['nic'],
                  doc['driving_license_number'],
                  doc['phone'],
                ];
              }).toList(),
            ),
          ],
        );
      },
    ));

    // Save PDF to a file or share it
    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'drivers_details.pdf');
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
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: generatePdf,
                    child: const Text('Download Driver Details PDF'),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot>(
                    stream: getDriversStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      final filteredDocs = snapshot.data!.docs.where((doc) {
                        return doc['name']
                                .toLowerCase()
                                .contains(searchQuery) ||
                            doc['nic'].toLowerCase().contains(searchQuery);
                      }).toList();
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
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: filteredDocs.map((doc) {
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
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () async {
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
