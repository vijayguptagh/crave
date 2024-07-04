import 'package:flutter/material.dart';

import '../models/guide_model.dart';



class DetailNews extends StatelessWidget {
  const DetailNews({super.key, required this.news});

  final Yournews news;

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
                  "${news.date}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  news.newsTitle,
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
                      image: DecorationImage(
                        image: AssetImage(news.newsImage),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                ),
                const SizedBox(
                  height: 15,
                ),
                // paceBetweenText(news.description),
                Text(
                  news.description,
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

    );
  }
}