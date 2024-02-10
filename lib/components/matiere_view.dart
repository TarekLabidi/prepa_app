import 'package:flutter/material.dart';
import 'mateire_card.dart';

class MatiereView extends StatelessWidget {
  final Map<String, String> matiere;
  final int index;

  const MatiereView({super.key, required this.matiere, required this.index});

  @override
  Widget build(BuildContext context) {
    final lightColors = [
      const Color.fromARGB(255, 29, 21, 241),
      const Color.fromARGB(255, 86, 151, 12),
      Colors.orange.shade300,
      const Color.fromARGB(255, 216, 53, 8),
      Colors.pinkAccent.shade100,
      const Color.fromARGB(255, 235, 80, 116),
    ];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatiereCard(
              matiere: matiere,
              index: index,
            ),
          ),
        );
      },
      child: Card(
        color: lightColors[index % lightColors.length],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(children: [
              CircleAvatar(
                backgroundImage: AssetImage(matiere['asset']!),
                radius: 30,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                matiere['name']!,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: const Color.fromARGB(255, 239, 232, 232)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
