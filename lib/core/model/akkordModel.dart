class AkkordModel {
  final int? index;
  final String name;
  final String? image;
  final String? imageDark;
  final bool barre;

  AkkordModel({
    this.index,
    required this.name,
    this.image,
    this.imageDark,
    this.barre = false,
  });
}
