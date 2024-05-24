import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/api.dart';
import '../view/LoginAndRegister/login.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();

    return IconButton(
      onPressed: () {
        showCupertinoDialog<String>(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                actionScrollController: ScrollController(
                    keepScrollOffset: true, initialScrollOffset: 10),
                title: const Text("Log out",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                content: const Text("Are you sure to log out",
                    style: TextStyle(
                        fontFamily: 'CrimsonText',
                        fontSize: 15,
                        color: Colors.black87)),
                actions: [
                  TextButton(
                      onPressed: () async {
                        // await API.updateActiveStatus(false);
                        await api.exitData();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Login(),
                        ));
                      },
                      child: const Text("Yes")),
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text("No"))
                ],
              );
            });
      },
      icon: const Icon(
        Icons.logout,
        color: Colors.black,
      ),
    );
  }
}
