import 'package:flutter/material.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';

class CourseCard extends StatelessWidget {
  final Color backgroundColor;
  final Widget image;
  final double imageSize;
  final String title;
  final String subtitle;
  final String duration;
  final VoidCallback onTap;

  const CourseCard({
    Key? key,
    required this.backgroundColor,
    required this.image,
    this.imageSize = 100,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.4;
    final cardHeight = MediaQuery.of(context).size.height * 0.25;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1) Big image in the top-right
                Positioned(
                  top: -imageSize * 0.25,
                  right: -imageSize * 0.15,
                  width: imageSize,
                  height: imageSize,
                  child: image,
                ),

                // 2) The text + button
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // push title down so it doesn't overlap the image
                      SizedBox(height: imageSize * 0.4),

                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),
                      Text(
                        subtitle.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            duration,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                            ),
                            onPressed: onTap,
                            child: const Text(
                              'START',
                              style: TextStyle(color: appDarkGrey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
