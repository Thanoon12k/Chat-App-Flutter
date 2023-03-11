// import 'package:flutter/material.dart';

// class MyDatePicker extends StatelessWidget {
//    MyDatePicker({Key? key}) : super(key: key);
//   var _date;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
         
//              DatePicker.showDatePicker(context,
//                   theme: DatePickerTheme(
//                     containerHeight: 210.0,
//                   ),
//                   showTitleActions: true,
//                   minTime: DateTime(2000, 1, 1),
//                   maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
//                 print('confirm $date');
//                 _date = '${date.year} - ${date.month} - ${date.day}';
//               }, currentTime: DateTime.now(), locale: LocaleType.en);
//             },
//             child: Container(
//               alignment: Alignment.center,
//               height: 50.0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       Container(
//                         child: Row(
//                           children: <Widget>[
//                             Icon(
//                               Icons.date_range,
//                               size: 18.0,
//                               color: Colors.teal,
//                             ),
//                             Text(
//                               " $_date",
//                               style: TextStyle(
//                                   color: Colors.teal,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18.0),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                   Text(
//                     "  Change",
//                     style: TextStyle(
//                         color: Colors.teal,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.0),
//                   ),
//                 ],
//               ),
//             ),
//             color: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }
// }
