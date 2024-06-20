import 'package:flutter/material.dart';

class CircularProcessLoader extends StatelessWidget {
  const CircularProcessLoader({
    super.key,
    this.color,
    this.size,
    this.height,
    this.width,
  });
  final Color? color;
  final double? size;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height ?? 30.0,
                width: width ?? 30.0,
                child: CircularProgressIndicator(
                  strokeWidth: size ?? 4,
                  valueColor: AlwaysStoppedAnimation(
                    color ?? Colors.white,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
