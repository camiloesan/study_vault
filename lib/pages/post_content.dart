import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:grpc/grpc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_vault/pages/channels.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:study_vault/pages/comment_modification.dart';
import 'package:study_vault/pages/profile.dart';
import 'package:study_vault/models/comment.dart';
import 'package:study_vault/src/generated/studyvault.pbgrpc.dart';
import 'package:study_vault/utils/user_provider.dart';
import 'package:study_vault/utils/alert_service.dart';
import 'package:study_vault/services/comments_services.dart';
import 'package:study_vault/services/channels_services.dart';
import 'package:study_vault/services/users_services.dart';
import 'package:study_vault/services/posts_services.dart';

class PostContent extends StatefulWidget {
  final PostsResponse_PostInfo post;

  const PostContent({super.key, required this.post});

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  String _postCreatorName = "";
  String _UserName = "";
  int _rating = 0;
  int _selectedIndex = 1;
  String? _folderPath;
  String _channelName = "";
  late List<Comment> comments = [];
  Map<int, String> userNames = {};
  late String filename = "";
  String? token;

  Future<void> fetchGrpcData() async {
    try {
      final filename =
          await PostsServices.fetchFileNameByFileId(widget.post.fileId);
      setState(() {
        this.filename = filename;
      });
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Channels()),
        );
        break;
      case 1:
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Profile()),
        );
    }
  }

  Future<void> _fetchComments() async {
    final int postId = widget.post.postId;

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await CommentsServices.fetchComments(headers, postId);

      if (response.statusCode == 200) {
        List<dynamic> commentsJson =
            json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          comments = commentsJson
              .map((json) => Comment.fromJson(json as Map<String, dynamic>))
              .toList();
        });
        for (var comment in comments) {
          await _setUserName(comment.userId);
          userNames[comment.userId] = _UserName;
        }
      } else if (response.statusCode == 401) {
        AlertService().showSessionExpirationAlert(context);
      } else {
        AlertService().showDatabaseErrorAlert(context);
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  Future<void> _setChannelName() async {
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final int channelId = widget.post.channelId;
    try {
      final response =
          await ChannelsServices.fetchChannelName(headers, channelId);

      if (response.statusCode == 200) {
        String channelNameJson = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _channelName = channelNameJson;
        });
      } else if (response.statusCode == 401) {
        AlertService().showSessionExpirationAlert(context);
      } else {
        AlertService().showDatabaseErrorAlert(context);
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  Future<void> _setPostCreatorName() async {
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    final int channelId = widget.post.channelId;

    try {
      final response =
          await ChannelsServices.fetchChannelCreator(headers, channelId);

      if (response.statusCode == 200) {
        int creatorId = int.parse(response.body);
        await _setUserName(creatorId);
        setState(() {
          _postCreatorName = _UserName;
        });
      } else if (response.statusCode == 401) {
        AlertService().showSessionExpirationAlert(context);
      } else {
        AlertService().showDatabaseErrorAlert(context);
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  Future<void> _setUserName(int userId) async {
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };

    try {
      final response = await UsersServices.getUserName(headers, userId);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        String name = jsonResponse['name'] as String;
        String lastName = jsonResponse['last_name'] as String;

        setState(() {
          _UserName = '$name $lastName';
        });
      } else if (response.statusCode == 401) {
        AlertService().showSessionExpirationAlert(context);
      } else {
        AlertService().showDatabaseErrorAlert(context);
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  void _comment() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int userId = userProvider.userId!;

    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };

    final body = {
      'post_id': widget.post.postId,
      'user_id': userId,
      'comment': _commentController.text,
      'rating': _rating,
    };

    try {
      final response = await CommentsServices.createComment(headers, body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Comentario guardado con éxito")),
        );
        await _fetchComments();
        setState(() {});
      } else if (response.statusCode == 401) {
        AlertService().showSessionExpirationAlert(context);
      } else {
        AlertService().showDatabaseErrorAlert(context);
      }
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  void modifyComment(Comment comment) async {
    await showDialog(
      context: context,
      builder: (context) => CommentModification(comment: comment),
    );
    _fetchComments();
  }

  Future<void> _downloadFile() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Por favor selecciona una carpeta primero")),
      );
      return;
    }

    try {
      await PostsServices.downloadFile(
        channelId: widget.post.channelId,
        fileId: widget.post.fileId,
        folderPath: result,
        filename: filename,
        context: context,
      );
    } catch (e) {
      AlertService().showDatabaseErrorAlert(context);
    }
  }

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    token = userProvider.token;
    _fetchComments();
    _setChannelName();
    _setPostCreatorName();
    fetchGrpcData();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int? _userId = userProvider.userId;
    return Scaffold(
      appBar: AppBar(title: Text(_channelName)),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Post",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(widget.post.publishDate,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal)),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_postCreatorName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(widget.post.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(widget.post.description,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal)),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                const Text("File",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                const SizedBox(height: 4),
                ListTile(
                  title: Text(filename),
                  leading: const Icon(Icons.attach_file),
                  onTap: _downloadFile,
                ),
                const Text("Rating",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                const SizedBox(height: 4),
                const Text("Comments",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _commentController,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Write a comment',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu comentario';
                      } else if (value.length > 256) {
                        return 'Ingresa un comentario de menos de 256 caracteres';
                      } else if (_rating == 0) {
                        return 'Debes calificar el contenido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _comment();
                    }
                  },
                  child: const Text("Send"),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    int userId = comments[index].userId;
                    String userName = userNames[userId] ?? 'Cargando...';
                    return ListTile(
                      title: Text(userName),
                      contentPadding: const EdgeInsets.all(8.0),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${comments[index].comment}\nPublished on: ${comments[index].publishDate}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          RatingBarIndicator(
                            rating: comments[index].rating.toDouble(),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                          if (comments[index].userId == _userId)
                            IconButton(
                              icon: Image.asset(
                                'assets/images/edit_icon.png',
                                width: 24,
                                height: 24,
                              ),
                              onPressed: () {
                                modifyComment(comments[index]);
                              },
                            ),
                        ],
                      ),
                      onTap: () {},
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark_outlined),
            label: 'Channels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
