import '../app_enums.dart';

class AlarmSetting {
  final int id;
  final String dateTime;
  final String audioPath;
  final bool? loopAudio;
  final bool? vibrate;
  final String title;
  final String body;
  final String? subTitle;
  final bool? barrierDismissible;
  final AudioType audioType;

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
      this.barrierDismissible = true});

  toJson() {
    var data = {
      "id": id,
      "dateTime": dateTime,
      "loopAudio": loopAudio,
      "vibrate": vibrate,
      "title": title,
      "subTitle": subTitle,
      "body": body,
      "audioType": audioType.name,
      "audioPath": audioPath,
      "barrierDismissible": barrierDismissible
    };
    return data;
  }
}
