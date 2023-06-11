import 'package:flutter/material.dart';

class BottomSpace extends StatefulWidget {
  const BottomSpace({Key? key}) : super(key: key);

  @override
  State<BottomSpace> createState() => _BottomSpaceState();
}

class _BottomSpaceState extends State<BottomSpace> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 10);
  }
}
