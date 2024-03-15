export 'src/embedded/controller.dart';
export 'src/embedded/view.dart';
export 'src/flutter_mapbox_navigation.dart';
export 'src/models/models.dart';

// TODO
// 1. Add support for free styling of drawn route
// 2. Difference between build and draw route function 
//    build is for navigation, draw is for preview
// 3. If the user has more than three waypoints, give user the option, to enable
//    drivingWithTraffic, but only for the next two destinations 
//    AND an automated navigation update after every finished leg, to always 
//    have at least the next two destinations in the route navigated with 
//    traffic details
// 4. Give possibility to update the route with new waypoints, while navigating
// 5. Give possibility to set the position of the policy items of Mapbox
