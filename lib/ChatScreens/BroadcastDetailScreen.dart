import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

class BroadcastDetailScreen extends StatefulWidget {
  final String message;
  final DateTime? timestamp;
  final String mediaUrl;
  final String mediaType;

  const BroadcastDetailScreen({
    Key? key,
    required this.message,
    required this.timestamp,
    required this.mediaUrl,
    required this.mediaType,
  }) : super(key: key);

  @override
  _BroadcastDetailScreenState createState() => _BroadcastDetailScreenState();
}

class _BroadcastDetailScreenState extends State<BroadcastDetailScreen> {
  late VideoPlayerController _videoController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isAudioPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType.startsWith('video')) {
      _videoController = VideoPlayerController.network(widget.mediaUrl)
        ..initialize().then((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    if (widget.mediaType.startsWith('video')) {
      _videoController.dispose();
    }
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = widget.timestamp != null
        ? "${widget.timestamp!.toLocal()}".split('.')[0]
        : "Unknown time";

    return Scaffold(
      appBar: AppBar(
        title: Text('Broadcast Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.campaign, size: 40, color: Colors.orange),
                SizedBox(height: 20),
                Text(
                  widget.message,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                _buildMediaPreview(widget.mediaUrl, widget.mediaType),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Sent: $formattedTime",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPreview(String mediaUrl, String mediaType) {
    if (mediaType.startsWith('image')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          mediaUrl,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) =>
          loadingProgress == null ? child : Center(child: CircularProgressIndicator()),
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.error, color: Colors.red),
        ),
      );
    } else if (mediaType.startsWith('video')) {
      return GestureDetector(
        onTap: () => _showFullVideo(context, mediaUrl),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.videocam, size: 50, color: Colors.blue),
        ),
      );
    } else if (mediaType.startsWith('audio')) {
      return GestureDetector(
        onTap: () => _toggleAudio(mediaUrl),
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isAudioPlaying ? Icons.pause : Icons.play_arrow, size: 30, color: Colors.green),
              SizedBox(width: 10),
              Text('Audio: Tap to ${isAudioPlaying ? "pause" : "play"}', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_drive_file, size: 32, color: Colors.grey),
            SizedBox(width: 10),
            Text('File: Tap to open', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }
  }

  void _showFullVideo(BuildContext context, String mediaUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: AspectRatio(
            aspectRatio: _videoController.value.aspectRatio,
            child: VideoPlayer(_videoController),
          ),
        );
      },
    );
    _videoController.play();
  }

  Future<void> _toggleAudio(String mediaUrl) async {
    try {
      if (isAudioPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(UrlSource(mediaUrl));
      }
      setState(() {
        isAudioPlaying = !isAudioPlaying;
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }
}
