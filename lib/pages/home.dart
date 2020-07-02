import 'package:flutter/material.dart';
// import 'dart:math';
import 'package:temptracker/models/tem_tracker.dart';
import 'package:firebase_database/firebase_database.dart';
import './temp_list.dart';
import 'add_edit.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// FIREBASE DB REFERENCE
final mainReference = FirebaseDatabase.instance.reference();

class _MyHomePageState extends State<MyHomePage> {
  List<TempratureInput> tempInput = new List();
  ScrollController _listViewScrollController = new ScrollController();
  // double _itemExtent = 50.0;

  _MyHomePageState() {
    mainReference.onChildAdded.listen(_onEntryAdded);
    mainReference.onChildChanged.listen(_onEntryEdited);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Temprature Tracker'),
      ),
      body: new ListView.builder(
        shrinkWrap: true,
        reverse: true,
        controller: _listViewScrollController,
        itemCount: tempInput.length,
        itemBuilder: (buildContext, index) {
          double difference = index == 0
              ? 0.0
              : tempInput[index].temprature - tempInput[index - 1].temprature;
          return new InkWell(
            onTap: () => _openEditEntryDialog(tempInput[index]),
            child: new TempListItem(tempInput[index], difference),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddEntryDialog,
        tooltip: 'Add new temptaure entry',
        child: Icon(Icons.add),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // CHECK FOR NEW ENTRY ADDED // FIREBASE LIST REFRESH
  _onEntryAdded(Event event) {
    // debugPrint('new entry added 36');
    // print('new entry added');
    setState(() {
      tempInput.add(new TempratureInput.fromSnapshot(event.snapshot));
    });
  }

  // REFRESH LIST AFTER EDITING
  _onEntryEdited(Event event) {
    var oldValue =
        tempInput.singleWhere((entry) => entry.key == event.snapshot.key);
    setState(() {
      tempInput[tempInput.indexOf(oldValue)] =
          new TempratureInput.fromSnapshot(event.snapshot);
      tempInput.sort((we1, we2) => we1.dateTime.compareTo(we2.dateTime));
    });
  }

  // ADD NEW TEMPRATURE ENTRY
  Future _openAddEntryDialog() async {
    debugPrint('_openAddEntryDialog called');
    TempratureInput save =
        await Navigator.of(context).push(new MaterialPageRoute<TempratureInput>(
            builder: (BuildContext context) {
              return new AddEntryDialog.add(
                  tempInput.isNotEmpty ? tempInput.last.temprature : 35);
            },
            fullscreenDialog: true));
    if (save != null) {
      // _addTemprature(save);
      // Add data to firebase real time database
      mainReference.push().set(save.toJson());
    } else {
      debugPrint('82 null save >> $save');
    }
  }

  //  EDIT TEMPRATURE ENTRY
  _openEditEntryDialog(TempratureInput tinp) {
    Navigator.of(context)
        .push(
      new MaterialPageRoute<TempratureInput>(
        builder: (BuildContext context) {
          return new AddEntryDialog.edit(tinp);
        },
        fullscreenDialog: true,
      ),
    )
        .then((TempratureInput editEntry) {
      if (editEntry != null) {
        mainReference.child(tinp.key).set(editEntry.toJson());
      }
    });
  }
}
