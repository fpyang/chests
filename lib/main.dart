import 'package:flutter/material.dart';
import 'package:flutter_clash/chest.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_admob/firebase_admob.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '皇室戰爭: 寶箱預測機'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool loading = false;
  Chest chest = new Chest();
  final clashIdController = TextEditingController();

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }


  /*
  TextField(
  decoration: InputDecoration(
    border: InputBorder.none,
    hintText: 'Please enter a search term'
  ),
);
   */
  /*
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    clashIdController.dispose();
    super.dispose();
  }*/

  void _showUserDialog() {
    showDialog(
        context: context,
        builder: (_) => new Container(
            width: 260.0,
            height: 230.0,
            child: AlertDialog(
            title: new Text("請輸入你的皇室戰爭 id "),
            content: ListView(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                  TextField(
                      controller: clashIdController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '你的皇室戰爭 id'
                      )),
                Container(
                  child: RaisedButton(
                    child: const Text('確認', style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.white,fontSize: 16.0)),
                    color: Theme.of(context).accentColor,
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      Navigator.pop(context);
                      chest.uid = '2GVPVPGRU';
                      setState((){
                        loading = true;
                      });
                      /*
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      _counter = prefs.getInt('counter');
                      prefs.setInt('counter', ++_counter);
                      setState(() {
                        _counter = _counter;
                      });
                       */
                      http.get('https://api.royaleapi.com/player/'+ clashIdController.text + '',
                          headers: {'auth': "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjIxOCwiaWRlbiI6IjUyOTU3MjAxNTc0MTQ2ODY5MiIsIm1kIjp7fSwidHMiOjE1NDYzMzA2NzcwNTB9.jpffhslEopIBiaKzFrGZYCWgX-CCczGSiZtVe_ab6Qg"}
                      ).then((response){
                        setState((){
                          loading = false;
                        });
                        var jsonData = json.decode(response.body);
                        if(jsonData.containsKey('tag')){
                          chest.uid = clashIdController.text;
                          chest.refresh();
                        }else{
                          //alert warning
                          chest.alert();
                        }
                      });

                    },
              ),
                )
            ]
          ),
        )
        )
    );
  }

  Widget _buildContent() {

    if (loading) {
      return new Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          new CircularProgressIndicator(),
          new Text("Loading"),
        ],
      );
  }
    return chest;
  }



  @override
  Widget build(BuildContext context) {

    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-2930499231441098~4137108254').then((response){
      myBanner
      // typically this happens well before the ad is shown
        ..load()
        ..show(
          // Positions the banner ad 60 pixels from the bottom of the screen
          anchorOffset: 60.0,
          // Banner Position
          anchorType: AnchorType.bottom,
        );
    });

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    /*
    new Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          new CircularProgressIndicator(),
          new Text("Loading"),
        ],
      )
    */
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.bookmark),
                  onPressed: () { Scaffold.of(context).openDrawer(); },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            )
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              chest,
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: new IconButton(
                  icon: Icon(Icons.refresh, size: 50.0),
                  tooltip: '重新整理',
                  onPressed: () {
                    chest.uid = '929CU2J2Y';
                    chest.refresh();
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showUserDialog,
          tooltip: '新增使用者',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );


    }


}


MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.io',
  childDirected: false,
  testDevices: <String>[], // Android emulators are considered test devices
);

BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: BannerAd.testAdUnitId,
  size: AdSize.smartBanner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);
