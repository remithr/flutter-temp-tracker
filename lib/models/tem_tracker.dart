import 'package:firebase_database/firebase_database.dart';

class TempratureInput {
  String key;
  DateTime dateTime;
  double temprature;
  String note;

  TempratureInput(this.dateTime, this.temprature, this.note);

  TempratureInput.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        dateTime =
            new DateTime.fromMillisecondsSinceEpoch(snapshot.value["date"]),
        temprature = snapshot.value["temprature"].toDouble(),
        note = snapshot.value["note"];

  toJson() {
    return {
      "temprature": temprature,
      "date": dateTime.millisecondsSinceEpoch,
      "note": note
    };
  }

  delete() {}
}
