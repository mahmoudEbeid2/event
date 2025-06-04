import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VoteDetailsScreen extends StatelessWidget {
  final String eventId;

  const VoteDetailsScreen({super.key, required this.eventId});

  Future<Map<String, dynamic>?> getEventDetails() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Event Details")),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getEventDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Event not found"));
          }

          final data = snapshot.data!;
          final title = data['title'] ?? '';
          final description = data['description'] ?? '';
          final location = data['location'] ?? '';
          final date = (data['date'] as Timestamp?)?.toDate().toString() ?? '';
          final poll = Map<String, dynamic>.from(data['poll'] ?? {});

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  "Title: $title",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text("Description: $description"),
                const SizedBox(height: 10),
                Text("Location: $location"),
                const SizedBox(height: 10),
                Text("Date: $date"),
                const SizedBox(height: 20),
                const Text("Poll Results:", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                ...poll.entries.map(
                  (entry) => Text("${entry.key}: ${entry.value} vote(s)"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
