import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'classes.dart';
 
 void main(){
 runApp(const MyApp());
}

  class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(storage: CounterStorage() ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.storage}) : super(key: key);
  final CounterStorage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int sharedpref = 0;
  int pathprov   = 0;

  @override
  void initState() {
    super.initState();
    _loadCntSharedPref();
    _loadCntPathProv ();

  }
  void _loadCntSharedPref() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      sharedpref = (sharedPref.getInt('countershared') ?? 0);
    });
  }
  void _loadCntPathProv () {
    widget.storage.readCounter().then((int value) {
      setState(() {
        pathprov = value;
      });
    });
  }
  void _incCntSharedPref() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      sharedpref = (sharedPref.getInt('countershare') ?? 0) + 1;
      sharedPref.setInt('countershared', sharedpref);
    });
  }

  Future <File> _incCntPathProv() {
    setState(() {
      pathprov ++;
    });
    return widget.storage.writeCounter( pathprov );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share_pref&path'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$sharedpref',),
            ElevatedButton(
                onPressed: _incCntSharedPref,
                child: const Icon(Icons.add),
            ),
            const Text(
              'Shared preferences'),
             const SizedBox(height: 40,),
            Text('$pathprov',),
            ElevatedButton( onPressed: _incCntPathProv,
              child: const Icon(Icons.add), ),
             const Text('Path provider'),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}