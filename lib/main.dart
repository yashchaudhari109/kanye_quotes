import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Kanye Quotes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _text="here is your quote";
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    final response = await http.get(Uri.parse('https://api.kanye.rest/'));
    var text1=response.body;
    setState(() {
      _text=jsonDecode(text1)["quote"];
    });
    _refreshController.refreshCompleted();
  }


  void _data() async{
    final response = await http.get(Uri.parse('https://api.kanye.rest/'));
    var text1=response.body;
    setState(() {
    _text=jsonDecode(text1)["quote"];
    });
    print(_text);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: SmartRefresher(
        // enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "$_text",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(

        onPressed:(){
          _data();
        },
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
