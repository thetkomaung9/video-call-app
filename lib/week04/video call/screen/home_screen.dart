import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super (key: key);

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: _Logo()),
              Expanded(child: _Image()),
              Expanded(child: _EntryButton()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super (key: key);

  @override
  Widget build (BuildContext context){
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          border
        )
      )
    )
  }
}