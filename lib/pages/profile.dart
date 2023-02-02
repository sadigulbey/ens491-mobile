import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickrypt/models/event_model.dart';
import 'package:tickrypt/providers/metamask.dart';
import 'package:tickrypt/providers/user_provider.dart';
import 'package:tickrypt/services/user.dart';
import 'package:tickrypt/widgets/sliders/horizontal_slider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserService userService = UserService();
  late Future<List<Event>> events;

  void getEvents(publicAddress) {
    setState(() {
      events = userService.getEvents(publicAddress);
    });
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var metamaskProvider = Provider.of<MetamaskProvider>(context);
    if (!metamaskProvider.isConnected) {
      return (Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => {metamaskProvider.loginUsingMetamask()},
                  child: const Text("Connect"))
            ]),
      ));
    }
    if (userProvider.token == "") {
      userProvider.handleLogin(metamaskProvider);
      return Scaffold();
    }
    getEvents(metamaskProvider.currentAddress);
    return Scaffold(
      body: Column(
        children: [
          Text(userProvider.user!.username),
          // Get Events
          FutureBuilder<List<Event>>(
              future: events,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
                if (snapshot.hasData) {
                  return Text("Got Events");
                }
                return Text("Does not have events");
              })
        ],
        // Get Minted Tickets
      ),
    );
  }
}
