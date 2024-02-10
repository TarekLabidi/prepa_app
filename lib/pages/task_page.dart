import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../components/matiere_view.dart';
import '../dummydata.dart';
import '../palette.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int val = 0;
  late List quotes;
  late String quote;
  late List historydays;
  final _myBox = Hive.box('prepabox');

  @override
  void initState() {
    final _myBox = Hive.box('prepabox');
    quotes = _myBox.get('quotes') ?? motivation;
    historydays = _myBox.get('history') ?? [];

    quote = _myBox.get('quote') ?? "Nekhdem lail ou nhar na9if kan ki noufa";
    super.initState();
  }

  String getquote() {
    String quoteL = quotes[Random().nextInt(quotes.length)];

    return quoteL;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('d MMM, y').format(now).toString();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Quote of The Day  ',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Riot',
                            color: Palette.titleColor,
                          ),
                        ),
                        FaIcon(
                          FontAwesomeIcons.bolt,
                          color: Palette.titleColor,
                          size: 25,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        (historydays.isEmpty)
                            ? quote
                            : (historydays[0]['date'] != formattedDate)
                                ? getquote()
                                : quote,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Riot',
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: height / 55,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (quotes.length > 1) {
                              setState(() {
                                quotes.remove(quote);
                                _myBox.put('quotes', quotes);
                                quote = getquote();
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quote = getquote();
                            });
                          },
                          icon: const Icon(
                            Icons.refresh_outlined,
                            size: 40,
                            color: Color.fromARGB(255, 202, 193, 18),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              String addedQuote = "";
                              TextEditingController quoteController =
                                  TextEditingController();

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        Color.fromARGB(255, 222, 220, 220),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.99,
                                        ),
                                        const Text(
                                          '         Add Quote         ',
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextField(
                                          controller: quoteController,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Card(
                                              color: Colors.blue,
                                              child: TextButton(
                                                onPressed: () {
                                                  addedQuote = quoteController
                                                      .text
                                                      .trim();
                                                  if (addedQuote.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "You didn't type your quote"),
                                                        duration: Duration(
                                                            seconds: 2),
                                                      ),
                                                    );
                                                  } else {
                                                    setState(() {
                                                      quote = addedQuote;
                                                      _myBox.put(
                                                          'quote', addedQuote);
                                                      quotes.add(addedQuote);
                                                      _myBox.put(
                                                          'quotes', quotes);
                                                    });

                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: const Text(
                                                  "Add",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Card(
                                              color: Colors.red,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 40,
                              color: Color.fromARGB(255, 202, 193, 18),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: matieres.length,
                itemBuilder: (context, index) {
                  final matiere = matieres[index];
                  return MatiereView(
                    matiere: matiere,
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
