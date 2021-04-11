import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'dart:collection';
import 'package:covid_tracker/IndiaScreen.dart';

class TrackingScreen extends StatefulWidget {
  TrackingScreen({this.covidData, this.statesList});
  final covidData;
  final statesList;
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  var covidData;
  var statesList;
  TextStyle style1 = TextStyle(
    color: Colors.white,
    fontSize: 25,
    fontFamily: 'Itim',
  );


  String active;
  String confirmed;
  String deaths;
  String recovered;
  String deltaconfirmed;
  String deltadeaths;
  String deltarecovered;
  String lastUpdated;
  String selectedState = "Maharashtra";
  List<TableRow> districtTableRows=[];
  @override
  void initState() {
    super.initState();
    covidData = widget.covidData;
    statesList = widget.statesList;
  print(covidData);
    updateUI();
  }

  Widget coloredBox(Widget child,{bool c=false,bool a=false,bool d=false,bool heading=false})
  {
    return Container(
      margin: (d||c||a)?EdgeInsets.only(bottom: 5.0):EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        border:Border(
          top: BorderSide(
            color: heading? c? Colors.pink:a? Colors.blue:d?Colors.black:Colors.white:Colors.white,
            width: 2,
          ),
          bottom: BorderSide(
            color:heading? c? Colors.pink:a? Colors.blue:d?Colors.black:Colors.white:Colors.white,
            width:2,
          ),
          left: BorderSide(
            color:heading?c? Colors.pink:a? Colors.blue:d?Colors.black:Colors.white:Colors.white,
            width:2,
          ),
          right: BorderSide(
            color:heading?c? Colors.pink:a? Colors.blue:d?Colors.black:Colors.white:Colors.white,
            width:2,
          ),

        )
      ),
      child: child,
    );
  }
  // FOR TABLE
  void getTableData(LinkedHashMap m){
    if(covidData==null)
      {
        return;
      }
    if(districtTableRows!=null)
      {
        districtTableRows.clear();
      }
    districtTableRows.add(
      TableRow(
        children: [
          coloredBox(Text("District",textScaleFactor: 1.4,textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Roboto'),),d: true,heading: true),
          coloredBox(Text("Confirmed",textScaleFactor: 1.4,textAlign: TextAlign.center,style: TextStyle(color: Colors.pink,fontFamily: 'Roboto'),),c: true,heading:true),
          coloredBox(Text("Active",textScaleFactor: 1.4,textAlign: TextAlign.center,style: TextStyle(color: Colors.blue,fontFamily: 'Roboto'),),a:true,heading:true),
         // Text("R",textScaleFactor: 1.0,textAlign: TextAlign.center,style: TextStyle(color: Colors.green),),
         // Text("D",textScaleFactor: 1.0,textAlign: TextAlign.center,style: TextStyle(color: Colors.grey),),
        ]
      )
    );

    m.forEach((district,value){

      TableRow temp = TableRow(
          children: [
            coloredBox(Text(district,textScaleFactor: 1.05,textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Roboto'),),d:true),
            coloredBox(Text(covidData["state_wise"][selectedState]["district"][district]["confirmed"].toString(),textScaleFactor: 1.0,textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Roboto')),c:true),
            coloredBox(Text(covidData["state_wise"][selectedState]["district"][district]["active"].toString(),textScaleFactor: 1.0,textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Roboto')),a:true),
            //Text(covidData["state_wise"][selectedState]["district"][district]["recovered"].toString(),textScaleFactor: 1.0,textAlign: TextAlign.center,),
            //Text(covidData["state_wise"][selectedState]["district"][district]["deceased"].toString(),textScaleFactor: 1.0,textAlign: TextAlign.center,),
          ]
      );
      districtTableRows.add(temp);
    });
  }


  // FOR DROPDOWN
 DropdownButton<String> androidDropDown() {
    if(covidData!=null) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      statesList.forEach((k) {
        var item = new DropdownMenuItem<String>(
          child: Text(k),
          value: k,
        );
        dropDownItems.add(item);
      });

      return DropdownButton<String>(
          hint: Text(
            selectedState,
            style: kDropDownSelected,
          ),
          underline: Container(
            height: 1,
            color: Colors.pink,
          ),
          value: null,
          items: dropDownItems,
          onChanged: (value) {
            setState(() {
              selectedState = value;
              updateUI();
            });
          });
    }
    else
      {
        return DropdownButton<String>(
          hint: Text(
            "Connection Error",
            style: kDropDownSelected,
          ),
          onChanged: null,
          items: [],
        );
      }
  }

  void updateUI() {


  if(covidData!=null) {


    active = covidData["state_wise"][selectedState]["active"];
    confirmed = covidData["state_wise"][selectedState]["confirmed"];
    deaths = covidData["state_wise"][selectedState]["deaths"];
    recovered = covidData["state_wise"][selectedState]["recovered"];
    lastUpdated = covidData["state_wise"][selectedState]["lastupdatedtime"];
    deltaconfirmed=covidData["state_wise"][selectedState]["deltaconfirmed"];
    deltadeaths=covidData["state_wise"][selectedState]["deltadeaths"];
    deltarecovered=covidData["state_wise"][selectedState]["deltarecovered"];
    //FOR DISTRICT TABLE
    Map<String,String> temp={};
    covidData["state_wise"][selectedState]["district"].forEach((district,v){

      temp[district] = v["active"].toString();

    });

    List mapKeys = temp.keys.toList(growable : false);
    mapKeys.sort((k1, k2) => int.parse(temp[k2]).compareTo(int.parse(temp[k1])));
    LinkedHashMap sortedMap = new LinkedHashMap();
    mapKeys.forEach((k1) { sortedMap[k1] = temp[k1];});

    getTableData(sortedMap);


  }
  else
    {
      active = "-";
      confirmed = "-";
      deaths = "-";
      recovered = "-";
      deltaconfirmed="-";
      deltadeaths="-";
      deltarecovered="-";
      lastUpdated ="-";
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Stack(
          children: [
            // CONTAINERS IN BACKGROUND
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: 35.0, left: 15.0, right: 0, bottom: 30.0),
                  height: MediaQuery.of(context).size.height * .35,
                  color: Color(0xFF212b46),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right:8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Covid-19 Tracker",
                              style: kstyle2,
                            ),
                            FlatButton(

                              color: Colors.pink,
                              onPressed: (){
                                Navigator.of(context).push(new PageRouteBuilder(
                                    maintainState: true,
                                    opaque: true,
                                    pageBuilder: (context, _, __) => new IndiaScreen(data: covidData,statesList: statesList,),
                                    transitionDuration: const Duration(milliseconds: 2000),
                                    transitionsBuilder: (context, anim1, anim2, child) {
                                      return new FadeTransition(
                                        child: child,
                                        opacity: anim1,
                                      );
                                    }));
                              },
                              child: Text("-> INDIA STATS",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        child: androidDropDown(),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        "Last Updated - ${lastUpdated}",
                        style: kstyle2,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .65,
                  color: Colors.white,
                )
              ],
            ),


            //CONTAINER FOR ALL CARDS ABOVE BACKGROUND
            Container(

              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .28,
                  right: 10.0,
                  left: 10.0),
              child: Column(
              children: [
                Container(        //CONTAINER FOR CARDS
                  padding: EdgeInsets.symmetric(horizontal: 20),

                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .40,
                          height: MediaQuery.of(context).size.height * 0.20,
                        child: DataCard(type: confirmed, textString: "CONFIRMED",textStyle: kInBoxNumberConfirmed,deltaString: deltaconfirmed,)
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .40,
                          height: MediaQuery.of(context).size.height * 0.20,
                        child: DataCard(type: active, textString: "ACTIVE",textStyle: kInBoxNumberActive,)
                      ),
                    ],
                  ),
                ),
                Container(    //CONTAINER FOR CARDS
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),

                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .40,
                        height: MediaQuery.of(context).size.height * 0.20,
                        child: DataCard(type: recovered, textString: "RECOVERED",textStyle: kInBoxNumberRecovered,deltaString: deltarecovered,)
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .40,
                          height: MediaQuery.of(context).size.height * 0.20,
                        child: DataCard(type: deaths, textString: "DEATHS",textStyle: kInBoxNumberDeaths,deltaString: deltadeaths,)
                      ),
                    ],
                  ),
                ),
                Text("Top 10 Districts as per Active cases: \n (may not be up-to-date for all states)",textAlign: TextAlign.center,style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                )),
                SizedBox(height: 18,),

                Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder(bottom: BorderSide.none,left: BorderSide.none,right: BorderSide.none,top:BorderSide.none),
                  // textDirection: TextDirection.rtl,
                  // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                  children: districtTableRows.take(10).toList(),
                ),
                  ),

              ],
                ),
            )
          ],
        ),
    ]
      ),
    );
  }
}




class DataCard extends StatelessWidget {
  const DataCard({
    @required this.type,
    @required this.textString,
    this.deltaString,
    @required this.textStyle,
  });

  final String type;
  final String textString;
  final TextStyle textStyle;
  final String deltaString;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Text(
                textString,
                textAlign: TextAlign.left,
                style: kInBoxHeading,
              ),
            ),
            Text(
              type,
              style:textStyle,
            ),
            deltaString!=null?Text(
              "+ $deltaString",
              style: textString=="DEATHS"?kInBoxNumberDeltaDeaths:textString=="CONFIRMED"?kInBoxNumberDeltaConfirmed:kInBoxNumberDeltaRecovered,
            ):
                Text("",style: kInBoxNumberDeltaRecovered)
          ],
        ),
      ),
      color: Colors.white,
      elevation: 15.0,
    );
  }
}


