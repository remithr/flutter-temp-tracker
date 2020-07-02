import 'package:flutter/material.dart';
import 'package:temptracker/models/tem_tracker.dart';
// import 'dart:math';
import '../components/date_time_entry.dart';
import 'package:numberpicker/numberpicker.dart';

class AddEntryDialog extends StatefulWidget {
  final double initialTemprature;
  final TempratureInput tempToEdit;

  AddEntryDialog.add(this.initialTemprature) : tempToEdit = null;
  AddEntryDialog.edit(this.tempToEdit)
      : initialTemprature = tempToEdit.temprature;

  @override
  AddEntryDialogState createState() {
    if (tempToEdit != null) {
      return new AddEntryDialogState(
          tempToEdit.dateTime, tempToEdit.temprature, tempToEdit.note);
    } else {
      return new AddEntryDialogState(
          new DateTime.now(), initialTemprature, null);
    }
  }
}

class AddEntryDialogState extends State<AddEntryDialog> {
  DateTime _dateTime = new DateTime.now();
  double _temprature;
  String _note;
  TextEditingController _textEditingController;

  AddEntryDialogState(this._dateTime, this._temprature, this._note);

  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      title: widget.tempToEdit == null
          ? const Text('New Entry')
          : const Text('Edit Entry'),
      actions: [
        new Opacity(
          opacity: widget.tempToEdit == null ? 0.0 : 1,
          child: new FlatButton(
            onPressed: () {
              // debugPrint('$widget');
              Navigator.of(context).pop(
                new TempratureInput(_dateTime, _temprature, _note).delete(),
              );
            },
            child: Text(
              'Delete',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
        new FlatButton(
          onPressed: () {
            // debugPrint('$context');
            Navigator.of(context).pop(
              new TempratureInput(_dateTime, _temprature, _note),
            );
          },
          child: new Text(
            'Save',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = new TextEditingController(text: _note);
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _createAppBar(context),
      body: Column(
        children: [
          new ListTile(
            leading: new Icon(Icons.today, color: Colors.grey[500]),
            title: new DateTimeItem(
                dateTime: _dateTime,
                onChanged: (dateTime) {
                  setState(() {
                    debugPrint('set state called');
                    _dateTime = dateTime;
                  });
                }),
          ),
          new ListTile(
            leading: new Image.asset(
              "assets/images/scale-bathroom.png",
              color: Colors.grey[500],
              height: 24.0,
              width: 24.0,
            ),
            title: new Text(
              "$_temprature C",
            ),
            onTap: () => _showTempraturePicker(context),
          ),
          new ListTile(
            leading: new Icon(Icons.speaker_notes, color: Colors.grey[500]),
            title: new TextField(
              decoration: new InputDecoration(
                hintText: 'Optional note',
              ),
              controller: _textEditingController,
              onChanged: (value) => _note = value,
            ),
          ),
        ],
      ),
    );
  }

  _showTempraturePicker(BuildContext context) {
    showDialog(
      context: context,
      child: new NumberPickerDialog.decimal(
        minValue: 30,
        maxValue: 45,
        initialDoubleValue: _temprature,
        title: new Text("Fill in the details"),
      ),
    ).then((value) {
      if (value != null) {
        setState(() => _temprature = value);
      }
    });
  }
}
