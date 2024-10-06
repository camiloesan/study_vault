import 'package:flutter/material.dart';

class PostCreation extends StatelessWidget {
  const PostCreation({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 520,
        width: 700,
        child: Column(
          children: [
            const Text('Create new post', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),

            const SizedBox(height: 12.0),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Title')
            ),
            const TextField(
              maxLength: 32,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8.0),

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

            TextButton.icon(
              onPressed: () {
                // Implement file picker or attachment logic here
              },
              icon: const Icon(Icons.attach_file),
              label: const Text('Add Attachment'),
            ),

            const SizedBox(height: 32.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, 
                  child: const Text('Cancel')
                ),

                const SizedBox(width: 12.0),
                ElevatedButton(onPressed: () {}, child: const Text('Create')),
              ],
            ),

          ],
        ),
      ),
    );
  }
}