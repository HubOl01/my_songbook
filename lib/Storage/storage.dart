import 'package:hive/hive.dart';

Future speedPut(int speed) async {
  var box = await Hive.openBox('my_songbook');
  box.put("speedText", speed);
  await box.compact();
  await box.close();
}

Future sizeTextPut(double sizeText) async {
  var box = await Hive.openBox('my_songbook');
  box.put("sizeText", sizeText);
  await box.compact();
  await box.close();
}

Future isClosedWarringPut(bool isClosedWarring) async {
  var box = await Hive.openBox('my_songbook');
  box.put("isClosedWarring", isClosedWarring);
  await box.compact();
  await box.close();
}

Future isDeleteTestPut(bool isDeleteTest) async {
  var box = await Hive.openBox('my_songbook');
  box.put("isDeleteTest", isDeleteTest);
  await box.compact();
  await box.close();
}

  // var box = await Hive.openBox('my_songbook');
  // speed = box.get("speedText");
  // sizeText = box.get("sizeText");
  // isClosedWarring = box.get("isClosedWarring");
  // isDeleteTest = box.get("isDeleteTest");