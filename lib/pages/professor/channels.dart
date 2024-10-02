import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:study_vault/pojos/channel.dart';
import 'package:study_vault/utils/constants.dart';

class Channels extends StatefulWidget {
  const Channels({super.key});

  @override
  State<Channels> createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  late List<Channel> myChannels = [];
  late List<Channel> subscribedChannels = [];
  late List<Channel> allChannels = [];

  final int userType = 1; // 2 student, 1 professor

  Future<void> fetchData() async {
    bool isStudent = userType == Constants.studentType;

    if (isStudent) {
      final myChannelsResponse =
          await http.get(Uri.parse('http://127.0.0.1:8080/channels/owner/2'));
      // replace 1 for user id in session
      final subscribedChannelsResponse = await http
          .get(Uri.parse('http://127.0.0.1:8080/subscriptions/user/1'));
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
      final subscribedChannelsResponse =
        await http.get(Uri.parse('http://127.0.0.1:8080/subscriptions/user/1'));
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
        await http.get(Uri.parse('http://127.0.0.1:8080/channels/owner/2'));
    // replace 1 for user id in session
    final subscribedChannelsResponse =
        await http.get(Uri.parse('http://127.0.0.1:8080/subscriptions/user/1'));
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
    fetchData();
  }

  void onChannelTap(Channel channel) {
    print("Tapped on channel: ${channel.name}");
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ChannelDetails(channel)));
  }

  @override
  Widget build(BuildContext context) {
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
                                  onPressed: () {},
                                  child: const Text('Unsubscribe')),
                              onTap: () {},
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
                                  onPressed: () {},
                                  child: const Text('Subscribe')),
                              dense: true,
                            );
                          },
                        ),
                      ]
                    : [
                        // My channels (non-student)
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
                              onTap: () {},
                            );
                          },
                        ),
                        // Subscribed channels (non-student)
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
                              onTap: () {},
                            );
                          },
                        ),
                        // All channels (non-student)
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
      floatingActionButton: FloatingActionButton(
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
