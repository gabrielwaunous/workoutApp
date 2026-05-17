// lib/features/routines/paste_routine_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/parser/routine_parser.dart';
import 'review_lines_screen.dart';

class PasteRoutineScreen extends ConsumerStatefulWidget {
  const PasteRoutineScreen({super.key});

  @override
  ConsumerState<PasteRoutineScreen> createState() => _PasteState();
}

class _PasteState extends ConsumerState<PasteRoutineScreen> {
  final _textController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pegar rutina')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la rutina',
                hintText: 'ej: Fuerza - Piernas',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Pegar texto de WhatsApp',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _parse,
              child: const Text('Parsear →'),
            ),
          ],
        ),
      ),
    );
  }

  void _parse() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final result = RoutineParser().parse(text);
    final name = _nameController.text.trim().isEmpty
        ? 'Rutina sin nombre'
        : _nameController.text.trim();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewLinesScreen(
          routineName: name,
          rawText: text,
          parseResult: result,
        ),
      ),
    );
  }
}
