import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:html' as html;  // For web-specific file download

class ComplaintsReportPage extends StatefulWidget {
  const ComplaintsReportPage({Key? key}) : super(key: key);

  @override
  _ComplaintsReportPageState createState() => _ComplaintsReportPageState();
}

class _ComplaintsReportPageState extends State<ComplaintsReportPage> {
  List<Map<String, dynamic>> complaintsData = [];
  Map<String, int> complaintTypeCounts = {};
  Map<String, int> complaintStatusCounts = {};

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  Future<void> fetchComplaints() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Complaints').get();

      List<Map<String, dynamic>> tempComplaints = [];
      Map<String, int> tempTypeCounts = {};
      Map<String, int> tempStatusCounts = {};

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        tempComplaints.add({
          'Date': data['Date'] ?? 'N/A',
          'Description': data['Description'] ?? 'N/A',
          'Status': data['Status'] ?? 'N/A',
        });

        String status = data['Status'] ?? 'Unknown';
        tempStatusCounts[status] = (tempStatusCounts[status] ?? 0) + 1;

        String type = data['Type'] ?? 'Unknown';
        tempTypeCounts[type] = (tempTypeCounts[type] ?? 0) + 1;
      }

      setState(() {
        complaintsData = tempComplaints;
        complaintTypeCounts = tempTypeCounts;
        complaintStatusCounts = tempStatusCounts;
      });
    } catch (e) {
      print('Error fetching complaints: $e');
    }
  }

  Future<void> _generateAndDownloadPDF() async {
    final pdf = pw.Document();

    // Load Google Fonts
    final robotoRegular = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
    final robotoBold = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf'));

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text(
              'Complaints Report',
              style: pw.TextStyle(
                font: robotoBold,
                fontSize: 24,
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Text(
              'Complaints Table',
              style: pw.TextStyle(
                font: robotoRegular,
                fontSize: 18,
              ),
            ),
            pw.SizedBox(height: 15),
            _buildComplaintsTable(robotoRegular, robotoBold),
            pw.SizedBox(height: 20),
          ],
        ),
      ),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text(
              'Complaints Type Status Table',
              style: pw.TextStyle(
                font: robotoRegular,
                fontSize: 18,
              ),
            ),
            pw.SizedBox(height: 15),
            _buildComplaintsTypeTable(complaintTypeCounts, robotoRegular, robotoBold),
            pw.SizedBox(height: 20),
          ],
        ),
      ),
    );

    // For web, trigger a download in the browser
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'complaints_report.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  pw.Widget _buildComplaintsTable(pw.Font regularFont, pw.Font boldFont) {
    return pw.Table.fromTextArray(
      headers: ['Date', 'Description', 'Status'],
      data: complaintsData.map((complaint) {
        return [
          complaint['Date'],
          complaint['Description'],
          complaint['Status']
        ];
      }).toList(),
      headerStyle: pw.TextStyle(
        font: boldFont,
        color: PdfColor.fromHex('#484848'),
        fontWeight: pw.FontWeight.bold,
      ),
      headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#CDF5CE')),
      cellPadding: const pw.EdgeInsets.all(8),
      cellStyle: pw.TextStyle(
        font: regularFont,
        color: PdfColor.fromHex('#484848'),
        fontWeight: pw.FontWeight.normal,
      ),
      cellHeight: 40,
    );
  }

  pw.Widget _buildComplaintsTypeTable(Map<String, int> complaintTypeCounts, pw.Font regularFont, pw.Font boldFont) {
    return pw.Table.fromTextArray(
      headers: ['Type', 'Count'],
      data: complaintTypeCounts.entries.map((entry) {
        return [entry.key, entry.value.toString()];
      }).toList(),
      headerStyle: pw.TextStyle(
        font: boldFont,
        color: PdfColor.fromHex('#484848'),
        fontWeight: pw.FontWeight.bold,
      ),
      headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#CDF5CE')),
      cellPadding: const pw.EdgeInsets.all(8),
      cellStyle: pw.TextStyle(
        font: regularFont,
        color: PdfColor.fromHex('#484848'),
        fontWeight: pw.FontWeight.normal,
      ),
      cellHeight: 40,
    );
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
            Icon(Icons.person_rounded, color: Colors.white)
          ],
        ),
      ),
      body: complaintsData.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Complaints Status Report',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed:
                            _generateAndDownloadPDF,
                        icon: const Icon(Icons.download),
                        label: const Text("Download Report"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFCDF5CE),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 130.0),
                    child: Text(
                      'Complaints Over Time',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  complaintsOverTimeChart(),
                  const SizedBox(height: 80),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 130.0), // Padding to the left
                    child: Text(
                      'Complaints resolved or pending status',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  complaintsTable(), // Display table 1 -> Date, Description, Status
                  const SizedBox(height: 40),
                  complaintStatusBarChart(), // Bar chart for complaint status
                  const SizedBox(height: 80),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 130.0),
                    child: Text(
                      'Complaints status by Type',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  complaintsTypeTable(), // Display table 2 -> Type and Count
                  const SizedBox(height: 30),
                  complaintTypePieChart(), // Pie chart for complaint types
                  const SizedBox(height: 40),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator()), // Show loader or message
    );
  }

  // Complaints table (Date, Description, Status)
  Widget complaintsTable() {
    if (complaintsData.isEmpty) {
      return const Text('No complaints found.');
    }

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Status')),
          ],
          rows: complaintsData.map((complaint) {
            return DataRow(cells: [
              DataCell(Text(complaint['Date'])),
              DataCell(Text(complaint['Description'])),
              DataCell(Text(complaint['Status'])),
            ]);
          }).toList(),
          headingRowColor: MaterialStateProperty.all(const Color(0xFFCDF5CE)),
        ),
      ),
    );
  }

  // Bar chart for complaints by status
  Widget complaintStatusBarChart() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: SfCartesianChart(
          title: const ChartTitle(
            text: 'Complaints by Status',
            textStyle: TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(),
          series: <CartesianSeries>[
            ColumnSeries<MapEntry<String, int>, String>(
              dataSource: complaintStatusCounts.entries.toList(),
              xValueMapper: (MapEntry<String, int> entry, _) => entry.key,
              yValueMapper: (MapEntry<String, int> entry, _) => entry.value,
              name: 'Count',
              pointColorMapper: (MapEntry<String, int> entry, _) {
                // Change the color based on the status
                if (entry.key.toLowerCase() == 'pending') {
                  return Colors.yellow[200]!; // Light yellow for pending
                } else if (entry.key.toLowerCase() == 'resolved') {
                  return Colors.green[200]!; // Light green for resolved
                } else {
                  return Colors.grey; // Default color for other statuses
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Complaints type table (Type, Count)
  Widget complaintsTypeTable() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Count')),
          ],
          rows: complaintTypeCounts.entries.map((entry) {
            return DataRow(cells: [
              DataCell(Text(entry.key)),
              DataCell(Text(entry.value.toString())),
            ]);
          }).toList(),
          headingRowColor: MaterialStateProperty.all(const Color(0xFFCDF5CE)),
        ),
      ),
    );
  }

  // Pie chart for complaints by type
  Widget complaintTypePieChart() {
    // Calculate total complaints to get percentages
    final totalComplaints = complaintTypeCounts.values.fold(0, (a, b) => a + b);
    final complaintTypeCountsWithPercentages =
        complaintTypeCounts.map((key, value) {
      return MapEntry(
          key, (value / totalComplaints) * 100); // Calculate percentage
    });

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 1.0, // Increased width chart
        height: MediaQuery.of(context).size.height * 0.6, // Optionally increase height
        child: SfCircularChart(
          title: const ChartTitle(
            text: 'Complaints by Type',
            textStyle: TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
          series: <CircularSeries>[
            PieSeries<MapEntry<String, double>, String>(
              dataSource: complaintTypeCountsWithPercentages.entries.toList(),
              xValueMapper: (MapEntry<String, double> entry, _) => entry.key,
              yValueMapper: (MapEntry<String, double> entry, _) => entry.value,
              pointColorMapper: (MapEntry<String, double> entry, _) {
                switch (entry.key) {
                  case 'Missed collection': return Colors.red[200];
                  case 'Late collection': return Colors.orange[200];
                  case 'Improper waste handling': return Colors.yellow[200];
                  case 'Damaged property': return Colors.blue[200];
                  case 'Rude behavior': return Colors.green[200];
                  case 'Other': return Colors.grey; 
                  default: return Colors.black;
                }
              },
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelIntersectAction: LabelIntersectAction.shift,
                connectorLineSettings:
                    ConnectorLineSettings(type: ConnectorType.curve),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Line Chart for complaints by date
  Widget complaintsOverTimeChart() {
    Map<DateTime, int> complaintsByDate = {};

    for (var complaint in complaintsData) {
      DateTime date;

      // Check if the date is a Timestamp or a String and convert accordingly
      if (complaint['Date'] is Timestamp) {
        date = (complaint['Date'] as Timestamp).toDate();
      } else if (complaint['Date'] is String) {
        date = DateTime.parse(complaint['Date']); // Convert String to DateTime
      } else {
        continue; // Skip if the date is neither
      }

      // Normalize the date to ignore time
      date = DateTime(date.year, date.month, date.day);
      complaintsByDate[date] =
          (complaintsByDate[date] ?? 0) + 1; // Count complaints by date
    }

    // Prepare data for the chart
    final List<MapEntry<DateTime, int>> chartData = complaintsByDate.entries
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key)); // Sort by date

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat('MM-dd'), // Format the date on the x-axis
          ),
          primaryYAxis: const NumericAxis(),
          series: <CartesianSeries>[
            LineSeries<MapEntry<DateTime, int>, DateTime>(
              dataSource: chartData,
              xValueMapper: (MapEntry<DateTime, int> entry, _) => entry.key,
              yValueMapper: (MapEntry<DateTime, int> entry, _) => entry.value,
              name: 'Complaints',
              markerSettings: const MarkerSettings(isVisible: true),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}
