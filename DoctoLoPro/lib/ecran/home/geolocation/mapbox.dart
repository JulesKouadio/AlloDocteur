import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import '../../../constant.dart';

class MapView extends StatefulWidget {
  final double destinationLatitude;
  final double destinationLongitude;
  final double currentLatitude;
  final double currentLongitude;
  const MapView({
    super.key,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.currentLatitude,
    required this.currentLongitude,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MapBoxNavigationViewController? _controller;
  String? _instruction;
  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _arrived = false;
  MapBoxOptions? _navigationOption;

  bool goValider = true;
  @override
  void initState() {
    super.initState();
    _initializeNavigation();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white));
  }

  Future<void> _initializeNavigation() async {
    if (!mounted) return;
    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption!.initialLatitude = widget.currentLatitude;
    _navigationOption!.initialLongitude = widget.currentLongitude;
    _navigationOption!.mode = MapBoxNavigationMode.driving;
    _navigationOption!.language = 'fr';
    _navigationOption!.enableRefresh = true;

    MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);
  }

  void _startNavigation() {
    var wayPoints = [
      WayPoint(
          name: "Start",
          latitude: widget.currentLatitude,
          longitude: widget.currentLongitude),
      WayPoint(
          name: "Destination",
          latitude: widget.destinationLatitude,
          longitude: widget.destinationLongitude),
    ];

    _controller?.buildRoute(
      wayPoints: wayPoints,
      options: _navigationOption,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white));
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Stack for superimposing elements
            Stack(
              children: [
                // MapBoxNavigationView in the background
                Expanded(
                  child: SizedBox(
                    height: getProportionateScreenHeight(673.5),
                    child: Container(
                        color: Colors.white,
                        child: MapBoxNavigationView(
                          options: _navigationOption!,
                          onRouteEvent: _onRouteEvent,
                          onCreated: (MapBoxNavigationViewController
                              controller) async {
                            _controller = controller;
                            controller.initialize();
                            var wayPoints = [
                              WayPoint(
                                  name: "Start",
                                  latitude: widget.currentLatitude,
                                  longitude: widget.currentLongitude),
                              WayPoint(
                                  name: "Destination",
                                  latitude: widget.destinationLatitude,
                                  longitude: widget.destinationLongitude),
                            ];
                            _controller?.buildRoute(
                              wayPoints: wayPoints,
                              options: _navigationOption,
                            );
                          },
                        )),
                  ),
                ),

                // "Let's Go" button positioned on top
                Positioned(
                  top: getProportionateScreenHeight(
                      10), // Adjust positioning as needed
                  left: getProportionateScreenHeight(
                      20), // Adjust positioning as needed
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: getProportionateScreenHeight(40),
                      width: getProportionateScreenHeight(50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: gradientStartColor,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: getProportionateScreenHeight(23),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        _arrived = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        _routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        _routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        _isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        _arrived = true;
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        }
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        _routeBuilt = false;
        _isNavigating = false;
        break;
      default:
        break;
    }
    //refresh UI
    setState(() {});
  }
}
