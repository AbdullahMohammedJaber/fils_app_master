// ignore_for_file: prefer_if_null_operators

class TopStoresDatum {
  dynamic id;
  String? slug;
  String? name;
  String? logo;
  dynamic rating;
  dynamic productsCount;
  dynamic totalSales;
  dynamic address;
  dynamic description;

  TopStoresDatum({
    required this.id,
    required this.slug,
    required this.name,
    this.address = "USE",
    required this.logo,
    required this.rating,
    this.productsCount,
    required this.totalSales,
    required this.description,
  });

  factory TopStoresDatum.fromJson(Map<String, dynamic> json) => TopStoresDatum(
    id: json["id"],
    address: json["address"],
    slug: json["slug"],
    name: json["name"],
    logo: json["logo"],
    description: json["description"],
    rating: json["rating"],
    productsCount:
        json["products_count"] == null ? null : json["products_count"],
    totalSales: json["total_sales"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "name": name,
    "logo": logo,
    "rating": rating,
    "address": address,
    "products_count": productsCount,
    "total_sales": totalSales,
    "description": description,
  };
}
