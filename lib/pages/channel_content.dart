import 'package:flutter/material.dart';
import 'package:study_vault/pages/post_content.dart';
import 'package:study_vault/pages/post_creation.dart';
import 'package:study_vault/models/channel.dart';
import 'package:study_vault/services/channels_services.dart';
import 'package:study_vault/src/generated/studyvault.pbgrpc.dart';

class ChannelContent extends StatefulWidget {
  const ChannelContent(
      {super.key, required this.channel, required this.isChannelCreator});

  final Channel channel;
  final bool isChannelCreator;

  @override
  State<ChannelContent> createState() => _ChannelContentState();
}

class _ChannelContentState extends State<ChannelContent> {
  late List<PostsResponse_PostInfo> channelPosts = [];

  void updatePosts() async {
    try {
      var response =
          await ChannelsServices.fetchChannelPosts(widget.channel.channelId);

      setState(() {
        channelPosts = response;
      });
    } catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot retrieve posts, try again later')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    updatePosts();
  }

  void createNewPost() async {
    await showDialog(
        context: context,
        builder: (context) {
          return PostCreation(channel: widget.channel);
        });

    try {
      updatePosts();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot retrieve posts, try again later')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    return Dismissible(
                      key: ValueKey(channelPosts[index]),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        // Save the deleted item for Snackbar if needed
                        final deletedPost = channelPosts[index];

                        setState(() {
                          channelPosts.removeAt(index); // Remove item immediately
                        });

                        // Show a Snackbar for undo functionality (optional)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Deleted ${deletedPost.title}"),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                setState(() {
                                  channelPosts.insert(index, deletedPost); // Restore item
                                });
                              },
                            ),
                          ),
                        );
                      },
                      background: Container(
                        color: Colors.red, // Background color when swiping
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white), // Icon for delete
                      ),
                      child: ListTile(
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
                      ),
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
