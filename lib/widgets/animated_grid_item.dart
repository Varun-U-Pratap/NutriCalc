import 'package:flutter/material.dart';

class AnimatedGridItem extends StatefulWidget {
  final Widget child;
  final int index;

  const AnimatedGridItem({super.key, required this.child, required this.index});

  @override
  State<AnimatedGridItem> createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<AnimatedGridItem> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    // Trigger the animation after a short delay based on the item's index
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        setState(() {
          _animate = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _animate ? 1 : 0,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _animate ? 0 : 50, 0),
        child: widget.child,
      ),
    );
  }
}
