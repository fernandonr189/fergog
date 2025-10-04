import 'package:fergog/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool webBrowserOpened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Home screen"),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: !webBrowserOpened
                ? [
                    const Text('To see your games you need to login'),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                      child: TextButton(
                        onPressed: _launchUrl,
                        child: Text('Login'),
                      ),
                    ),
                  ]
                : [const Text("Enter the login code here!"), TextField()],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    setState(() {
      webBrowserOpened = true;
    });
    await launchUrl(
      Uri.parse(gogAuthUrl).replace(
        queryParameters: {
          'client_id': gogClientId,
          'redirect_uri': gogRedirectUri,
          'response_type': gogResponseType,
          'layout': gogLayout,
        },
      ),
    );
  }
}
