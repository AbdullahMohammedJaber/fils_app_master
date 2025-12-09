class SubscribeModel {
  bool? isSelect;
  final bool? isOffer;
  final String? price;
  final String? date;
  final String? title;
  final Function? onTap;

  SubscribeModel({
    this.isOffer,
    this.price,
    this.date,
    this.title,
    this.onTap,
    this.isSelect,
  });
}
