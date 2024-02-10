import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'task_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MatiereCard extends StatefulWidget {
  final Map<String, String> matiere;
  final int index;

  const MatiereCard({
    super.key,
    required this.matiere,
    required this.index,
  });

  @override
  State<MatiereCard> createState() => _MatiereCardState();
}

class _MatiereCardState extends State<MatiereCard> {
  final lightColors = [
    const Color.fromARGB(255, 29, 21, 241),
    const Color.fromARGB(255, 86, 151, 12),
    Colors.orange.shade300,
    const Color.fromARGB(255, 216, 53, 8),
    const Color.fromARGB(255, 165, 2, 152),
    const Color.fromARGB(255, 132, 3, 33),
  ];
  final lightColors2 = [
    const Color.fromARGB(255, 120, 171, 241),
    const Color.fromARGB(255, 139, 247, 143),
    const Color.fromARGB(255, 245, 221, 102),
    const Color.fromARGB(255, 242, 212, 114),
    const Color.fromARGB(255, 244, 146, 179),
    const Color.fromARGB(255, 243, 135, 160),
  ];
  final lightColors3 = [
    const Color.fromARGB(255, 185, 209, 242),
    const Color.fromARGB(255, 209, 246, 210),
    const Color.fromARGB(255, 248, 239, 197),
    const Color.fromARGB(255, 241, 226, 179),
    const Color.fromARGB(255, 242, 205, 217),
    const Color.fromARGB(255, 246, 197, 208),
  ];

  late List taskslist;
  TextEditingController taskController = TextEditingController();
  late int points;
  late List days;
  late int totalpoints;
  late List historydays;

  @override
  void initState() {
    final _myBox = Hive.box('prepabox');
    taskslist = _myBox.get('tasks ${widget.matiere['name']}') ?? [];
    points = _myBox.get('points ${widget.matiere['name']}') ?? 0;
    days = _myBox.get('days ${widget.matiere['name']}') ?? [];
    historydays = _myBox.get('history') ?? [];
    totalpoints = _myBox.get('totalpoints') ?? 0;
    super.initState();
  }

  void setpoints(List days, int points) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM, y').format(now).toString();
    if (days.isNotEmpty) {
      if (days[0]['date'] == formattedDate) {
        setState(() {
          days[0]['points'] = points;
          _myBox.put('days ${widget.matiere['name']}', days);
        });
      } else {
        final Map day = {'date': formattedDate, 'points': points};
        days.insert(0, day);
        _myBox.put('days ${widget.matiere['name']}', days);
      }
    } else {
      final Map day = {'date': formattedDate, 'points': points};
      days.add(day);
      _myBox.put('days ${widget.matiere['name']}', days);
    }
  }

  List<PointsData>? data(List? dayss) {
    List<PointsData> pointslist = [];
    if (dayss != null) {
      for (int i = 0; i < dayss.length; i++) {
        pointslist.insert(
          0,
          PointsData(
            dayss[i]['date'],
            dayss[i]['points'],
          ),
        );
      }
    }

    return pointslist;
  }

  double calclulate(List taskslist) {
    int completed = 0;
    double perc = 0;
    for (int i = 0; i < taskslist.length; i++) {
      if (taskslist[i]['isCompleted'] == 'true') {
        completed = completed + 1;
      }
      if (completed == taskslist.length) {
        perc = 1;
      } else if (completed == 0) {
      } else {
        perc = completed / taskslist.length;
      }
    }
    return perc;
  }

  void loaddate(int totalpoints) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM, y').format(now).toString();
    if (historydays.isNotEmpty) {
      if (historydays[0] != formattedDate) {
        final Map day = {'date': formattedDate, 'points': totalpoints};
        historydays.insert(0, day);
        _myBox.put('history', historydays);
      } else {
        historydays[0]['points'] = totalpoints;
      }
    } else {
      final Map day = {'date': formattedDate, 'points': totalpoints};
      historydays.insert(0, day);
      _myBox.put('history', historydays);
    }
  }

  final _myBox = Hive.box('prepabox');
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  color: lightColors2[widget.index % lightColors2.length],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height / 48,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 40,
                              ),
                            ),
                            const Spacer(),
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage(widget.matiere['asset']!),
                              radius: 45,
                            ),
                            SizedBox(
                              width: width / 55,
                            ),
                            Text(
                              widget.matiere['name']!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                      color: lightColors[
                                          widget.index % lightColors.length]),
                            ),
                            const Spacer(
                              flex: 2,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height / 90),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tasks Of The Week',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(width: width / 12),
                    CircularPercentIndicator(
                      radius: 40.0,
                      lineWidth: 7.0,
                      percent:
                          (taskslist.isNotEmpty) ? calclulate(taskslist) : 0,
                      animation: true,
                      animationDuration: 1200,
                      center: Text((taskslist.isNotEmpty)
                          ? '${(calclulate(taskslist) * 100).toStringAsFixed(0)}%'
                          : '0.0%'),
                      progressColor:
                          lightColors[widget.index % lightColors.length],
                    ),
                  ],
                ),
                (taskslist.isNotEmpty)
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: taskslist.length,
                        itemBuilder: (context, index) {
                          dynamic task = taskslist[index];
                          return TaskCard(
                            task: task,
                            tasksremoved: (value) => setState(() {
                              taskslist.remove(value);
                              _myBox.put(
                                  'tasks ${widget.matiere['name']}', taskslist);
                            }),
                            color: lightColors2[
                                widget.index % lightColors2.length],
                            color2: lightColors3[
                                widget.index % lightColors2.length],
                            matiere: widget.matiere,
                            tasksdone: (value) => setState(() {
                              task = value;
                              taskslist = taskslist;
                            }),
                            tasksadd: (value) => setState(() {
                              taskslist.add(value);
                              _myBox.put(
                                  'tasks ${widget.matiere['name']}', taskslist);
                            }),
                            pointsplus: (value) => setState(() {
                              totalpoints = totalpoints + value;
                              _myBox.put('totalpoints', totalpoints);
                              points = points + value;
                              setpoints(days, points);
                              loaddate(totalpoints);
                              _myBox.put(
                                  'points ${widget.matiere['name']}', points);
                            }),
                            pointsminus: (value) => setState(() {
                              points = points - value;
                              totalpoints = totalpoints - value;
                              _myBox.put('totalpoints', totalpoints);
                              setpoints(days, points);
                              loaddate(totalpoints);
                              _myBox.put(
                                  'points ${widget.matiere['name']}', points);
                            }),
                          );
                        },
                      )
                    : const SizedBox.shrink(),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.green[100],
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                  '          Enter Your Task               '),
                              const SizedBox(height: 5),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: taskController,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    child: Container(
                                      color: Colors.blue,
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            String taskText =
                                                taskController.text.trim();
                                            if (taskText.isNotEmpty) {
                                              final Map<String, String> task1 =
                                                  {
                                                "id": '${taskslist.length}',
                                                "task": taskText,
                                                "isCompleted": "false",
                                                "isMissed": "false"
                                              };
                                              taskslist.add(task1);
                                              _myBox.put(
                                                  'tasks ${widget.matiere['name']}',
                                                  taskslist);
                                              Navigator.pop(context);
                                              taskController.clear();
                                            } else {
                                              Navigator.pop(context);
                                              taskController.clear();
                                            }
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 6),
                                          child: Text('Done'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    child: Container(
                                      color: Colors.red,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          taskController.clear();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 3),
                                          child: Text('Cancel'),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: Color.fromARGB(255, 250, 4, 4),
                    size: 60,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 12,
            ),
            Card(
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Statistics',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Card(
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: SfCartesianChart(
                    primaryXAxis: const CategoryAxis(),
                    // Chart title
                    title: const ChartTitle(text: 'This subject\'s statics'),
                    // Enable legend
                    legend: const Legend(isVisible: true),
                    // Enable tooltip
                    tooltipBehavior: TooltipBehavior(enable: false),
                    series: <LineSeries<PointsData, String>>[
                      LineSeries<PointsData, String>(
                        dataSource: data(days),
                        xValueMapper: (PointsData sales, _) => sales.day,
                        yValueMapper: (PointsData sales, _) => sales.points,
                        name: 'Points',
                        // Enable data label
                      )
                    ],
                    // Customize the y-axis
                    primaryYAxis: NumericAxis(
                      numberFormat: NumberFormat(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}

class PointsData {
  PointsData(this.day, this.points);

  final String day;
  final int points;
}
