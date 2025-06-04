import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String? docId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    docId = ModalRoute.of(context)?.settings.arguments as String;
    FirebaseFirestore.instance.collection('events').doc(docId).get().then((
      doc,
    ) {
      final data = doc.data()!;
      _titleController.text = data['title'];
      _locationController.text = data['location'];
      _descriptionController.text = data['description'];
      _selectedDate = (data['date'] as Timestamp).toDate();
      setState(() {});
    });
  }

  void _updateEvent() async {
    await FirebaseFirestore.instance.collection('events').doc(docId).update({
      'title': _titleController.text,
      'location': _locationController.text,
      'description': _descriptionController.text,
      'date': _selectedDate,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
              label: Text(
                _selectedDate == null
                    ? "Pick Date"
                    : "Picked: ${_selectedDate!.toLocal()}".split(' ')[0],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateEvent,
              child: const Text("Update Event"),
            ),
          ],
        ),
      ),
    );
  }
}
