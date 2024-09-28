import 'package:flutter/material.dart';

class Channels extends StatelessWidget {
  final List<String> myChannels = <String>['My Channel 1', 'My Channel 2', 'My Channel 3'];
  final List<String> subscribedChannels = <String>['Sub Channel A', 'Sub Channel B'];
  final List<String> allChannels = <String>['Channel X', 'Channel Y', 'Channel Z'];
  final List<int> colorCodes = <int>[600, 500, 100];
  Channels({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Channels")),

      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: myChannels.length + subscribedChannels.length + allChannels.length + 3, // 3 extra for section headers
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Text(
              "My Channels",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            );
          } else if (index > 0 && index <= myChannels.length) {
            // My Channels section
            return Container(
              height: 50,
              color: Colors.amber[colorCodes[(index - 1) % colorCodes.length]],
              child: Center(child: Text(myChannels[index - 1])),
            );
          } else if (index == myChannels.length + 1) {
            return Text(
              "Subscribed Channels",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            );
          } else if (index > myChannels.length + 1 && index <= myChannels.length + subscribedChannels.length + 1) {
            // Subscribed Channels section
            return Container(
              height: 50,
              color: Colors.green[colorCodes[(index - (myChannels.length + 2)) % colorCodes.length]],
              child: Center(child: Text(subscribedChannels[index - (myChannels.length + 2)])),
            );
          } else if (index == myChannels.length + subscribedChannels.length + 2) {
            return Text(
              "All Channels",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            );
          } else {
            // All Channels section
            return Container(
              height: 50,
              color: Colors.blue[colorCodes[(index - (myChannels.length + subscribedChannels.length + 3)) % colorCodes.length]],
              child: Center(child: Text(allChannels[index - (myChannels.length + subscribedChannels.length + 3)])),
            );
          }
        },
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark_outlined), 
            label: 'Channels',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.account_box), 
            label: 'Profile',
          ),
        ]
      ),
    );
  }
}