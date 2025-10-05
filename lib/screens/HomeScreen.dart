import 'package:fergog/screens/GamesScreen.dart';
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
  bool errorOccurred = false;
  final TextEditingController _loginCodeController = TextEditingController();
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
                    Text(
                      errorOccurred
                          ? 'An error occurred trying to open the browser'
                          : 'To see your games you need to login',
                    ),
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

  void _launchUrl() async {
    setState(() {
      webBrowserOpened = true;
    });
    try {
      await launchUrl(
        Uri.parse("https://auth.gog.com/auth").replace(
          queryParameters: {
            "client_id": "46899977096215655",
            "client_secret":
                "9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9",
            "redirect_uri":
                "https://embed.gog.com/on_login_success?origin=client",
            "response_type": "code",
            "layout": "client2",
          },
        ),
      );
    } catch (e) {
      print(e);
      setState(() {
        webBrowserOpened = false;
        errorOccurred = true;
      });
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
