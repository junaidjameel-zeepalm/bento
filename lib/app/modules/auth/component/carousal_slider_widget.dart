import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;
  final List<String> imageList = [
    'https://images.pexels.com/photos/28410256/pexels-photo-28410256/free-photo-of-ordu.jpeg?auto=compress&cs=tinysrgb&w=400&lazy=load',
    'https://images.pexels.com/photos/14987621/pexels-photo-14987621/free-photo-of-cars-on-street-intersection.jpeg?auto=compress&cs=tinysrgb&w=400&lazy=load',
    'https://images.pexels.com/photos/28410256/pexels-photo-28410256/free-photo-of-ordu.jpeg?auto=compress&cs=tinysrgb&w=400&lazy=load',
  ];

  final List<String> titles = [
    'Welcome to Bento',
    'Create your Dragable\nLinks',
    'Join Our Community',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider.builder(
            itemCount: imageList.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(imageList[index]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      titles[index],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.kanit(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imageList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _currentIndex = entry.key,
                          child: Container(
                            width: _currentIndex == entry.key ? 40.0 : 40.0,
                            height: _currentIndex == entry.key ? 7.0 : 6.0,
                            margin: const EdgeInsets.symmetric(
                              vertical: .0,
                              horizontal: 4.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: _currentIndex == entry.key
                                  ? Colors.redAccent
                                  : Colors.grey,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
