import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:grpc/grpc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_vault/pages/channels.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:study_vault/pages/comment_modification.dart';
import 'package:study_vault/pages/profile.dart';
import 'package:study_vault/pojos/comment.dart';
import 'package:study_vault/src/generated/studyvault.pbgrpc.dart';
import 'package:study_vault/utils/user_provider.dart';
import 'package:http/http.dart' as http;

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
  int _rating = 0;
  int _selectedIndex = 1;
  String? _folderPath;
  String _channelName = "";
  late List<Comment> comments = [];
  Map<int, String> userNames = {};
  late String filename = "";

  Future<void> fetchGrpcData() async {
    final channel = ClientChannel(
      'localhost',
      port: 8081,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    final stub = PostsServiceClient(channel);

    try {
      final response =
          await stub.getFileNameByFileId(FileId()..fileId = widget.post.fileId);

      setState(() {
        filename = response.filename;
      });
    } catch (e) {
      print('Caught error: $e');
    }

    await channel.shutdown();
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

  Future<void> _selectFolder() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      setState(() {
        _folderPath = result;
      });
    }
  }

  Future<void> _fetchComments() async {
    final int postId = widget.post.postId;
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8084/comment/all/$postId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> commentsJson = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        comments = commentsJson
            .map((json) => Comment.fromJson(json as Map<String, dynamic>))
            .toList();
      });
      for (var comment in comments) {
        String name = await _getUserName(comment.userId);
        userNames[comment.userId] = name;
      }
    } else {
      throw Exception('Error al obtener los correos');
    }
  }

  Future<void> _setChannelName() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? token = userProvider.token;
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    final int channelId = widget.post.channelId;
    final response = await http.get(
        Uri.parse('http://127.0.0.1:8080/channel/name/$channelId'),
        headers: headers);

    if (response.statusCode == 200) {
      String channelNameJson = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        _channelName = channelNameJson;
      });
    } else {
      throw Exception('Error al obtener nombre de canal');
    }
  }

  Future<void> _setPostCreatorName() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? token = userProvider.token;
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    final int channelId = widget.post.channelId;
    final response = await http.get(
        Uri.parse('http://127.0.0.1:8080/creator/channel/$channelId'),
        headers: headers);

    if (response.statusCode == 200) {
      int _creatorId = 0;
      setState(() {
        _creatorId = int.parse(response.body);
      });
      _postCreatorName = await _getUserName(_creatorId);
    } else {
      throw Exception('Error al obtener nombre de canal');
    }
  }

  Future<String> _getUserName(int userId) async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8083/user/name/$userId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      String _name = "";
      String _last_name = "";
      setState(() {
        _name = jsonResponse['name'] as String;
        _last_name = jsonResponse['last_name'] as String;
      });
      return '$_name $_last_name';
    } else {
      throw Exception('Error al obtener nombre de usuario');
    }
  }

  void _comment() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int? userId = userProvider.userId;
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8084/comment'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'post_id': widget.post.postId,
        'user_id': userId,
        'comment': _commentController.text,
        'rating': _rating,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Comentario guardado con éxito")),
      );
      _fetchComments();
      build(context);
    } else {
      final errorResponse = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Error: ${errorResponse['message'] ?? 'Error al comentar'}")),
      );
    }
  }

  void modifyComment(Comment comment) async {
    await showDialog(
      context: context,
      builder: (context) => CommentModification(comment: comment),
    );
    _fetchComments();
  }

  @override
  void initState() {
    super.initState();
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
                  onTap: _selectFolder,
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
