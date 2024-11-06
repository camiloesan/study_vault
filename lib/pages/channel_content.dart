import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:study_vault/pages/post_content.dart';
import 'package:study_vault/pages/post_creation.dart';
import 'package:study_vault/pojos/channel.dart';
import 'package:study_vault/src/generated/studyvault.pbgrpc.dart';
import 'package:study_vault/utils/constants.dart';

import 'package:provider/provider.dart';
import 'package:study_vault/utils/user_provider.dart';

class ChannelContent extends StatefulWidget {
  const ChannelContent({super.key, required this.channel, required this.isChannelCreator});

  final Channel channel;
  final bool isChannelCreator;

  @override
  State<ChannelContent> createState() => _ChannelContentState();
}

class _ChannelContentState extends State<ChannelContent> {
  late List<PostsResponse_PostInfo> channelPosts = [];

  Future<void> fetchGrpcData() async {
    final channel = ClientChannel(
      'localhost',
      port: 8081,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    final stub = PostsServiceClient(channel);

    try {
      final response = await stub.getPostsByChannelId(
          ChannelRequest()..channelId = widget.channel.channelId);

      setState(() {
        channelPosts = response.posts;
      });
    } catch (e) {
      print('Caught error: $e');
    }

    await channel.shutdown();
  }

  @override
  void initState() {
    super.initState();
    fetchGrpcData();
  }

  void createNewPost() async {
    await showDialog(
        context: context,
        builder: (context) {
          return PostCreation(channel: widget.channel);
        });
    await fetchGrpcData();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int? userType = userProvider.userTypeId;

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
              const Text('Posts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 7),
              Expanded(
                child: ListView.separated(
                  itemCount: channelPosts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(channelPosts[index].title),
                      contentPadding: const EdgeInsets.all(8.0),
                      subtitle: Text(
                          "${channelPosts[index].description}\nPublished on: ${channelPosts[index].publishDate}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PostContent(post: channelPosts[index])),
                        );
                      },
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
      floatingActionButton: !widget.isChannelCreator
          ? null
          : FloatingActionButton(
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
