import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:study_vault/pojos/comment.dart';
import 'package:study_vault/utils/user_provider.dart';
import 'package:study_vault/utils/alert_service.dart';

class CommentModification extends StatefulWidget {
  final Comment comment;
  const CommentModification({Key? key, required this.comment})
      : super(key: key);

  @override
  State<CommentModification> createState() => _CommentModificationState();
}

class _CommentModificationState extends State<CommentModification> {
  String _errorMessage = '';
  late TextEditingController commentController;
  int _rating = 0;
  String? token;

  Future<void> updateComment() async {
    final url = Uri.parse(
        'http://127.0.0.1:8084/comment/update/${widget.comment.commentId}');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    final body = jsonEncode({
      'comment_id': widget.comment.commentId,
      'comment': commentController.text,
      'rating': _rating
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment updated successfully!')),
        );
      } else if (response.statusCode == 401) {
        AlertService().showSessionExpirationAlert(context);
      } else {
        setState(() {
          _errorMessage = 'Failed to update comment';
        });
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  Future<void> deleteComment() async {
    final url = Uri.parse(
        'http://127.0.0.1:8084/comment/delete/${widget.comment.commentId}');

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment deleted successfully!')),
        );
      } else if (response.statusCode == 401) {
        AlertService().showSessionExpirationAlert(context);
      } else {
        setState(() {
          _errorMessage = 'Failed to delete comment';
        });
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  Future<void> deleteConfirmation() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Comment'),
          content: const Text(
              'Are you sure you want to delete this comment? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await deleteComment();
    }
  }

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    token = userProvider.token;
    commentController = TextEditingController(text: widget.comment.comment);
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 500,
        width: 700,
        child: Column(
          children: [
            const Text(
              'Modify Comment',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12.0),
            const Text("Rating",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, index) => const Icon(
                Icons.star_border,
                color: Colors.black,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating.toInt();
                });
              },
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Comment'),
            ),
            Expanded(
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                expands: true,
                maxLength: 256,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: commentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 8.0),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
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
                ElevatedButton.icon(
                  onPressed: deleteConfirmation,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[200],
                  ),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () {
                    if (commentController.text.isNotEmpty && _rating > 0) {
                      updateComment();
                    } else {
                      setState(() {
                        _errorMessage =
                            'Please fill all fields (include rating)';
                      });
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
