import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

class TaskCard extends StatefulWidget {
  final Map task;
  final ValueChanged<dynamic> tasksremoved;
  final ValueChanged<dynamic> tasksadd;
  final ValueChanged<dynamic> tasksdone;
  final ValueChanged<int> pointsplus;
  final ValueChanged<int> pointsminus;
  final Color color;
  final Color color2;
  final Map<String, String> matiere;
  const TaskCard(
      {super.key,
      required this.task,
      required this.tasksremoved,
      required this.color,
      required this.color2,
      required this.matiere,
      required this.tasksdone,
      required this.tasksadd,
      required this.pointsplus,
      required this.pointsminus});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late int done;
  late int missed;
  final _myBox = Hive.box("prepabox");
  @override
  void initState() {
    final _myBox = Hive.box('prepabox');
    done = _myBox.get('done') ?? 0;
    missed = _myBox.get("missed") ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 183, 244, 186),
                title: Column(
                  children: [
                    const Center(
                      child: Text(
                        'Do you want to delete this task?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            widget.tasksremoved(widget.task);
                            Navigator.pop(context);
                          },
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              color: Colors.red,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 11),
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              color: Colors.blue,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 12),
                                child: Text(
                                  'No',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(15).copyWith(bottom: 8),
        color: (widget.task['isCompleted'] == 'true')
            ? widget.color2
            : (widget.task['isMissed'] == 'true')
                ? (Colors.red)
                : widget.color,
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (widget.task['isCompleted'] == 'false') {
                            widget.tasksremoved(widget.task);
                            widget.task['isCompleted'] = 'true';
                            widget.tasksdone(widget.task);
                            widget.tasksadd(widget.task);
                            done++;
                            _myBox.put('done', done);
                            if (widget.task['isMissed'] == 'true') {
                              widget.pointsplus(2);
                              missed--;
                              _myBox.put('missed', missed);
                            } else {
                              widget.pointsplus(1);
                            }
                            widget.task['isMissed'] = 'false';
                          } else {
                            widget.task['isCompleted'] = 'false';
                            done--;
                            _myBox.put('done', done);
                            widget.pointsminus(1);
                            widget.tasksdone(widget.task);
                          }

                          (widget.task['isCompleted'] == 'true')
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(milliseconds: 800),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Blayd Blayd",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.green),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.dumbbell,
                                          size: 30,
                                          color: Colors.green,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : null;
                        });
                      },
                      icon: Icon(
                        (widget.task['isCompleted'] == 'true')
                            ? FontAwesomeIcons.squareCheck
                            : Icons.crop_square_outlined,
                        size: 40,
                        color: (widget.task['isCompleted'] == 'true')
                            ? const Color.fromARGB(255, 176, 180, 176)
                            : (widget.task['isMissed'] == 'true')
                                ? const Color.fromARGB(255, 153, 79, 79)
                                : Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (widget.task['isMissed'] == 'false') {
                            widget.tasksremoved(widget.task);
                            widget.task['isMissed'] = 'true';
                            missed++;
                            _myBox.put('missed', missed);
                            widget.tasksadd(widget.task);
                            if (widget.task['isCompleted'] == 'true') {
                              widget.pointsminus(2);
                              done--;
                              _myBox.put('done', done);
                            } else {
                              widget.pointsminus(1);
                            }
                            widget.task['isCompleted'] = 'false';
                          } else {
                            widget.task['isMissed'] = 'false';
                            widget.pointsplus(1);
                            missed++;
                            _myBox.put('missed', missed);
                          }
                        });
                        (widget.task['isMissed'] == 'true')
                            ? ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 800),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Mnyka Mnk",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.red),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.thumbsDown,
                                        size: 30,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : null;
                      },
                      icon: Icon(
                        FontAwesomeIcons.squareXmark,
                        size: 30,
                        color: (widget.task['isCompleted'] == 'true')
                            ? const Color.fromARGB(255, 176, 180, 176)
                            : (widget.task['isMissed'] == 'true')
                                ? (const Color.fromARGB(255, 189, 17, 4))
                                : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(widget.task['task']!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: (widget.task['isCompleted'] == 'true' ||
                                    widget.task['isMissed'] == 'true')
                                ? const Color.fromARGB(255, 113, 98, 98)
                                : Colors.black,
                            fontSize: 20),
                        softWrap: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
