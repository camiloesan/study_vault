import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:study_vault/pages/channel_content.dart';
import 'dart:convert';
import 'package:study_vault/pojos/channel.dart';
import 'package:study_vault/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:study_vault/utils/user_provider.dart';

class Channels extends StatefulWidget {
  const Channels({super.key});

  @override
  State<Channels> createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  late List<Channel> myChannels = [];
  late List<Channel> subscribedChannels = [];
  late List<Channel> allChannels = [];

  //final int userType = 2; // 2 student, 1 professor
  //final int tempUserId = 1;

  Future<void> fetchData(int? userId, int? userType) async {
    bool isStudent = userType == Constants.studentType;

    if (isStudent) {
      final myChannelsResponse =
          await http.get(Uri.parse('http://127.0.0.1:8080/channels/owner/$userId'));
      // replace 1 for user id in session
      final subscribedChannelsResponse = await http
          .get(Uri.parse('http://127.0.0.1:8080/subscriptions/user/$userId'));
      final allChannelsResponse =
          await http.get(Uri.parse('http://127.0.0.1:8080/channels/all'));

      if (allChannelsResponse.statusCode == 200 &&
          myChannelsResponse.statusCode == 200 &&
          subscribedChannelsResponse.statusCode == 200) {
        List<dynamic> jsonMyChannels =
            json.decode(utf8.decode(myChannelsResponse.bodyBytes));
        List<dynamic> jsonSubscribedChannels =
            json.decode(utf8.decode(subscribedChannelsResponse.bodyBytes));
        List<dynamic> jsonAllChannels =
            json.decode(utf8.decode(allChannelsResponse.bodyBytes));

        setState(() {
          myChannels = jsonMyChannels
              .map((channel) => Channel.fromJson(channel))
              .toList();
          subscribedChannels = jsonSubscribedChannels
              .map((channel) => Channel.fromJson(channel))
              .toList();
          allChannels = jsonAllChannels
              .map((channel) => Channel.fromJson(channel))
              .toList();
          allChannels.removeWhere((channel) => subscribedChannels.any(
              (subscribedChannel) =>
                  subscribedChannel.channelId == channel.channelId));
        });
      } else {
        throw Exception('Failed to load data'); // Send an alert instead
      }
    } else {
      // replace 1 for user id in session
      final subscribedChannelsResponse = await http
          .get(Uri.parse('http://127.0.0.1:8080/subscriptions/user/$userId'));
      final allChannelsResponse =
          await http.get(Uri.parse('http://127.0.0.1:8080/channels/all'));

      if (allChannelsResponse.statusCode == 200 &&
          subscribedChannelsResponse.statusCode == 200) {
        List<dynamic> jsonSubscribedChannels =
            json.decode(utf8.decode(subscribedChannelsResponse.bodyBytes));
        List<dynamic> jsonAllChannels =
            json.decode(utf8.decode(allChannelsResponse.bodyBytes));

        setState(() {
          subscribedChannels = jsonSubscribedChannels
              .map((channel) => Channel.fromJson(channel))
              .toList();
          allChannels = jsonAllChannels
              .map((channel) => Channel.fromJson(channel))
              .toList();
          allChannels.removeWhere((channel) => subscribedChannels.any(
              (subscribedChannel) =>
                  subscribedChannel.channelId == channel.channelId));
        });
      } else {
        throw Exception('Failed to load data'); // Send an alert instead
      }
    }

    final myChannelsResponse =
        await http.get(Uri.parse('http://127.0.0.1:8080/channels/owner/$userId'));
    // replace 1 for user id in session
    final subscribedChannelsResponse =
        await http.get(Uri.parse('http://127.0.0.1:8080/subscriptions/user/$userId'));
    final allChannelsResponse =
        await http.get(Uri.parse('http://127.0.0.1:8080/channels/all'));

    if (allChannelsResponse.statusCode == 200 &&
        myChannelsResponse.statusCode == 200 &&
        subscribedChannelsResponse.statusCode == 200) {
      List<dynamic> jsonMyChannels =
          json.decode(utf8.decode(myChannelsResponse.bodyBytes));
      List<dynamic> jsonSubscribedChannels =
          json.decode(utf8.decode(subscribedChannelsResponse.bodyBytes));
      List<dynamic> jsonAllChannels =
          json.decode(utf8.decode(allChannelsResponse.bodyBytes));

      setState(() {
        myChannels =
            jsonMyChannels.map((channel) => Channel.fromJson(channel)).toList();
        subscribedChannels = jsonSubscribedChannels
            .map((channel) => Channel.fromJson(channel))
            .toList();
        allChannels = jsonAllChannels
            .map((channel) => Channel.fromJson(channel))
            .toList();
        allChannels.removeWhere((channel) => subscribedChannels.any(
            (subscribedChannel) =>
                subscribedChannel.channelId == channel.channelId));
      });
    } else {
      throw Exception('Failed to load data'); // Send an alert instead
    }
  }

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    fetchData(userProvider.userId, userProvider.userTypeId);
  }

  void onChannelTap(Channel channel) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChannelContent(channel: channel)));
  }

  Future<bool> onChannelUnsubscribe(int userId, int channelId) async {
    final url = Uri.parse('http://localhost:8080/unsubscribe');
    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      'user_id': userId,
      'channel_id': channelId,
    });

    try {
      final response = await http.delete(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
    }

    return false;
  }

  Future<bool> onChannelSubscribe(int userId, int channelId) async {
    final url = Uri.parse('http://localhost:8080/subscription');
    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      'user_id': userId,
      'channel_id': channelId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int? userType = userProvider.userTypeId;
    final int? userId = userProvider.userId;

    bool isStudent = userType == Constants.studentType;

    return Scaffold(
      appBar: AppBar(title: const Text("Channels")),
      body: DefaultTabController(
        length: isStudent ? 2 : 3,
        child: Column(
          children: <Widget>[
            TabBar(
              tabs: isStudent
                  ? const [
                      Tab(text: 'Subscriptions'),
                      Tab(text: 'All'),
                    ]
                  : const [
                      Tab(text: 'My channels'),
                      Tab(text: 'Subscriptions'),
                      Tab(text: 'All'),
                    ],
            ),
            Expanded(
              child: TabBarView(
                children: isStudent
                    ? [
                        // Subscribed channels (for student)
                        ListView.builder(
                          itemCount: subscribedChannels.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(subscribedChannels[index].name),
                              contentPadding: const EdgeInsets.all(8.0),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.person),
                                  const SizedBox(width: 6),
                                  Text(
                                      '${subscribedChannels[index].creatorName} ${subscribedChannels[index].creatorLastName}')
                                ],
                              ),
                              trailing: ElevatedButton(
                                  onPressed: () async {
                                    bool? confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Unsubscribe'),
                                          content: const Text(
                                              'Are you sure you want to unsubscribe from this channel?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text('Continue'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirm == true) {
                                      int channelId =
                                          subscribedChannels[index].channelId;
                                      bool result = await onChannelUnsubscribe(
                                          userId!, channelId);

                                      if (result) {
                                        setState(() {
                                          allChannels
                                              .add(subscribedChannels[index]);
                                          subscribedChannels.remove(
                                              subscribedChannels[index]);
                                        });
                                      }
                                    }
                                  },
                                  child: const Text('Unsubscribe')
                                ),
                              onTap: () => onChannelTap(subscribedChannels[index]),
                            );
                          },
                        ),
                        // All channels (for student)
                        ListView.builder(
                          itemCount: allChannels.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(allChannels[index].name),
                              contentPadding: const EdgeInsets.all(8.0),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.person),
                                  const SizedBox(width: 6),
                                  Text(
                                      '${allChannels[index].creatorName} ${allChannels[index].creatorLastName}')
                                ],
                              ),
                              trailing: ElevatedButton(
                                  onPressed: () async {
                                    int channelId =
                                        allChannels[index].channelId;
                                    bool result = await onChannelSubscribe(
                                        userId!, channelId);
                                    if (result) {
                                      setState(() {
                                        subscribedChannels
                                            .add(allChannels[index]);
                                        allChannels.remove(allChannels[index]);
                                      });
                                    }
                                  },
                                  child: const Text('Subscribe')),
                              dense: true,
                            );
                          },
                        ),
                      ]
                    : [
                        // My channels (professor)
                        ListView.builder(
                          itemCount: myChannels.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(myChannels[index].name),
                              contentPadding: const EdgeInsets.all(8.0),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.person),
                                  const SizedBox(width: 6),
                                  Text(
                                      '${myChannels[index].creatorName} ${myChannels[index].creatorLastName}')
                                ],
                              ),
                              onTap: () => onChannelTap(myChannels[index]),
                            );
                          },
                        ),
                        // Subscribed channels (professor)
                        ListView.builder(
                          itemCount: subscribedChannels.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(subscribedChannels[index].name),
                              contentPadding: const EdgeInsets.all(8.0),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.person),
                                  const SizedBox(width: 6),
                                  Text(
                                      '${subscribedChannels[index].creatorName} ${subscribedChannels[index].creatorLastName}')
                                ],
                              ),
                              trailing: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Unsubscribe')),
                              onTap: () => onChannelTap(subscribedChannels[index]),
                            );
                          },
                        ),
                        // All channels (professor)
                        ListView.builder(
                          itemCount: allChannels.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(allChannels[index].name),
                              contentPadding: const EdgeInsets.all(8.0),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.person),
                                  const SizedBox(width: 6),
                                  Text(
                                      '${allChannels[index].creatorName} ${allChannels[index].creatorLastName}')
                                ],
                              ),
                              trailing: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Subscribe')),
                              dense: true,
                            );
                          },
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isStudent
          ? null
          : FloatingActionButton(
              onPressed: () {},
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
