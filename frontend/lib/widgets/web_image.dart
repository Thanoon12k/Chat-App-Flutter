// import 'dart:html';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(()=>ImageController());
//     return const MaterialApp(
//       // Hide the debug banner
//       debugShowCheckedModeBanner: false,
//       title: 'Image upload',
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   File? _image;
//   PickedFile? _pickedFile;
//   final _picker = ImagePicker();
//   // Implementing the image picker
//   Future<void> _pickImage() async {
//    _pickedFile=
//     await _picker.getImage(source: ImageSource.gallery);
//     if (_pickedFile != null) {
//       setState(() {
//         _image = File(_pickedFile!.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Image upload'),
//         ),
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(35),
//             child: Column(children: [
//               Center(
//                 child: GestureDetector(
//                   child: const Text('Select An Image'),
//                   //onPressed: _openImagePicker,
//                   //onTap:()=> Get.find<ImageController>().pickImage(),
//                   onTap: ()=>_pickImage(),
//                 ),
//               ),
//               const SizedBox(height: 35),
//                Container(
//                   alignment: Alignment.center,
//                   width: double.infinity,
//                   height: 200,
//                   color: Colors.grey[300],
//                   child: _pickedFile != null
//                       ? Image.file(
//                     File(_pickedFile!
//                         .path), width: 100, height: 100, fit: BoxFit.cover,
//                   )
//                       : const Text('Please select an image'),
//                 )
//             ]),
//           ),
//         ));
//   }
// }