

import 'akkordModel.dart';

class TonalityModel {
  final String name;
  final List<AkkordModel> akkord;
  final List<AkkordModel> addAkkord;

  TonalityModel(
      {required this.name, required this.akkord, required this.addAkkord});
}
