import 'dart:developer';
import 'dart:async';
import 'package:brandy/res/components/components.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../res/custom_widgets/custom_button.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location services are disabled. Please enable the services',
            ),
          ),
        );
      }
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
        }
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
      }
      return false;
    }
    return true;
  }

  Future<void> openMap() async {
    String googleUrl =
        'http://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},${_currentPosition!.longitude}';
    await canLaunchUrlString(googleUrl)
        ? await launchUrlString(googleUrl)
        : throw 'Couldn\'t launch';
  }

  Future<void> _getAddressFromLatLng() async {
    await placemarkFromCoordinates(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    ).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      log(e.toString());
    });
  }

  ///
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition().then((Position position) async {
      setState(() {
        _currentPosition = position;
      });
      await openMap();
      await _getAddressFromLatLng();
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LAT: ${_currentPosition?.latitude ?? ""}'),
              Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              Text('ADDRESS: ${_currentAddress ?? ""}'),
              const SizedBox(height: 32),
              CustomButton(
                function: _getCurrentPosition,
                title: "Get Current Location",
              ),
              const SpaceHeight(),
              CustomButton(
                function: openMap,
                title: "Open map",
              ),
              const SpaceHeight(),
              CustomButton(
                function: _getAddressFromLatLng,
                title: "get address",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Completer<GoogleMapController> _controller = Completer();

  String? _currentAddress;
  Position? _currentPosition;

// on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.42796133580664, 75.885749655962),
        infoWindow: InfoWindow(
          title: 'My Position',
        )),
  ];

// created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {
      log('getUserCurrentLocation success : permission is $value');
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      log("ERROR$error");
    });
    return await Geolocator.getCurrentPosition().then((value) {
      log("${value.latitude} ${value.longitude}");
      return _currentPosition = value;
    });
  }

  Future<void> getAddressFromLatLng() async {
    await placemarkFromCoordinates(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    ).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
      log('get address success $_currentAddress');
    }).catchError((e) {
      log('err in get address $e');
    });
  }

  @override
  void dispose() {
    _controller = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text("GFG"),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomContainer(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TitleLargeText('LAT: ${_currentPosition?.latitude ?? ""}'),
                  TitleLargeText('LNG: ${_currentPosition?.longitude ?? ""}'),
                  TitleLargeText('Address: ${_currentAddress ?? ""}'),
                ],
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              // on below line setting camera position
              initialCameraPosition: LocationPage.initialCameraPosition,
              // on below line we are setting markers on the map
              markers: Set<Marker>.of(_markers),
              // on below line specifying map type.
              mapType: MapType.normal,
              // on below line setting user location enabled.
              myLocationEnabled: true,
              // on below line setting compass enabled.
              compassEnabled: true,
              // on below line specifying controller on map complete.
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      // on pressing floating action button the camera will take to user current location
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getUserCurrentLocation().then((value) async {
            // marker added for current users location
            _markers.add(Marker(
              markerId: const MarkerId("2"),
              position: LatLng(value.latitude, value.longitude),
              infoWindow: const InfoWindow(
                title: 'My Current Location',
              ),
            ));

            // specified current users location
            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 14,
            );

            final GoogleMapController controller = await _controller.future;
            await controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition))
                .then((value) {
              log(' cam success');
            }).catchError((e) {
              log('err in cam $e');
            });
            setState(() {});
          }).catchError((e) {
            log('err in floating $e');
          });
        },
        child: const Icon(Icons.local_activity),
      ),
    );
  }
}
*/
