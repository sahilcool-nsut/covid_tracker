import 'package:covid_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'dart:collection';
import 'dart:math';

class IndiaScreen extends StatefulWidget {

  IndiaScreen({this.data,this.statesList});
  var data;
  var statesList;

  @override
  _IndiaScreenState createState() => _IndiaScreenState();
}

class _IndiaScreenState extends State<IndiaScreen> {

  List stateModels=[];
  var covidData;
  var statesList;

  String indiaConfirmed;
  String indiaActive;
  String indiaRecovered;
  String indiaDeaths;

  @override
  void initState(){
    super.initState();

    covidData = widget.data;
    statesList = widget.statesList;
    print(covidData);
    print(statesList);
    updateUI();
  }

  void updateUI(){
    if(covidData!=null) {
      indiaConfirmed = covidData["total_values"]["confirmed"];
      indiaActive = covidData["total_values"]["active"];
      indiaRecovered = covidData["total_values"]["recovered"];
      indiaDeaths = covidData["total_values"]["deaths"];

      Map<String, String> temp = {};
      for (String state in statesList) {
        temp[state] = covidData["state_wise"][state]["active"];
      }


      List mapKeys = temp.keys.toList(growable: false);
      mapKeys.sort((k1, k2) =>
          int.parse(temp[k2]).compareTo(int.parse(temp[k1])));
      LinkedHashMap sortedMap = new LinkedHashMap();
      mapKeys.forEach((k1) {
        sortedMap[k1] = temp[k1];
      });
      print(sortedMap);


      double max = double.parse(temp[mapKeys[0]]);
      double min = double.parse(temp[mapKeys.last]);


      for (String state in statesList) {
        stateModels.add(Model(
            state,
            Color(0xFFFF0000).withOpacity(
                double.parse(covidData["state_wise"][state]["active"]) /
                    (max - min) > 0.1
                    ? double.parse(covidData["state_wise"][state]["active"]) /
                    (max - min)
                    : 0.1),
            state)
        );
        print(double.parse(covidData["state_wise"][state]["active"]) /
            (max - min));
        print(state);
      }
    }
    else
      {
        indiaConfirmed = "-";
        indiaActive ="-";
        indiaRecovered = "-";
        indiaDeaths ="-";
      }

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  ListView(
          children:[
            Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child:BackButton(
                  //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //padding: EdgeInsets.all(0),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  //child: Icon(
                 //   Icons.arrow_back,
                  //),
                ),
              ),
              Container(
                child: Center(
                  child: covidData!=null? Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    margin: EdgeInsets.all(0),
                    child: SfMaps(
                      title: const MapTitle(text: 'Density Map - India',textStyle: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      )),
                      layers: <MapLayer>[
                        MapShapeLayer(
                          delegate: MapShapeLayerDelegate(
                            shapeFile: 'assets/indian_states.json',
                            shapeDataField: 'NAME_1',
                            dataCount: stateModels.length,
                            primaryValueMapper: (int index) => stateModels[index].state,
                            dataLabelMapper: null,//(int index) => stateModels[index].stateCode,
                            shapeColorValueMapper: (int index) => stateModels[index].color,
                            shapeTooltipTextMapper: (int index) => stateModels[index].stateCode,
                          ),
                          showDataLabels: false,

                          enableShapeTooltip: true,
                          tooltipSettings: MapTooltipSettings(color: Colors.grey[700],
                              strokeColor: Colors.white, strokeWidth: 2
                          ),
                          strokeColor: Colors.white,
                          strokeWidth: 0.5,
                          dataLabelSettings: MapDataLabelSettings(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .caption
                                      .fontSize)),
                          loadingBuilder: (BuildContext context) {
                            return Container(
                              height: 25,
                              width: 25,
                              child: const CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            );
                          },
                        ),

                      ],
                    ),
                  ):Text("Connection Error"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Card(
                  elevation: 15.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom:8.0),
                          child: Text(
                            "India",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Confirmed",style: kstyle2,),
                              Text("Active",style: kstyle2,),
                              Text(" "),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(indiaConfirmed,style: kInBoxNumberConfirmed,),
                              Text(indiaActive,style: kInBoxNumberActive,),
                              Text(" "),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Recovered",style: kstyle2,),
                              Text("Deaths",style: kstyle2,),
                              Text(" "),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(indiaRecovered,style: kInBoxNumberRecovered,),
                              Text(indiaDeaths,style: kInBoxNumberDeaths),
                              Text(" "),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),]
        ),
        ),
    );
  }
}


class Model {
  Model(this.state, this.color, this.stateCode);

  String state;
  Color color;
  String stateCode;
}