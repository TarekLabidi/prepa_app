import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List historydays;
  late int totalpoints;
  late int done;
  late int missed;

  List<PointsData> data(List history) {
    List<PointsData> pointslist = [];

    for (int i = 0; i < history.length; i++) {
      pointslist.insert(
        0,
        PointsData(
          history[i]['date'],
          history[i]['points'],
        ),
      );
    }
    return pointslist;
  }

  @override
  void initState() {
    final _myBox = Hive.box('prepabox');
    totalpoints = _myBox.get('totalpoints') ?? 0;
    historydays = _myBox.get("history") ?? [];
    done = _myBox.get('done') ?? 0;
    missed = _myBox.get('missed') ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Your Overall Statistics',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 250,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<PointsData, String>>[
                  LineSeries<PointsData, String>(
                    dataSource: data(historydays),
                    xValueMapper: (PointsData sales, _) => sales.day,
                    yValueMapper: (PointsData sales, _) => sales.points,
                    name: 'Points',
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tasks Summary',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTaskCounter('Tasks Done', done,
                              const Color.fromARGB(255, 48, 116, 50)),
                          _buildTaskCounter('Tasks Missed', missed, Colors.red),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCounter(String label, int count, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            color: color,
          ),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class PointsData {
  PointsData(this.day, this.points);

  final String day;
  final int points;
}
