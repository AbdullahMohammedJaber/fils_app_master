class DeliveryCompaniesModel {
  // final dynamic id;
  // final String? name;
  // final String? address;
  // final dynamic price;
  // final String? pathImage;
  // bool? select;
  //
  // DeliveryCompaniesModel({
  //   required this.id,
  //   required this.name,
  //   required this.select,
  //   required this.pathImage,
  //   required this.address,
  //   required this.price,
  // });
  //
  // cleanAllSelect({List<DeliveryCompaniesModel>? list}) {
  //   for (var element in list!) {
  //     element.select = false;
  //   }
  // }
  final String? name;
  final String? email;
  final String? mobile;
  final String? address;
  final dynamic cityId;

  DeliveryCompaniesModel({
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
    required this.cityId,
  });
}
