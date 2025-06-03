import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _counter = 0.0;
  var myFontSize = 30.0;

  void setNewValue(double value) {
    setState(() {
      _counter = value;
      myFontSize = value;
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (_counter < 99.0) {
        _counter++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "BROWSE CATEGORIES",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),

            Text(
              "Not sure about exactly which recipe you're looking for? Do a search or dive into our most popular categories.",
              style: TextStyle(fontSize: 15.0),
              textAlign: TextAlign.left,
            ),

            Text(
              "BY MEAT",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('images/beef.png'),
                      radius: 45,
                    ),
                    Text(
                      "BEEF",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset.zero,
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('images/chicken.png'),
                      radius: 45,
                    ),
                    Text(
                      "CHICKEN",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset.zero,
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('images/pork.png'),
                      radius: 45,
                    ),
                    Text(
                      "PORK",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset.zero,
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('images/seafood.png'),
                      radius: 45,
                    ),
                    Text(
                      "SEAFOOD",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset.zero,
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Text(
              "BY COURSE",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('images/maindishes.png'),
                      radius: 45,
                    ),
                    SizedBox(
                      width: 55,
                      child: Text(
                        "Main Dishes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('images/salad.png'),
                      radius: 45,
                    ),
                    SizedBox(
                      width: 55,
                      child: Text(
                        "Salad Recipes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('images/sidedishes.png'),
                      radius: 45,
                    ),
                    SizedBox(
                      width: 55,
                      child: Text(
                        "Side Dishes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('images/crockpot.png'),
                      radius: 45,
                    ),
                    SizedBox(
                      width: 55,
                      child: Text(
                        "Crockpot",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Text(
              "BY DESSERT",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('images/icecream.jpg'),
                      radius: 45,
                    ),
                    SizedBox(
                      width: 55,
                      child: Text(
                        "Ice Cream",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('images/brownies.jpg'),
                      radius: 45,
                    ),
                    SizedBox(
                      width: 55,
                      child: Text(
                        "Brownies",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('images/pies.jpg'),
                      radius: 45,
                    ),
                    SizedBox(
                      width: 55,
                      child: Text(
                        "Pies",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('images/cookies.jpg'),
                      radius: 45,
                    ),
                    SizedBox(
                      width: 55,
                      child: Text(
                        "Cookies",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}