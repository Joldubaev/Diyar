import 'package:flutter/material.dart';

class LineOrWidget extends StatelessWidget {
  const LineOrWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: const Divider(
                thickness: 2,
                color: Colors.grey,
              )),
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: const Text(
                'OR',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          )
        ],
      ),
    );
  }
}
