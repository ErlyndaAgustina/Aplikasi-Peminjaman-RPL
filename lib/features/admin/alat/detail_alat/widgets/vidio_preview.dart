import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewWidget extends StatefulWidget {
  final String url;
  const VideoPreviewWidget({super.key, required this.url});

  @override
  State<VideoPreviewWidget> createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends State<VideoPreviewWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        // Biar enak dilihat, kita atur pas inisialisasi selesai
        setState(() {}); 
        
        // --- TAMBAHKAN INI ---
        _controller.play(); // Putar otomatis
        _controller.setLooping(true); // Ulang terus videonya
        _controller.setVolume(0); // Mute suara biar nggak mengganggu saat scrolling list
      });
  }

  @override
  void dispose() {
    // Penting: Hentikan video dulu baru dispose biar gak memory leak
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: _controller.value.isInitialized
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox.expand( // Pastikan video memenuhi area 60x60
                child: FittedBox(
                  fit: BoxFit.cover, // Video akan dipotong biar memenuhi kotak tanpa distorsi
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            )
          : const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
              ),
            ),
    );
  }
}