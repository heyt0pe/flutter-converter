import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  TextEditingController ourValue = new TextEditingController();

  bool loading = false;

  double convertedValue = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void getApi() async {
    setState(() {
      loading = true;
    });
    var response = await http.get('https://api.exchangeratesapi.io/latest');
    var rates = json.decode(response.body);
    print('usd is ${rates['rates']['USD']}');
    setState(() {
      loading = false;
      convertedValue = double.parse(ourValue.text) * rates['rates']['USD'];
      print(convertedValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: ourValue,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.9,
              child: RaisedButton(onPressed: () {
                getApi();
              },
                child: loading ? CircularProgressIndicator() : Text('Convert to USD', style: TextStyle(color: Colors.white,)),
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text('FROM EUR TO USD', style: TextStyle(fontSize: 16, color: Colors.black),),
            Text('The value is $convertedValue', style: TextStyle(fontSize: 20, color: Colors.black),),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getApi();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
