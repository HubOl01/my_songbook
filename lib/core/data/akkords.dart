import '../model/akkordModel.dart';

List<String> tabs = [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
];

List<AkkordModel> akkordsList = [
  AkkordModel(
      index: 0,
      name: "A",
      image: "assets/other/light/A.svg",
      imageDark: "assets/other/dark/A.svg"),
  AkkordModel(
      index: 0,
      name: "A",
      barre: true,
      image: "assets/other/light/A(баррэ).svg",
      imageDark: "assets/other/dark/A(баррэ).svg"),
  AkkordModel(
      index: 0,
      name: "A#",
      image: "assets/other/light/A#.svg",
      imageDark: "assets/other/dark/A#.svg"),
  AkkordModel(
      index: 0,
      name: "A#m",
      image: "assets/other/light/A#m.svg",
      imageDark: "assets/other/dark/A#m.svg"),
  AkkordModel(
      index: 0,
      name: "A7",
      image: "assets/other/light/A7.svg",
      imageDark: "assets/other/dark/A7.svg"),
  AkkordModel(
      index: 0,
      name: "A7",
      barre: true,
      image: "assets/other/light/A7(баррэ).svg",
      imageDark: "assets/other/dark/A7(баррэ).svg"),
  AkkordModel(
      index: 0,
      name: "Am",
      image: "assets/other/light/Am.svg",
      imageDark: "assets/other/dark/Am.svg"),
  AkkordModel(
      index: 0,
      name: "Am7",
      image: "assets/other/light/Am7.svg",
      imageDark: "assets/other/dark/Am7.svg"),
  AkkordModel(
      index: 1,
      name: "B",
      image: "assets/other/light/B.svg",
      imageDark: "assets/other/dark/B.svg"),
  AkkordModel(
      index: 1,
      name: "B7",
      image: "assets/other/light/B7.svg",
      imageDark: "assets/other/dark/B7.svg"),
  AkkordModel(
      index: 1,
      name: "Bm",
      image: "assets/other/light/Bm.svg",
      imageDark: "assets/other/dark/Bm.svg"),
  AkkordModel(
      index: 2,
      name: "C",
      image: "assets/other/light/C.svg",
      imageDark: "assets/other/dark/C.svg"),
  AkkordModel(
      index: 2,
      name: "C",
      barre: true,
      image: "assets/other/light/C (баррэ).svg",
      imageDark: "assets/other/dark/C (баррэ).svg"),
  AkkordModel(
      index: 2,
      name: "C#",
      image: "assets/other/light/C#.svg",
      imageDark: "assets/other/dark/C#.svg"),
  AkkordModel(
      index: 2,
      name: "C#m",
      image: "assets/other/light/C#m.svg",
      imageDark: "assets/other/dark/C#m.svg"),
  AkkordModel(
      index: 2,
      name: "C7",
      barre: true,
      image: "assets/other/light/C7 (баррэ).svg",
      imageDark: "assets/other/dark/C7 (баррэ).svg"),
  AkkordModel(
      index: 2,
      name: "Cm",
      barre: true,
      image: "assets/other/light/Cm (баррэ).svg",
      imageDark: "assets/other/dark/Cm (баррэ).svg"),
  AkkordModel(
      index: 2,
      name: "Cm7",
      barre: true,
      image: "assets/other/light/Cm7 (баррэ).svg",
      imageDark: "assets/other/dark/Cm7 (баррэ).svg"),
  AkkordModel(
      index: 3,
      name: "D",
      image: "assets/other/light/D.svg",
      imageDark: "assets/other/dark/D.svg"),
  AkkordModel(
      index: 3,
      name: "D",
      barre: true,
      image: "assets/other/light/D (баррэ).svg",
      imageDark: "assets/other/dark/D (баррэ).svg"),
  AkkordModel(
      index: 3,
      name: "D#",
      image: "assets/other/light/D#.svg",
      imageDark: "assets/other/dark/D#.svg"),
  AkkordModel(
      index: 3,
      name: "D#m",
      image: "assets/other/light/D#m.svg",
      imageDark: "assets/other/dark/D#m.svg"),
  AkkordModel(
      index: 3,
      name: "D7",
      image: "assets/other/light/D7.svg",
      imageDark: "assets/other/dark/D7.svg"),
  AkkordModel(
      index: 3,
      name: "D7",
      barre: true,
      image: "assets/other/light/D7 (баррэ).svg",
      imageDark: "assets/other/dark/D7 (баррэ).svg"),
  AkkordModel(
      index: 3,
      name: "Dm",
      image: "assets/other/light/Dm.svg",
      imageDark: "assets/other/dark/Dm.svg"),
  AkkordModel(
      index: 3,
      name: "Dm",
      barre: true,
      image: "assets/other/light/Dm (баррэ).svg",
      imageDark: "assets/other/dark/Dm (баррэ).svg"),
  AkkordModel(
      index: 3,
      name: "Dm7",
      image: "assets/other/light/Dm7.svg",
      imageDark: "assets/other/dark/Dm7.svg"),
  AkkordModel(
      index: 3,
      name: "Dm7",
      barre: true,
      image: "assets/other/light/Dm7 (баррэ).svg",
      imageDark: "assets/other/dark/Dm7 (баррэ).svg"),
  AkkordModel(
      index: 4,
      name: "E",
      image: "assets/other/light/E.svg",
      imageDark: "assets/other/dark/E.svg"),
  AkkordModel(
      index: 4,
      name: "E7",
      image: "assets/other/light/E7.svg",
      imageDark: "assets/other/dark/E7.svg"),
  AkkordModel(
      index: 4,
      name: "Em",
      image: "assets/other/light/Em.svg",
      imageDark: "assets/other/dark/Em.svg"),
  AkkordModel(
      index: 5,
      name: "F",
      image: "assets/other/light/F.svg",
      imageDark: "assets/other/dark/F.svg"),
  AkkordModel(
      index: 5,
      name: "F#",
      image: "assets/other/light/F#.svg",
      imageDark: "assets/other/dark/F#.svg"),
  AkkordModel(
      index: 5,
      name: "F#m",
      image: "assets/other/light/F#m.svg",
      imageDark: "assets/other/dark/F#m.svg"),
  AkkordModel(
      index: 5,
      name: "F7",
      image: "assets/other/light/F7.svg",
      imageDark: "assets/other/dark/F7.svg"),
  AkkordModel(
      index: 5,
      name: "Fm",
      image: "assets/other/light/Fm.svg",
      imageDark: "assets/other/dark/Fm.svg"),
  AkkordModel(
      index: 6,
      name: "G",
      image: "assets/other/light/G.svg",
      imageDark: "assets/other/dark/G.svg"),
  AkkordModel(
      index: 6,
      name: "G",
      barre: true,
      image: "assets/other/light/G (баррэ).svg",
      imageDark: "assets/other/dark/G (баррэ).svg"),
  AkkordModel(
      index: 6,
      name: "G#",
      image: "assets/other/light/G#.svg",
      imageDark: "assets/other/dark/G#.svg"),
  AkkordModel(
      index: 6,
      name: "G#m",
      image: "assets/other/light/G#m.svg",
      imageDark: "assets/other/dark/G#m.svg"),
  AkkordModel(
      index: 6,
      name: "G7",
      image: "assets/other/light/G7.svg",
      imageDark: "assets/other/dark/G7.svg"),
  AkkordModel(
      index: 6,
      name: "G7",
      barre: true,
      image: "assets/other/light/G7 (баррэ).svg",
      imageDark: "assets/other/dark/G7 (баррэ).svg"),
  AkkordModel(
      index: 6,
      name: "Gm",
      barre: true,
      image: "assets/other/light/Gm (баррэ).svg",
      imageDark: "assets/other/dark/Gm (баррэ).svg"),
  AkkordModel(
      index: 6,
      name: "Gm7",
      barre: true,
      image: "assets/other/light/Gm7 (баррэ).svg",
      imageDark: "assets/other/dark/Gm7 (баррэ).svg"),
  AkkordModel(
      index: 7,
      name: "H",
      barre: true,
      image: "assets/other/light/H (баррэ).svg",
      imageDark: "assets/other/dark/H (баррэ).svg"),
  AkkordModel(
      index: 7,
      name: "H7",
      image: "assets/other/light/H7.svg",
      imageDark: "assets/other/dark/H7.svg"),
  AkkordModel(
      index: 7,
      name: "H7",
      barre: true,
      image: "assets/other/light/H7 (баррэ).svg",
      imageDark: "assets/other/dark/H7 (баррэ).svg"),
  AkkordModel(
      index: 7,
      name: "Hm",
      barre: true,
      image: "assets/other/light/Hm (баррэ).svg",
      imageDark: "assets/other/dark/Hm (баррэ).svg"),
  AkkordModel(
      index: 7,
      name: "Hm7",
      barre: true,
      image: "assets/other/light/Hm7 (баррэ).svg",
      imageDark: "assets/other/dark/Hm7 (баррэ).svg"),
];
