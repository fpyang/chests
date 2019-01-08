// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;


class Chest extends StatefulWidget {
  final _ChestState cs = _ChestState();
  String _uid = '';

  void refresh(){
    cs.refresh();
  }

  void set uid(u){
    _uid = u;
  }
  String get uid => _uid;
  @override
  State<StatefulWidget> createState() {
    return cs;
  }


}

class _ChestState extends State<Chest> {
  List<Widget> widgets = new List<Widget>();
  List<Widget> chestLocations = new List<Widget>();
  Row profileWidget = new Row();
  String profile = '';

  Widget chestStatFactory(String imgURL, int count, num height, num width){

    return new Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: [Image.asset(imgURL,
            height: height, width: width),
            Text(count.toString(),
                style: TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6),fontSize: 20.0))
        ]
      ),

    );

  }

  void refresh() async {
    double width = MediaQuery.of(context).size.width;
    double chestSize = (width-180)/3;


    await this.fetchProfile(widget.uid).then((value){
      Map jsonData = json.decode(value.body);
      String imgURL = jsonData['clan']['badge']['image'];
      print(jsonData['clan']['badge']['image']);
      profile=jsonData['tag'] + '\n' + jsonData['name'];
      profileWidget=Row(
        children: [
          Image.network(imgURL,
              height: 50, width: 50),
          Column(
            children: [
              Text(jsonData['name'], style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.6),fontSize: 20.0)),
              Text(jsonData['tag'], style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.6),fontSize: 10.0))
            ]
          )
        ]
      );
      print(jsonData);

    });

    await this.fetchChests(widget.uid).then((value){
      Map jsonData = json.decode(value.body);

      var data = jsonData['upcoming'];
      var dd = new Map.from(jsonData);

      setState((){
        int index = 0;
        widgets = data.map<Widget>((data){
          //padding: const EdgeInsets.all(9.0),
          index = index + 1;
          return Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
                children: [
                  Text(index.toString()+' ', style: TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.6),fontSize: 20.0)),
                  Image.network(nameMapping(data),
                      height: chestSize, width: chestSize),
                ]
            ),
          );
        }).toList();
      });
      num chestStatWidth = (width-100)/5;
      var megaLightning = chestStatFactory('assets/chests/super-magical-chest.png', dd['megaLightning']+1, chestStatWidth,chestStatWidth);
      var magical = chestStatFactory('assets/chests/magical-chest.png', dd['magical']+1, chestStatWidth,chestStatWidth);
      var legendary = chestStatFactory('assets/chests/legendary-chest.png', dd['legendary']+1, chestStatWidth,chestStatWidth);
      var epic = chestStatFactory('assets/chests/epic-chest.png', dd['epic']+1, chestStatWidth,chestStatWidth);
      var giant = chestStatFactory('assets/chests/giant-chest.png', dd['giant']+1, chestStatWidth,chestStatWidth);
      setState(() {
        chestLocations = [megaLightning, magical, legendary, epic, giant];
      });

    });
  }

  //test uid: 929CU2J2Y
  Future<http.Response> fetchChests(uid) async {
    return await http.get('https://api.royaleapi.com/player/'+ uid + '/chests',
        headers: {'auth': "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjIxOCwiaWRlbiI6IjUyOTU3MjAxNTc0MTQ2ODY5MiIsIm1kIjp7fSwidHMiOjE1NDYzMzA2NzcwNTB9.jpffhslEopIBiaKzFrGZYCWgX-CCczGSiZtVe_ab6Qg"}
    );
  }

  //test uid: 929CU2J2Y
  Future<http.Response> fetchProfile(uid) async {
    return await http.get('https://api.royaleapi.com/player/'+ uid + '',
        headers: {'auth': "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjIxOCwiaWRlbiI6IjUyOTU3MjAxNTc0MTQ2ODY5MiIsIm1kIjp7fSwidHMiOjE1NDYzMzA2NzcwNTB9.jpffhslEopIBiaKzFrGZYCWgX-CCczGSiZtVe_ab6Qg"}
    );
  }

  String nameMapping(String orgName){
    String prefix = 'http://www.clashapi.xyz/images/chests/';
    String suffix = '-chest.png';
    orgName = orgName.replaceAll("gold", "golden");
    if(orgName=='mega lightning'){

      return 'http://www.clashapi.xyz/images/chests/super-magical-chest.png';

    }else{
      String dashName = orgName.replaceAll(" ", "-");
      return prefix + dashName + suffix;
    }
  }

  @override
  // This `context` parameter describes the location of this widget in the
  // widget tree. It can be used for obtaining Theme data from the nearest
  // Theme ancestor in the tree. Below, we obtain the display1 text theme.
  // See https://docs.flutter.io/flutter/material/Theme-class.html
  Widget build(BuildContext context) {
    if(widgets.length == 9){
      return Material(
          color: Colors.transparent,
          child:
          Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    profileWidget,
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: widgets.sublist(0, 3)),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: widgets.sublist(3, 6)),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: widgets.sublist(6, 9)),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: chestLocations)
                  ]
              )
          )
      );
    }else{
      return Material();
    }

  }

}