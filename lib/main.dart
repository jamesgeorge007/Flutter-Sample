import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './views/view_cell.dart';

void main() => runApp(new RealWorldApp());

class RealWorldApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RealWorldState();
  }
}

class RealWorldState extends State<RealWorldApp> {
  var _isLoading = true;
  var videos;

  _fetchData() async {
    final url = 'https://api.letsbuildthatapp.com/youtube/home_feed';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final videosJson = map["videos"];

      setState(() {
        _isLoading = false;
        this.videos = videosJson;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text("Real World App"),
              actions: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.refresh),
                  onPressed: () {
                    print('Reloading triggered!');
                    _fetchData();
                  },
                )
              ],
            ),
            body: new Center(
                child: _isLoading
                    ? new CircularProgressIndicator()
                    : new ListView.builder(
                        itemCount: this.videos.length,
                        itemBuilder: (context, i) {
                          final video = this.videos[i];
                          new FlatButton(
                            padding: EdgeInsets.all(0.0),
                          child: new VideoCell(video),
                          onPressed: () {
                           print('$i Pressed');
                           Navigator.push(context, 
                           new MaterialPageRoute(
                             builder: (context) => DetailPage()
                           ));
                          },
                          );
                        }))));
  }
}

class DetailPage extends StatelessWidget{
  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Details page")
        ),
        body: new Center(child: new Text("Sample"),)
      );
    }
}

