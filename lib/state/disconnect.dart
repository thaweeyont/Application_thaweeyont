// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:developer' as developer;

// class DisConect extends StatefulWidget {
//   const DisConect({Key? key}) : super(key: key);

//   @override
//   State<DisConect> createState() => _DisConectState();
// }

// class _DisConectState extends State<DisConect> {
//   ConnectivityResult connectionStatus = ConnectivityResult.none;
//   final Connectivity connectivity = Connectivity();
//   late StreamSubscription<ConnectivityResult> connectivitySubscription;
//   bool statusConn = true;

//   @override
//   void initState() {
//     super.initState();
//     initConnectivity();
//     // connectivitySubscription =
//     //     connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//   }

//   Future<void> initConnectivity() async {
//     late ConnectivityResult result;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       // result = await connectivity.checkConnectivity();
//     } on PlatformException catch (e) {
//       developer.log('Couldn\'t check connectivity status', error: e);
//       // print(e.toString());
//       return;
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) {
//       return Future.value(null);
//     }

//     // return _updateConnectionStatus(result);
//   }

//   Future<void> _updateConnectionStatus(ConnectivityResult result) async {
//     if (result == ConnectivityResult.none) {
//       setState(() {
//         statusConn = false;
//       });
//     } else {
//       setState(() {
//         statusConn = true;
//       });
//     }
//     setState(() {
//       connectionStatus = result;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double size = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           Positioned(
//             left: 0.0,
//             right: 0.0,
//             height: size * 0.07,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               color: Colors.red[400],
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "OFFLINE",
//                     style: TextStyle(
//                       fontFamily: 'Prompt',
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(width: 8.0),
//                   SizedBox(
//                     width: 12.0,
//                     height: size * 0.03,
//                     child: const CircularProgressIndicator(
//                       strokeWidth: 2.0,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.wifi_off,
//                   color: Colors.grey[400],
//                 ),
//                 Text(
//                   "ไม่มีการเชื่อมต่ออินเตอร์เน็ต",
//                   style: TextStyle(
//                       fontFamily: 'Prompt',
//                       color: Colors.grey[400],
//                       fontSize: 17),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
