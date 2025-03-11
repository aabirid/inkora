import 'package:flutter/material.dart';

class LearnFlutterPage extends StatefulWidget {
  const LearnFlutterPage({super.key});

  @override
  State<LearnFlutterPage> createState() => _LearnFlutterPageState();
}

class _LearnFlutterPageState extends State<LearnFlutterPage> {
  bool isSwitch = false;
  bool? isCheckBox = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Flutter'),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        actions: [
          IconButton(
              onPressed: () {
                debugPrint('Search!!!');
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                debugPrint('Notifications!!!');
              },
              icon: Icon(Icons.notifications_none_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/butterfly.jpeg'),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              color: Colors.green,
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(5.0),
              width: double.infinity,
              color: Colors.green,
              child: const Center(
                child: Text(
                  'Butterflies are pretty!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSwitch ? Colors.green : Colors.white,
              ),
              onPressed: () {
                debugPrint('Btn!!!');
              },
              child: const Text('elevated Btn'),
            ),
            OutlinedButton(
              onPressed: () {
                debugPrint('Outlined!!!');
              },
              child: const Text('Outlined Btn'),
            ),
            TextButton(
              onPressed: () {
                debugPrint('Text!!!');
              },
              child: const Text('Text Btn'),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('clicked!!');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.accessibility, color: Colors.green),
                  Text("Helloooo!"),
                  Icon(Icons.accessibility, color: Colors.green),
                ],
              ),
            ),
            Switch(
                value: isSwitch,
                onChanged: (bool newBool) {
                  setState(() {
                    isSwitch = newBool;
                  });
                }),
            Checkbox(
                value: isCheckBox,
                onChanged: (bool? newBool) {
                  setState(() {
                    isCheckBox = newBool;
                  });
                }),
            Image.asset('assets/images/welcome_bg.jpeg'),
          ],
        ),
      ),
    );
  }
}
