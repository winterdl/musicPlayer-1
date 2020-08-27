import 'package:flutter/material.dart';
import 'package:musicPlayer/models/Provider.dart';
import 'package:musicPlayer/models/config.dart';
import 'package:musicPlayer/screens/library.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen(this._isDark);
  final bool _isDark;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  AnimationController _controller;
  CurvedAnimation _curvedAnimation;
  Animation _colorAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      upperBound: 1.0,
    )..addListener(() {
        if (_controller.isCompleted) {
          // getAllSong called here to avoid laggy animation
          Provider.of<ProviderClass>(context, listen: false).getAllSongs();
          Future.delayed(Duration(seconds: 1)).then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Library()),
            );
          });
        }
      });
    _curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _colorAnimation = ColorTween(
            begin: Colors.white,
            end: widget._isDark ? Color(0xFF282C31) : Colors.grey[100])
        .animate(_controller);
    _controller.forward();
    super.initState();
  }

  @override
  void deactivate() {
    _controller.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var isPotrait = MediaQuery.of(context).orientation == Orientation.portrait;
    double height = isPotrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;
    double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _colorAnimation.value,
          body: Container(
            height: height,
            width: width,
            padding: EdgeInsets.symmetric(
                vertical: isPotrait
                    ? _curvedAnimation.value * (height / 3.1)
                    : _curvedAnimation.value * (height / 10.5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Opacity(
                  opacity: _curvedAnimation.value,
                  child: SizedBox(
                    width: Config.xMargin(context, _curvedAnimation.value * 55),
                    height: Config.yMargin(context, _curvedAnimation.value * 25),
                    child: Image(
                      image: AssetImage('images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Opacity(
                  opacity: _curvedAnimation.value,
                  child: Text(
                    'Vybe player',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          Config.textSize(context, _curvedAnimation.value * 8),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Acme',
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
