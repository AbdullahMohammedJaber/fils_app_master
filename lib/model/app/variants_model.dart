import 'dart:io';

class VariantsModel {
  final String? price;

  final String? sku;

  final String? qty;

  final String? img;
  final String? name;
  final File ? fileImage;
  VariantsModel({
    this.name,
    this.price,
    this.sku,
    this.qty,
    this.img,
    this.fileImage,
  });
}
