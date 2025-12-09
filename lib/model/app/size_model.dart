class SizeModel {
  final dynamic id;
  final String? name;
  bool? select;
  dynamic price;
  dynamic qtu;
  SizeModel({
    required this.id,
    required this.name,
    required this.select,
    required this.price,
    required this.qtu,
  });

  cleanAllSelect({List<SizeModel>? list}) {
    for (var element in list!) {
      element.select = false;
    }
  }
}
