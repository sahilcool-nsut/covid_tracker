import 'package:covid_tracker/tracking.dart';
import 'package:flutter/material.dart';
import 'apiData.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:covid_tracker/IndiaScreen.dart';
class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}
class _LoadingScreenState extends State<LoadingScreen> {

  var data;
  var statesList;

  void getData() async{
    data = await ApiData().getData();
    if(data==null)
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TrackingScreen(covidData: null,statesList: null)),
        );
      }
    else
      {
        statesList = await ApiData().getStates();

        Navigator.of(context).pushReplacement(new PageRouteBuilder(
            maintainState: true,
            opaque: true,
            pageBuilder: (context, _, __) => new TrackingScreen(covidData: data,statesList: statesList,),
            transitionDuration: const Duration(milliseconds: 2000),
            transitionsBuilder: (context, anim1, anim2, child) {
              return new FadeTransition(
                child: child,
                opacity: anim1,
              );
            }));
      }

  }
  @override
  void initState(){
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/background2.jpg"),
              fit: BoxFit.cover,
            )),
        child: Column(


          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                        image: AssetImage('images/virus2.png'),
                        width: MediaQuery.of(context).size.width * 0.4,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Coronavirus Tracker",
                      style: TextStyle(
                        color: Color(0xFFe74873),
                        fontFamily: 'Itim',
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,

              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: TypewriterAnimatedTextKit(
                      speed: Duration(milliseconds:500),
                      repeatForever: true,

                      text: [
                        "Loading...",
                      ],
                      textStyle: TextStyle(
                          fontSize: 24.0,
                          fontFamily: "Itim",
                        color: Colors.pink
                      ),
                      textAlign: TextAlign.start,
                      alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
// Expanded(
//              flex: 1,
//
//              child: Align(
//                alignment: FractionalOffset.bottomCenter,
//                child: Padding(
//                  padding: const EdgeInsets.all(32.0),
//                  child: Text("Loading..",style: TextStyle(
//
//                    color: Color(0xFFe74873),
//                    fontFamily: 'Itim',
//                    fontSize: 22,
//                  ),
//                    textAlign: TextAlign.center,),
//                ),
//              ),
//            )