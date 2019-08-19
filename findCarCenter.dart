import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
//import 'package:latlong/latlong.dart';
//import 'package:flutter_map/flutter_map.dart';
//import 'package:geolocation/geolocation.dart';


class FindCarCenter extends StatefulWidget {
  @override
  _FindCarCenterState createState() => _FindCarCenterState();
}

class _FindCarCenterState extends State<FindCarCenter> {
/* GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }*/

//  MapController controller = new MapController();

  /*getPermission() async {
    final GeolocationResult result =
        await Geolocation.requestLocationPermission( const LocationPermission(
          android: LocationPermissionAndroid.fine,
          ios: LocationPermissionIOS.always));
      return result;
  }

  getLocation(){
    return getPermission().then((result) async{
      if(result.isSuccessful){
        final coords = await Geolocation.currentLocation(
            accuracy: LocationAccuracy.best
        );
        return coords;
      }
    });

  }*/
/*

  buildMap(){
    getLocation().then((response){
      if(response.isSuccessful){
        response.listen((value){
          controller.move(new LatLng(value.location.latitude, value.location.longitude), 15.0);
        });
      }
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: (){

            },
          ),
          title: Text('Bereka Car Service Center'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){

              },
            )
          ],
          backgroundColor: Colors.green[700],
        ),
       /* body: new FlutterMap(
          mapController: controller,
          options: new MapOptions(center: buildMap(), minZoom: 5.0),
          layers: [
            new TileLayerOptions(
              urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}/png",
              subdomains: ['a', 'b', 'c']
            )
          ],
        ),*/
      ),
    );
  }
}


/*

GoogleMap(
onMapCreated: _onMapCreated,
initialCameraPosition: CameraPosition(
target: _center,
zoom: 11.0,
),
),*/

