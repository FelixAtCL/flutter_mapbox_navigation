import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_mapbox_navigation/mapbox_navigation_flutter.dart';

class SampleNavigationApp extends StatefulWidget {
  const SampleNavigationApp({super.key});

  @override
  State<SampleNavigationApp> createState() => _SampleNavigationAppState();
}

class _SampleNavigationAppState extends State<SampleNavigationApp> {
  final List<String> _loadedImgs = [];
  String? _platformVersion;
  String? _instruction;
  final _origin = WayPoint(
      name: "Way Point 1",
      latitude: 38.9111117447887,
      longitude: -77.04012393951416,
      isSilent: false);
  final _stop1 = WayPoint(
      name: "Way Point 2",
      latitude: 38.91113678979344,
      longitude: -77.03847169876099,
      isSilent: false);
  final _stop2 = WayPoint(
      name: "Way Point 3",
      latitude: 38.91040213277608,
      longitude: -77.03848242759705,
      isSilent: false);
  final _stop3 = WayPoint(
      name: "Way Point 4",
      latitude: 38.909650771013034,
      longitude: -77.03850388526917,
      isSilent: false);
  final _destination = WayPoint(
      name: "Way Point 5",
      latitude: 38.90894949285854,
      longitude: -77.03651905059814,
      isSilent: false);

  final _home = WayPoint(
      name: "Home",
      latitude: 37.77440680146262,
      longitude: -122.43539772352648,
      isSilent: false);

  final _store = WayPoint(
      name: "Store",
      latitude: 37.76556957793795,
      longitude: -122.42409811526268,
      isSilent: false);

  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController? _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _inFreeDrive = false;
  late MapBoxOptions _navigationOption;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _controller?.gesture.removeListenerOnMapTap();
    _controller?.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.simulateRoute = true;
    _navigationOption.language = "en";
    _navigationOption.isBottomBarDisabled = false;
    _navigationOption.isTopBarDisabled = false;

    //_navigationOption.initialLatitude = 36.1175275;
    //_navigationOption.initialLongitude = -115.1839524;
    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);

    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MapBoxNavigation.instance.getPlatformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Running on: $_platformVersion\n'),
                    Container(
                      color: Colors.grey,
                      width: double.infinity,
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: (Text(
                          "Embedded Navigation",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _isNavigating
                              ? null
                              : () {
                                  if (_routeBuilt) {
                                    _controller?.navigation.clear();
                                    setState(() {
                                      _routeBuilt = false;
                                      _isNavigating = false;
                                    });
                                  } else {
                                    var wayPoints = <WayPoint>[];
                                    wayPoints.add(_origin);
                                    // wayPoints.add(_stop1);
                                    // wayPoints.add(_stop2);
                                    wayPoints.add(_stop3);
                                    _isMultipleStop = wayPoints.length > 2;
                                    _controller?.navigation
                                        .addStringListener((value) {
                                      print("event: ${value}");
                                    });
                                    _controller?.navigation.build(
                                        wayPoints: wayPoints,
                                        options: _navigationOption);
                                    setState(() {
                                      _routeBuilt = true;
                                    });
                                  }
                                },
                          child: Text(_routeBuilt && !_isNavigating
                              ? "Clear Route"
                              : "Build Route"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: _routeBuilt && !_isNavigating
                              ? () {
                                  _controller?.navigation.start();
                                  setState(() {
                                    _isNavigating = true;
                                  });
                                }
                              : null,
                          child: const Text('Start '),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: _isNavigating
                              ? () {
                                  _controller?.navigation.finish();
                                  MapBoxNavigation.instance.finishNavigation();
                                  setState(() {
                                    _isNavigating = false;
                                  });
                                }
                              : null,
                          child: const Text('Cancel '),
                        )
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ElevatedButton(
                        onPressed: _inFreeDrive
                            ? null
                            : () async {
                                var uri =
                                    await _controller?.style.getStyleURI() ??
                                        "";
                                print(uri);
                                var state =
                                    await _controller?.camera.getState();
                                print(state?.encode());
                                var bounds = await _controller?.camera
                                    .getCoordinateBounds(CameraOptions(
                                        zoom: 10,
                                        center: Point(
                                            coordinates: Position(
                                          -122.4194,
                                          37.7749,
                                        )).toJson() // San Francisco
                                        ));
                                print(bounds?.encode());
                                await _loadMarker();
                              },
                        child: const Text("Test Style"),
                      ),
                      ElevatedButton(
                        onPressed: _inFreeDrive
                            ? null
                            : () async {
                                await _testSettings();
                              },
                        child: const Text("Test Settings"),
                      ),
                      ElevatedButton(
                        onPressed: _inFreeDrive
                            ? null
                            : () async {
                                _inFreeDrive =
                                    await _controller?.startFreeDrive() ??
                                        false;
                              },
                        child: const Text("Free Drive "),
                      ),
                    ]),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Long-Press Embedded Map to Set Destination",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 500,
              child: Container(
                color: Colors.grey,
                child: MapBoxNavigationView(
                    options: _navigationOption,
                    onRouteEvent: _onEmbeddedRouteEvent,
                    onCreated:
                        (MapBoxNavigationViewController controller) async {
                      _controller = controller;
                      controller.initialize();
                      _listenOnTap();
                      _listenOnCameraChange();
                    }),
              ),
            )
          ]),
        ),
      ),
    );
  }

  _listenOnTap() {
    _controller?.gesture.addListenerOnMapTap((coordinate) async {
      if (_controller == null) return;
      var conv =
          await _controller!.map.pixelForCoordinate(coordinate.x, coordinate.y);
      var features = await _controller!.map.queryRenderedFeatures(
          RenderedQueryGeometry(
              value: jsonEncode(conv.encode()), type: Type.SCREEN_COORDINATE),
          RenderedQueryOptions(layerIds: ["example-layer"]));
      print("features is empty: ${features.isEmpty}");
      if (features.isEmpty) return;
      print(features.first);
    });
  }

  // TODO: Android error on this part -> Maybe in the decoder parts?!
  _listenOnCameraChange() {
    _controller?.map.addEventListener((event) {
      print("camera changed: ${event.data}");
    }, [MapEvent.cameraChanged]);
  }

  Future _testSettings() async {
    var attributionSettings = await _controller?.attribution.getSettings();
    print("attribution settings: $attributionSettings");
    await _controller?.attribution
        .updateSettings(AttributionSettings(marginRight: 150));
    var compassSettings = await _controller?.compass.getSettings();
    print("compass settings: $compassSettings");
    await _controller?.compass
        .updateSettings(CompassSettings(marginRight: 150));
    var logoSettings = await _controller?.logo.getSettings();
    print("logo settings: $logoSettings");
    await _controller?.logo.updateSettings(LogoSettings(marginLeft: 150));
    var scaleBarSettings = await _controller?.scaleBar.getSettings();
    print("scaleBar settings: $scaleBarSettings");
    await _controller?.scaleBar
        .updateSettings(ScaleBarSettings(marginLeft: 150));
    var locationSettings = await _controller?.location.getSettings();
    print("location settings: $locationSettings");
    await _controller?.location
        .updateSettings(LocationComponentSettings(enabled: false));
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }

  Future<void> _loadMarker() async {
    var source = "example-source";
    var layer = "example-layer";
    var img = "assets/deselected.png";

    try {
      await _addImage(img: img);
    } catch (error) {
      print(error.toString());
    }

    try {
      var data = jsonEncode({
        "type": "FeatureCollection",
        "features": [],
      });

      await _addSource(id: source, data: data, isCluster: false);
    } catch (error) {
      print(error.toString());
    }

    try {
      dynamic markerProps = {
        "id": layer,
        "type": "symbol",
        "source": source,
        "filter": [
          "!",
          ["has", "point_count"]
        ],
        "layout": {
          "icon-image": img,
          "icon-size": 0.25,
          "icon-anchor":
              IconAnchor.BOTTOM.toString().split('.').last.toLowerCase(),
        }
      };

      await _addStyleLayer(
          id: layer,
          props: json.encode(markerProps),
          position: LayerPosition(at: 128));
    } catch (error) {
      print(error.toString());
    }

    try {
      var latitudes = [51.866478, 51.566478, 51.2866478, 50.966478, 50.666478];
      var longitudes = [7.369059, 7.669059, 7.969059, 8.269059, 8.569059];

      var content = _createContentFromCoordinates(latitudes, longitudes);

      var features =
          jsonEncode({"type": "FeatureCollection", "features": content});

      var sourceToUpdate =
          (await _controller?.style.getSource(source)) as GeoJsonSource;

      await sourceToUpdate.updateGeoJSON(features);

      var cameraOptions = CameraOptions(
          center:
              Point(coordinates: Position(longitudes.first, latitudes.first))
                  .toJson(),
          zoom: 12);

      await _controller?.camera
          .flyTo(cameraOptions, MapAnimationOptions(duration: 500));
    } catch (error) {
      print(error.toString());
    }
  }

  Future _addSource(
      {required String id, required String data, bool? isCluster}) async {
    var exists = await _controller?.style.styleSourceExists(id);
    print("source exists: $exists");
    if (exists == true) return;
    var source = GeoJsonSource(id: id, data: data, cluster: isCluster);
    await _controller?.style.addSource(source);
  }

  Future _addImage({required String img}) async {
    var bundle = await rootBundle.load(img);
    var image = bundle.buffer.asUint8List();
    var decodedImage = await decodeImageFromList(image);
    var id = img;

    if (_loadedImgs.contains(id)) _loadedImgs.remove(id);

    await _controller?.style.addStyleImage(
        id,
        3.0,
        MbxImage(
            width: decodedImage.width,
            height: decodedImage.height,
            data: image),
        false,
        [],
        [],
        null);

    _loadedImgs.add(id);

    return id;
  }

  Future _addStyleLayer(
      {required String id,
      required String props,
      LayerPosition? position}) async {
    var exists = await _controller?.style.styleLayerExists(id);
    print("layer exists: $exists");
    if (exists == true) return;
    await _controller?.style.addStyleLayer(props, position);
  }

  List<Map<String, dynamic>> _createContentFromCoordinates(
      List<double> latitudes, List<double> longitudes) {
    var content = <Map<String, dynamic>>[];

    if (latitudes.length != longitudes.length) throw Exception();

    for (var index = 0; index < latitudes.length; index++) {
      var lat = latitudes[index];
      var long = longitudes[index];
      content.add(_createContentFromCoordinate(lat, long));
    }

    return content;
  }

  Map<String, dynamic> _createContentFromCoordinate(double lat, double long) =>
      {
        "type": "Feature",
        "properties": {
          "id": "example-id",
          "type": "example-marker",
        },
        "geometry": {
          "type": "Point",
          "coordinates": [long, lat]
        }
      };
}
