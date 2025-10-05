import 'package:fergog/screens/GamesScreen.dart';
import 'package:flutter/material.dart';
import 'package:gogdl_flutter/src/rust/api/auth.dart';
import 'package:gogdl_flutter/src/rust/api/games_downloader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool webBrowserOpened = false;
  final TextEditingController _loginCodeController = TextEditingController();
  Session session = Session();
  late GamesDownloader gamesDownloader;
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
                : [
                    const Text("Enter the login code here!"),
                    TextField(controller: _loginCodeController),
                    TextButton(onPressed: _handleLogin, child: Text('Submit')),
                  ],
          ),
        ),
      ),
    );
  }

  void _launchUrl() {
    setState(() {
      webBrowserOpened = true;
    });
    try {
      session.openBrowser();
    } catch (e) {
      print(e);
    }
  }

  void _handleLogin() async {
    String sessionCode = _loginCodeController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamesScreen(sessionCode: sessionCode),
      ),
    );
  }
}
