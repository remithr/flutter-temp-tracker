import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tem_tracker.dart';

class TempListItem extends StatelessWidget {
  final TempratureInput tempSave;
  final double tempDifference;

  TempListItem(this.tempSave, this.tempDifference);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  DateFormat.yMMMMd().format(tempSave.dateTime),
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.left,
                ),
                Text(
                  DateFormat.EEEE().format(tempSave.dateTime),
                  textScaleFactor: 0.8,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  tempSave.note,
                  textScaleFactor: 0.9,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          Expanded(
            child: Text(
              tempSave.temprature.toString(),
              textScaleFactor: 2.1,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              tempDifference.toStringAsPrecision(3),
              textScaleFactor: 1.6,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
