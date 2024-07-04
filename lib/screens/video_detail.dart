import 'package:flutter/material.dart';
import 'package:cravecrush/models/guide_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailVideo extends StatelessWidget {
  const DetailVideo({Key? key, required this.video}) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Color.fromARGB(255, 73, 98, 223),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${video.date}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  video.title,
                  style: const TextStyle(
                    fontSize: 33,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: YoutubePlayer.convertUrlToId(video.videoUrl) ?? '',
                      flags: const YoutubePlayerFlags(
                        autoPlay: true,
                        mute: false,
                      ),
                    ),
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blueAccent,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.blue,
                      handleColor: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  video.summary,
                  style: const TextStyle(
                    fontSize: 21,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        height: 75,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(spreadRadius: 1, blurRadius: 2, offset: Offset(0, 3)),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDEAFF),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 13,
                    ),
                    Image.asset(
                      "assets/images/chat.png",
                      height: 45,
                    ),
                    const Text(
                      "Add a comment",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF277AFF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFFEDE3FA),
              child: Image.asset(
                "assets/images/icon.png",
                height: 32,
              ),
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFFFFF7E2),
              child: Image.asset(
                "assets/images/star.png",
                height: 32,
              ),
            ),
            const CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFFD9F9F5),
              child: Icon(
                Icons.more_vert,
                size: 35,
                color: Color(0xFF00D9BC),
              ),
            ),
            const SizedBox(
              width: 15,
            )
          ],
        ),
      ),
    );
  }
}
