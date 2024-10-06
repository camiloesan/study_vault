import 'package:flutter/material.dart';
import 'package:study_vault/pages/post_creation.dart';
import 'package:study_vault/pojos/channel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:study_vault/pojos/post.dart';
import 'package:study_vault/utils/constants.dart';


class ChannelContent extends StatefulWidget {
  const ChannelContent({super.key, required this.channel});

  final Channel channel;

  @override
  State<ChannelContent> createState() => _ChannelContentState();
}

class _ChannelContentState extends State<ChannelContent> {
  final int userType = 1; // 2 student, 1 professor
  final int tempUserId = 1;
  late List<Post> channelPosts = [];

  Future<void> fetchData() async {
    final channelPostsResponse =
        await http.get(Uri.parse("http://127.0.0.1:8080/posts/channel/${widget.channel.channelId}"));

    if (channelPostsResponse.statusCode == 200) {
      List<dynamic> jsonChannelPosts =
          json.decode(utf8.decode(channelPostsResponse.bodyBytes));

      setState(() {
        channelPosts =
            jsonChannelPosts.map((post) => Post.fromJson(post)).toList();
      });
    } else {
      throw Exception('Failed to load data'); // Send an alert instead
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void createNewPost() {
    showDialog(context: context, builder: (context) {
      return const PostCreation();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isStudent = userType == Constants.studentType;

    return Scaffold(
      
      appBar: AppBar(
        title: Text(widget.channel.name),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14.0),
          child: Column(
            children: [
              Text(
                "Created by: ${widget.channel.creatorName} ${widget.channel.creatorLastName}",
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.channel.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 14),
              
              const Text('Posts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),

              const SizedBox(height: 7),

              Expanded(
                child: ListView.separated(
                  itemCount: channelPosts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(channelPosts[index].title),
                      contentPadding: const EdgeInsets.all(8.0),
                      subtitle: Text("${channelPosts[index].description}\nPublished on: ${channelPosts[index].publishDate}"),
                      onTap: () {},
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.grey, // Customize the color
                      thickness: 1, // Customize the thickness
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: isStudent
        ? 
        null
        : 
        FloatingActionButton(
          onPressed: () => createNewPost(),
          child: const Icon(Icons.add),
        ),
      
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.collections_bookmark_outlined),
          label: 'Channels',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          label: 'Profile',
        ),
      ]),
    );
  }
}
