// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
//
// class SentImagesScreen extends StatefulWidget {
//   final String receiverId;
//
//   SentImagesScreen({required this.receiverId});
//
//   @override
//   _SentImagesScreenState createState() => _SentImagesScreenState();
// }
//
// class _SentImagesScreenState extends State<SentImagesScreen> {
//   List<Map<String, dynamic>> mediaFiles = [];
//   List<Map<String, dynamic>> videoFiles = [];
//   String? selectedVideoUrl;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchMediaFiles();
//   }
//
//   Future<void> fetchMediaFiles() async {
//     try {
//       final response = await http.get(
//         Uri.parse("https://thinkproduct.thinksynq.in/whatsappint/getfiles.php"),
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data["status"] == "success") {
//           List<Map<String, dynamic>> files = List<Map<String, dynamic>>.from(data["users"]);
//
//           setState(() {
//             mediaFiles = files.where((file) => file["file_type"] == "image").toList();
//             videoFiles = files.where((file) => file["file_type"] == "video").toList();
//           });
//         }
//       }
//     } catch (e) {
//       print("🚨 Error fetching media files: $e");
//     }
//   }
//
//   void playVideo(String videoUrl) {
//     setState(() {
//       selectedVideoUrl = videoUrl;
//     });
//
//     Future.delayed(Duration(milliseconds: 200), () {
//       if (selectedVideoUrl != null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => FullScreenVideo(videoUrl: selectedVideoUrl!),
//           ),
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Media Files")),
//       body: Column(
//         children: [
//           Expanded(
//             child: mediaFiles.isEmpty
//                 ? const Center(child: Text("No images available."))
//                 : GridView.builder(
//               padding: const EdgeInsets.all(8),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 5,
//                 mainAxisSpacing: 5,
//               ),
//               itemCount: mediaFiles.length,
//               itemBuilder: (ctx, index) {
//                 String fileUrl = mediaFiles[index]["file_url"];
//
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => FullScreenImage(imageUrl: fileUrl),
//                       ),
//                     );
//                   },
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(fileUrl, fit: BoxFit.cover),
//                   ),
//                 );
//               },
//             ),
//           ),
//           if (videoFiles.isNotEmpty) ...[
//             const SizedBox(height: 10),
//             const Text("Videos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             SizedBox(
//               height: 100,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: videoFiles.length,
//                 itemBuilder: (ctx, index) {
//                   String fileUrl = videoFiles[index]["file_url"];
//
//                   return GestureDetector(
//                     onTap: () => playVideo(fileUrl),
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 5),
//                       width: 120,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.black26,
//                       ),
//                       child: const Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
//
// class FullScreenVideo extends StatefulWidget {
//   final String videoUrl;
//   FullScreenVideo({required this.videoUrl});
//
//   @override
//   _FullScreenVideoState createState() => _FullScreenVideoState();
// }
//
// class _FullScreenVideoState extends State<FullScreenVideo> {
//   late VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//   bool _isLoading = true;
//   bool _hasError = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initVideoPlayer();
//   }
//
//   void _initVideoPlayer() async {
//     try {
//       _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
//       await _videoPlayerController.initialize();
//
//       setState(() {
//         _isLoading = false;
//         _hasError = false;
//         _chewieController = ChewieController(
//           videoPlayerController: _videoPlayerController,
//           autoPlay: true,
//           looping: false,
//           showControls: true,
//           allowFullScreen: true,
//           allowMuting: true,
//         );
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (_hasError) {
//       return const Center(child: Text("🚨 Failed to load video"));
//     }
//     return Chewie(controller: _chewieController!);
//   }
// }
//
// class FullScreenImage extends StatelessWidget {
//   final String imageUrl;
//   FullScreenImage({required this.imageUrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(backgroundColor: Colors.black),
//       body: Center(
//         child: Image.network(imageUrl, fit: BoxFit.contain),
//       ),
//     );
//   }
// }
