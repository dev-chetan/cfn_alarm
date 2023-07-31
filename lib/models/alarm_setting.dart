import 'dart:convert';

import '../app_enums.dart';

AlarmSetting alarmSettingFromJson(String str) =>
    AlarmSetting.fromJson(json.decode(str));

String alarmSettingToJson(AlarmSetting data) => json.encode(data.toJson());

class AlarmSetting {
  int? id;
  String? dateTime;
  String? audioPath;
  bool? loopAudio;
  bool? vibrate;
  String? title;
  String? body;
  String? subTitle;
  bool? barrierDismissible;
  AudioType? audioType;
  String? filePath;

  AlarmSetting(
      {required this.id,
      required this.dateTime,
      required this.audioPath,
      required this.title,
      required this.body,
      required this.audioType,
      this.loopAudio = true,
      this.vibrate = true,
      this.subTitle = "",
      this.filePath = "",
      this.barrierDismissible = true});

  AlarmSetting.fromJson(dynamic json) {
    id = json['id'];
    dateTime = json['dateTime'];
    audioPath = json['audioPath'];
    loopAudio = json['loopAudio'];
    title = json['title'];
    body = json['body'];
    subTitle = json['subTitle'];
    barrierDismissible = json['barrierDismissible'];
    audioType = json['audioType'];
    filePath = json['filePath'];
  }

  toJson() {
    var data = {
      "id": id,
      "dateTime": dateTime,
      "loopAudio": loopAudio,
      "vibrate": vibrate,
      "title": title,
      "subTitle": subTitle,
      "body": body,
      "filePath": filePath,
      "audioType": audioType!.name,
      "audioPath": audioPath,
      "barrierDismissible": barrierDismissible
    };
    return data;
  }
}
