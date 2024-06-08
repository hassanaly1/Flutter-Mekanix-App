import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/helpers/custom_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContainerHeading extends StatelessWidget {
  final String heading;
  final VoidCallback? onPressed;
  final VoidCallback? onDelete;

  const ContainerHeading({
    super.key,
    required this.heading,
    required this.onPressed,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const IconButton(
            onPressed: null,
            icon: Icon(FontAwesomeIcons.circlePlus, color: Colors.transparent),
          ),
          CustomTextWidget(
            text: heading,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: onPressed,
                icon: const Icon(FontAwesomeIcons.circlePlus,
                    color: Colors.black54),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: onDelete,
                icon: const Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
