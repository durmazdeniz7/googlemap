import 'package:flutter/material.dart';

class MapButton extends StatelessWidget {
  const MapButton({
    Key? key,
    this.onTap,
    required this.icon,
  }) : super(key: key);
  final void Function()? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(icon),
      ),
    );
  }
}
