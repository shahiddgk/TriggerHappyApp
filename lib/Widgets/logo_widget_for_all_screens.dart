import 'package:flutter/material.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({Key? key}) : super(key: key);

  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.width/4.7,
      width: MediaQuery.of(context).size.width/1.7,
      child: Image.asset("assets/trigger_logo.png",fit: BoxFit.fill,height: MediaQuery.of(context).size.width/4.7,width: MediaQuery.of(context).size.width,),
    );
  }
}
