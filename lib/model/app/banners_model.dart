class BannersModel {
  final dynamic id;
  final String pathImage;
  final String title;
  final String? subTitle;
  final String? descrebtion;
  final Function()? onTap;
  final bool? availableButton;
  final String? titleButton;

  BannersModel({
    required this.id,
    required this.pathImage,
    required this.title,
    this.subTitle,
    this.descrebtion,
    this.onTap,
    this.availableButton,
    this.titleButton,
  });
}
