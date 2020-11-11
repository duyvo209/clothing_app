import 'package:duyvo/pages/DetailPage.dart';
import 'package:flutter/material.dart';

class RadioSize extends StatefulWidget {
  final SizeType value;
  final SizeType groupValue;
  final Function(SizeType) onChanged;

  const RadioSize(
      {Key key,
      @required this.value,
      @required this.groupValue,
      @required this.onChanged})
      : super(key: key);
  @override
  _RadioSizeState createState() => _RadioSizeState();
}

class _RadioSizeState extends State<RadioSize> {
  @override
  Widget build(BuildContext context) {
    String label;
    bool isSelected = widget.value == widget.groupValue;
    switch (widget.value) {
      case SizeType.S:
        label = 'S';
        break;
      case SizeType.M:
        label = 'M';
        break;
      case SizeType.L:
        label = 'L';
        break;
    }
    return GestureDetector(
      onTap: () {
        widget.onChanged(widget.value);
      },
      child: Container(
        child: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[200],
          // border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
