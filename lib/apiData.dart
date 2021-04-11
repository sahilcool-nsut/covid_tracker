import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';

class ApiData {

  Future getData() async{
    Response response;
    try {
      response = await get(
          "https://corona-virus-world-and-india-data.p.rapidapi.com/api_india",
          headers: {
            "x-rapidapi-host": "corona-virus-world-and-india-data.p.rapidapi.com",
            "x-rapidapi-key": "1ee5ea6672msh5b64ab1bebe57bbp1dd50ajsnfaa197cd468f",
            "useQueryString": "true",
          }).timeout(
        Duration(seconds: 5),
      );
    } catch(e) {
      print(e);
      return null;
    }
      if(response.statusCode==200)
      {
        var decodedData = jsonDecode(response.body);
        return decodedData;
      }
      else
      {
        print(response.statusCode);
        return null;
      }
    }


  Future<List<String>> getStates() async {
    List<String> states=[];
    var data = await getData();
    data["state_wise"].forEach((k, v) {
      states.add(k);

    });
    return states;
  }

}
