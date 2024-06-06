// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class MyResponsiveScreen extends StatefulWidget {
//   const MyResponsiveScreen({super.key, required this.screen});
//   final Widget screen;
//   static const double myMaxWidth = 750, myMaxHeight = 500;
//
//   @override
//   State<MyResponsiveScreen> createState() => _MyResponsiveScreenState();
// }
//
// class _MyResponsiveScreenState extends State<MyResponsiveScreen> {
//   final double _myResponsiveWidth = 350, _myResponsiveHeight = 500;
//   final ScrollController _horizontalController = ScrollController();
//   final ScrollController _verticalController = ScrollController();
//
//   @override
//   Widget build(BuildContext context) {
//     return (context.width >= _myResponsiveWidth &&
//             context.height >= _myResponsiveHeight)
//         ? widget.screen
//         : (context.width < _myResponsiveWidth &&
//                 context.height < _myResponsiveHeight)
//             ? Scrollbar(
//                 interactive: true,
//                 controller: _horizontalController,
//                 child: SingleChildScrollView(
//                   controller: _horizontalController,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       Scrollbar(
//                         interactive: true,
//                         controller: _verticalController,
//                         child: SingleChildScrollView(
//                           controller: _verticalController,
//                           physics: const AlwaysScrollableScrollPhysics(),
//                           scrollDirection: Axis.vertical,
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 width: _myResponsiveWidth,
//                                 height: _myResponsiveHeight,
//                                 child: widget.screen,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             : (context.width < _myResponsiveWidth)
//                 ? Scrollbar(
//                     interactive: true,
//                     controller: _horizontalController,
//                     child: SingleChildScrollView(
//                       controller: _horizontalController,
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       scrollDirection: Axis.horizontal,
//                       child: SizedBox(
//                         width: _myResponsiveWidth,
//                         child: widget.screen,
//                       ),
//                     ),
//                   )
//                 : Scrollbar(
//                     interactive: true,
//                     controller: _verticalController,
//                     child: SingleChildScrollView(
//                       controller: _verticalController,
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       scrollDirection: Axis.vertical,
//                       child: SizedBox(
//                         height: _myResponsiveHeight,
//                         child: widget.screen,
//                       ),
//                     ),
//                   );
//   }
// }
