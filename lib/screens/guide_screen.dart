import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cravecrush/models/guide_model.dart';
import 'package:cravecrush/screens/guide_detail.dart';
import 'package:cravecrush/screens/video_detail.dart';

// class DetailVideo extends StatelessWidget {
//   final String video;

//   DetailVideo({required this.video});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text('Video URL: $video'),
//     );
//   }
// }

class NewsHomePage extends StatelessWidget {
  const NewsHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text(
                      "Guide",
                      style: TextStyle(fontSize: 37, fontWeight: FontWeight.bold),
                    ),
                    forImages(context),
                    const SizedBox(
                      height: 10,
                    ),

                    // Articles Section
                    const Padding(
                      padding: EdgeInsets.only(right: 20, top: 20),
                      child: Row(
                        children: [
                          Text(
                            "Articles",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: newsItems.length,
                        itemBuilder: (context, index) {
                          final news = newsItems[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailNews(news: news)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                elevation: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 130,
                                      margin: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(news.image),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          news.newsTitle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // video Section
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Videos",
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: videoItems.length,
                              itemBuilder: (context, index) {
                                final video = videoItems[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailVideo(video: video
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      elevation: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(left: 10),
                                                height: 100,
                                                width: 130, // Adjust width as needed
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(video.image),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              const Center(
                                                child: Icon(
                                                  Icons.play_circle_fill,
                                                  size: 50,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 150, // Adjust width as needed
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Text(
                                                video.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ))));
  }

  Padding forImages(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Image.asset(
                "assets/images/1.png",
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.95,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }



}