import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showVoteDialog(BuildContext context, String eventId) async {
  final doc =
      await FirebaseFirestore.instance.collection('events').doc(eventId).get();

  if (!doc.exists) return;

  final data = doc.data()!;
  final poll = Map<String, dynamic>.from(data['poll'] ?? {});

  String? selectedOption;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Vote"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    poll.keys.map((option) {
                      return RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                      );
                    }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedOption != null) {
                    final option = selectedOption!;
                    poll[option] = (poll[option] ?? 0) + 1;

                    await FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventId)
                        .update({'poll': poll});

                    Navigator.pop(context);
                  }
                },
                child: const Text("Vote"),
              ),
            ],
          );
        },
      );
    },
  );
}
