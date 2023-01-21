import 'package:flutter/material.dart';

/// Creates a button with slanted/chamfered edges and a glow effect
class SlantButton extends StatelessWidget {
  const SlantButton({
    Key? key,
    required this.text,
    required this.colour,
    required this.onPressed,
    this.width = 240, // Default value
    this.height
  }) : super(key: key);

  final Text text;
  final Color colour;
  final void Function() onPressed;
  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: ClipShadowPath(
          clipper: HardEdges(),
          shadow: Shadow(
            color: colour,
            blurRadius: 10,
          ),
          child: MaterialButton(
            color: colour,
            onPressed: onPressed,
            child: text,
          ),
        ),
      ),
    );
  }
}

@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  const ClipShadowPath({
    Key? key,
    required this.shadow,
    required this.clipper,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: UniqueKey(),
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(clipper: clipper, child: child),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class HardEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.height / 2, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width - size.height / 2, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height / 2)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
