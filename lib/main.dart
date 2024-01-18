import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_series/firebase_options.dart';
import 'package:firebase_series/routes/MyRoutes.dart';
import 'package:firebase_series/screens/homescreen.dart';
import 'package:firebase_series/screens/login_screen.dart';
import 'package:firebase_series/screens/phone_sigin.dart';
import 'package:firebase_series/screens/signup.dart';
import 'package:firebase_series/screens/verification_otp.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

 // QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();  // for whole collection
 /* DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc('ENV2UEOXMgWSHRvkFIqW').get();  // for specific user
 *//* for(var doc in snapshot.docs)
    {
      print("FirebaseData"+doc.data().toString());
    }*//*  // for whole collection

  print("Firebasedata"+snapshot.data().toString());*/

  // for adding data to Firestore with default Document
   FirebaseFirestore _firestore = FirebaseFirestore.instance;
   Map<String,dynamic> userData = {
     'name':'Krishna',
     'email':'krishna@gmail.com'
   };
 /*  await _firestore.collection('users').add(userData);
   print('user added!');*/

   // for adding data to Firestore with manual Document
 /* await _firestore.collection('users').doc("unique_ids").set(userData);
  print('user added manually !');*/

  // for updating data to Firebasestore
  /*await _firestore.collection('users').doc('unique_ids').update({
    'email':'krishnaupdate@gmail.com'
  });*/

  // for deleting data to Firebasestore
   await _firestore.collection('users').doc('x96Q0oGz1FYSgD2PJZja').delete();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: (FirebaseAuth.instance.currentUser!=null) ? HomeScreen() : LoginScreen(),
      routes:
      {
        MyRoutes.signup_page:(context) => SignUpScreen(),
        MyRoutes.home_page:(context) => HomeScreen(),
        MyRoutes.phone_login:(context) => PhoneLogin(),

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
