import 'package:flutter/material.dart';

class ChannelCreation extends StatelessWidget {
  const ChannelCreation({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 520,
        width: 700,
        child: Column(
          children: [
            const Text(
              'New Channel',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12.0),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Name'),
            ),

            const TextField(
              maxLength: 32,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8.0),

            // Etiqueta Description
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Description'),
            ),

            const Expanded(
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                expands: true,
                maxLength: 256,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 8.0),      

            const SizedBox(height: 32.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),

                const SizedBox(width: 12.0),

                ElevatedButton(
                  onPressed: () {
                    // Lógica para crear el canal
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
