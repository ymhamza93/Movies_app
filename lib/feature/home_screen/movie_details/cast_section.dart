import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/color_manager.dart';

class CastSection extends StatelessWidget {
  final List cast;

  const CastSection({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast',
          style: TextStyle(
            color: ColorManager.white,
            fontSize: MediaQuery.of(context).size.width * .055,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * .015),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cast.length,
          itemBuilder: (context, index) {
            final imageUrl = cast[index]['url_small_image'];
            return Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * .025),
              decoration: BoxDecoration(
                color: const Color(0xff282A28),
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * .035,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * .025,
                    ),
                    child: imageUrl == null || imageUrl.toString().isEmpty
                        ? Icon(
                            Icons.person,

                            color: ColorManager.white,

                            size: MediaQuery.of(context).size.width * .12,
                          )
                        : Image.network(
                            imageUrl,

                            width: MediaQuery.of(context).size.width * .18,

                            height: MediaQuery.of(context).size.width * .18,

                            fit: BoxFit.cover,
                          ),
                  ),

                  SizedBox(width: MediaQuery.of(context).size.width * .035),

                  Expanded(
                    child: Text(
                      cast[index]['name'] ?? '',
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: MediaQuery.of(context).size.width * .04,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: MediaQuery.of(context).size.height * .012);
          },
        ),
      ],
    );
  }
}
