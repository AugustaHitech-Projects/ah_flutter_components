import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_button/loading_button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading Button Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final LoadingButtonController _btnController1 = LoadingButtonController();

  void _doSomething(bool isSuccess) async {
    Timer(const Duration(seconds: 5), () {
      if (isSuccess == true) {
        _btnController1.success();
      } else {
        _btnController1.error();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _btnController1.stateStream.listen((value) {
      debugPrint(value.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rounded Loading Button Demo'),
          actions: [
            InkWell(
              onTap: () {
                _btnController1.reset();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.lock_reset),
              ),
            ),
          ],
        ),
        body: Center(
          child: LoadingButton(
            successIcon: Icons.thumb_up,
            failedIcon: Icons.thumb_down,
            controller: _btnController1,
            onPressed: () => _doSomething(false),
            child: const Text('Tap me!', style: TextStyle(color: Colors.white)),
          ),
        ));
  }
}
