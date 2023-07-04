import 'package:flutter/material.dart';

class SearchBarWdiget extends StatelessWidget {
  const SearchBarWdiget({
    Key? key,
    this.onPressed,
    this.onEditingComplete,
  }) : super(key: key);
  final Function()? onPressed;
  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * .75,
            child: TextField(
              onEditingComplete: onEditingComplete,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.filter_alt_outlined),
                hintText: '  Arama',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Card(
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .1,
                child: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)))),
      ],
    );
  }
}
