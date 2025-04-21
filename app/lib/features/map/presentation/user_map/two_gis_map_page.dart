// import 'package:auto_route/auto_route.dart';
// import 'package:dgis_mobile_sdk_full/dgis.dart' as sdk;
// import 'package:flutter/material.dart';

// @RoutePage()
// class TwoGisMapPage extends StatefulWidget {
//   const TwoGisMapPage({super.key});

//   @override
//   State<TwoGisMapPage> createState() => _TwoGisMapPageState();
// }

// class _TwoGisMapPageState extends State<TwoGisMapPage> {
//   final sdkContext = sdk.DGis.initialize();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('2GIS Map'),
//       ),
//       body: sdk.MapWidget(
//         sdkContext: sdkContext,
//         mapOptions: sdk.MapOptions(),
//       ),
//     );
//   }
// }
