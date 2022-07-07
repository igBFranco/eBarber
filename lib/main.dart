import 'package:ebarber/screens/auth_page.dart';
import 'package:ebarber/screens/home.dart';
import 'package:ebarber/screens/home_adm.dart';
import 'package:ebarber/provider/google_sign_in.dart';
import 'package:ebarber/utils/firebase_options.dart';
import 'package:ebarber/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => GoogleSignInProvider())
    ], child: const Main()),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      title: 'eBarber',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went Wrong!'),
            );
          } else if (snapshot.hasData) {
            if (FirebaseAuth.instance.currentUser!.uid ==
                "5KPlIagOKIYtrtfRfDLWNhoEYpf2") {
              return const HomeAdm();
            } else {
              return Home();
            }
          } else {
            return const AuthPage();
          }
        },
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt')],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: Color(0xFF0DA6DF)),
      ),
    );
  }
}
