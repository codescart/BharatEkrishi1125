import 'package:flutter/material.dart';

class MarqueeText extends StatefulWidget {
  final String massage;
  MarqueeText(this.massage);

  @override
  _MarqueeTextState createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        _animationController.forward();
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return ClipRect(
          child: Align(
            alignment: Alignment.center,
            widthFactor: 1.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FractionalTranslation(
                translation: _animation.value,
                child: Text(
                  widget.massage=='null'?'':widget.massage.toString(),
                  style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
