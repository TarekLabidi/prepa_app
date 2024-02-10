import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'pages/history_page.dart';
import 'pages/task_page.dart';
import 'palette.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String name;

  @override
  void initState() {
    final _myBox = Hive.box('prepabox');
    name = _myBox.get('name') ?? 'Prepa';
    super.initState();
  }

  int currentPage = 0;
  List<Widget> pages = [const TaskPage(), const HistoryPage()];
  var pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        backgroundColor: Palette.mainColor,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  String newName = name;
                  return AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 228, 217, 217),
                    title: const Text('      Customize the title     '),
                    content: TextField(
                      onChanged: (value) {
                        newName = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter a new title',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (newName.trim().isNotEmpty) {
                            setState(() {
                              name = newName;
                            });
                            final _myBox = Hive.box('prepabox');
                            _myBox.put('name', newName);
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Title cannot be empty!'),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.edit,
              size: 35,
              color: Colors.amber,
            ),
          ),
        ],
      ),
      body: PageView(
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
        controller: pageController,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Palette.translColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.border_color_rounded,
              size: 30,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.border_color_rounded,
              size: 30,
              color: Colors.black,
            ),
            label: 'Study',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.work_history_outlined,
              size: 30,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.work_history_outlined,
              size: 30,
              color: Colors.black,
            ),
            label: 'History',
          ),
        ],
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
            pageController.animateToPage(currentPage,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
          });
        },
      ),
    );
  }
}
