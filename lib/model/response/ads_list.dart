import 'dart:convert';

class AdsListResponse {
  bool? result;
  int? code;
  Data? data;

  AdsListResponse({
    this.result,
    this.code,
    this.data,
  });

  factory AdsListResponse.fromRawJson(String str) => AdsListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdsListResponse.fromJson(Map<String, dynamic> json) => AdsListResponse(
    result: json["result"],
    code: json["code"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "code": code,
    "data": data?.toJson(),
  };
}

class Data {
  List<AdsSubscription>? adsSubscriptions;

  Data({
    this.adsSubscriptions,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    adsSubscriptions: json["ads_subscriptions"] == null ? [] : List<AdsSubscription>.from(json["ads_subscriptions"]!.map((x) => AdsSubscription.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ads_subscriptions": adsSubscriptions == null ? [] : List<dynamic>.from(adsSubscriptions!.map((x) => x.toJson())),
  };
}

class AdsSubscription {
  int? id;
  AdsArea? adsArea;
  Product? product;
  String? coverImage;

  AdsSubscription({
    this.id,
    this.adsArea,
    this.product,
    this.coverImage,
  });

  factory AdsSubscription.fromRawJson(String str) => AdsSubscription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdsSubscription.fromJson(Map<String, dynamic> json) => AdsSubscription(
    id: json["id"],
    adsArea: json["ads_area"] == null ? null : AdsArea.fromJson(json["ads_area"]),
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    coverImage: json["cover_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ads_area": adsArea?.toJson(),
    "product": product?.toJson(),
    "cover_image": coverImage,
  };
}

class AdsArea {
  int? id;
  String? name;
  String? pricePerDay;
  String? place;
  int? maxSlots;
  DateTime? createdAt;
  DateTime? updatedAt;

  AdsArea({
    this.id,
    this.name,
    this.pricePerDay,
    this.place,
    this.maxSlots,
    this.createdAt,
    this.updatedAt,
  });

  factory AdsArea.fromRawJson(String str) => AdsArea.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdsArea.fromJson(Map<String, dynamic> json) => AdsArea(
    id: json["id"],
    name: json["name"],
    pricePerDay: json["price_per_day"],
    place: json["place"],
    maxSlots: json["max_slots"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price_per_day": pricePerDay,
    "place": place,
    "max_slots": maxSlots,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Product {
  int? id;
  String? name;
  String? addedBy;
  int? userId;
  int? shopId;
  int? categoryId;
  int? brandId;
  dynamic photos;
  String? thumbnailImg;
  dynamic videoProvider;
  dynamic videoLink;
  String? tags;
  String? description;
  int? unitPrice;
  dynamic purchasePrice;
  int? variantProduct;
  String? attributes;
  String? choiceOptions;
  String? colors;
  dynamic variations;
  int? todaysDeal;
  int? published;
  int? approved;
  String? stockVisibilityState;
  int? cashOnDelivery;
  int? featured;
  int? sellerFeatured;
  int? currentStock;
  String? unit;
  int? weight;
  int? minQty;
  int? lowStockQuantity;
  int? discount;
  String? discountType;
  dynamic discountStartDate;
  dynamic discountEndDate;
  int? startingBid;
  dynamic auctionStartDate;
  dynamic auctionEndDate;
  dynamic tax;
  dynamic taxType;
  String? shippingType;
  int? shippingCost;
  int? isQuantityMultiplied;
  dynamic estShippingDays;
  int? numOfSale;
  String? metaTitle;
  String? metaDescription;
  String? metaImg;
  dynamic pdf;
  String? slug;
  int? rating;
  dynamic barcode;
  int? digital;
  int? auctionProduct;
  String? auctionType;
  dynamic fileName;
  dynamic filePath;
  dynamic externalLink;
  String? externalLinkBtn;
  int? wholesaleProduct;
  String? frequentlyBoughtSelectionType;
  int? hasWarranty;
  dynamic warrantyId;
  dynamic warrantyNoteId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic auctionEndJobId;
  int? assuranceFee;
  int? isLive;
  int? isPaused;
  List<ProductTranslation>? productTranslations;
  List<dynamic>? taxes;
  Thumbnail? thumbnail;

  Product({
    this.id,
    this.name,
    this.addedBy,
    this.userId,
    this.shopId,
    this.categoryId,
    this.brandId,
    this.photos,
    this.thumbnailImg,
    this.videoProvider,
    this.videoLink,
    this.tags,
    this.description,
    this.unitPrice,
    this.purchasePrice,
    this.variantProduct,
    this.attributes,
    this.choiceOptions,
    this.colors,
    this.variations,
    this.todaysDeal,
    this.published,
    this.approved,
    this.stockVisibilityState,
    this.cashOnDelivery,
    this.featured,
    this.sellerFeatured,
    this.currentStock,
    this.unit,
    this.weight,
    this.minQty,
    this.lowStockQuantity,
    this.discount,
    this.discountType,
    this.discountStartDate,
    this.discountEndDate,
    this.startingBid,
    this.auctionStartDate,
    this.auctionEndDate,
    this.tax,
    this.taxType,
    this.shippingType,
    this.shippingCost,
    this.isQuantityMultiplied,
    this.estShippingDays,
    this.numOfSale,
    this.metaTitle,
    this.metaDescription,
    this.metaImg,
    this.pdf,
    this.slug,
    this.rating,
    this.barcode,
    this.digital,
    this.auctionProduct,
    this.auctionType,
    this.fileName,
    this.filePath,
    this.externalLink,
    this.externalLinkBtn,
    this.wholesaleProduct,
    this.frequentlyBoughtSelectionType,
    this.hasWarranty,
    this.warrantyId,
    this.warrantyNoteId,
    this.createdAt,
    this.updatedAt,
    this.auctionEndJobId,
    this.assuranceFee,
    this.isLive,
    this.isPaused,
    this.productTranslations,
    this.taxes,
    this.thumbnail,
  });

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    addedBy: json["added_by"],
    userId: json["user_id"],
    shopId: json["shop_id"],
    categoryId: json["category_id"],
    brandId: json["brand_id"],
    photos: json["photos"],
    thumbnailImg: json["thumbnail_img"],
    videoProvider: json["video_provider"],
    videoLink: json["video_link"],
    tags: json["tags"],
    description: json["description"],
    unitPrice: json["unit_price"],
    purchasePrice: json["purchase_price"],
    variantProduct: json["variant_product"],
    attributes: json["attributes"],
    choiceOptions: json["choice_options"],
    colors: json["colors"],
    variations: json["variations"],
    todaysDeal: json["todays_deal"],
    published: json["published"],
    approved: json["approved"],
    stockVisibilityState: json["stock_visibility_state"],
    cashOnDelivery: json["cash_on_delivery"],
    featured: json["featured"],
    sellerFeatured: json["seller_featured"],
    currentStock: json["current_stock"],
    unit: json["unit"],
    weight: json["weight"],
    minQty: json["min_qty"],
    lowStockQuantity: json["low_stock_quantity"],
    discount: json["discount"],
    discountType: json["discount_type"],
    discountStartDate: json["discount_start_date"],
    discountEndDate: json["discount_end_date"],
    startingBid: json["starting_bid"],
    auctionStartDate: json["auction_start_date"],
    auctionEndDate: json["auction_end_date"],
    tax: json["tax"],
    taxType: json["tax_type"],
    shippingType: json["shipping_type"],
    shippingCost: json["shipping_cost"],
    isQuantityMultiplied: json["is_quantity_multiplied"],
    estShippingDays: json["est_shipping_days"],
    numOfSale: json["num_of_sale"],
    metaTitle: json["meta_title"],
    metaDescription: json["meta_description"],
    metaImg: json["meta_img"],
    pdf: json["pdf"],
    slug: json["slug"],
    rating: json["rating"],
    barcode: json["barcode"],
    digital: json["digital"],
    auctionProduct: json["auction_product"],
    auctionType: json["auction_type"],
    fileName: json["file_name"],
    filePath: json["file_path"],
    externalLink: json["external_link"],
    externalLinkBtn: json["external_link_btn"],
    wholesaleProduct: json["wholesale_product"],
    frequentlyBoughtSelectionType: json["frequently_bought_selection_type"],
    hasWarranty: json["has_warranty"],
    warrantyId: json["warranty_id"],
    warrantyNoteId: json["warranty_note_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    auctionEndJobId: json["auction_end_job_id"],
    assuranceFee: json["assurance_fee"],
    isLive: json["is_live"],
    isPaused: json["is_paused"],
    productTranslations: json["product_translations"] == null ? [] : List<ProductTranslation>.from(json["product_translations"]!.map((x) => ProductTranslation.fromJson(x))),
    taxes: json["taxes"] == null ? [] : List<dynamic>.from(json["taxes"]!.map((x) => x)),
    thumbnail: json["thumbnail"] == null ? null : Thumbnail.fromJson(json["thumbnail"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "added_by": addedBy,
    "user_id": userId,
    "shop_id": shopId,
    "category_id": categoryId,
    "brand_id": brandId,
    "photos": photos,
    "thumbnail_img": thumbnailImg,
    "video_provider": videoProvider,
    "video_link": videoLink,
    "tags": tags,
    "description": description,
    "unit_price": unitPrice,
    "purchase_price": purchasePrice,
    "variant_product": variantProduct,
    "attributes": attributes,
    "choice_options": choiceOptions,
    "colors": colors,
    "variations": variations,
    "todays_deal": todaysDeal,
    "published": published,
    "approved": approved,
    "stock_visibility_state": stockVisibilityState,
    "cash_on_delivery": cashOnDelivery,
    "featured": featured,
    "seller_featured": sellerFeatured,
    "current_stock": currentStock,
    "unit": unit,
    "weight": weight,
    "min_qty": minQty,
    "low_stock_quantity": lowStockQuantity,
    "discount": discount,
    "discount_type": discountType,
    "discount_start_date": discountStartDate,
    "discount_end_date": discountEndDate,
    "starting_bid": startingBid,
    "auction_start_date": auctionStartDate,
    "auction_end_date": auctionEndDate,
    "tax": tax,
    "tax_type": taxType,
    "shipping_type": shippingType,
    "shipping_cost": shippingCost,
    "is_quantity_multiplied": isQuantityMultiplied,
    "est_shipping_days": estShippingDays,
    "num_of_sale": numOfSale,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "meta_img": metaImg,
    "pdf": pdf,
    "slug": slug,
    "rating": rating,
    "barcode": barcode,
    "digital": digital,
    "auction_product": auctionProduct,
    "auction_type": auctionType,
    "file_name": fileName,
    "file_path": filePath,
    "external_link": externalLink,
    "external_link_btn": externalLinkBtn,
    "wholesale_product": wholesaleProduct,
    "frequently_bought_selection_type": frequentlyBoughtSelectionType,
    "has_warranty": hasWarranty,
    "warranty_id": warrantyId,
    "warranty_note_id": warrantyNoteId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "auction_end_job_id": auctionEndJobId,
    "assurance_fee": assuranceFee,
    "is_live": isLive,
    "is_paused": isPaused,
    "product_translations": productTranslations == null ? [] : List<dynamic>.from(productTranslations!.map((x) => x.toJson())),
    "taxes": taxes == null ? [] : List<dynamic>.from(taxes!.map((x) => x)),
    "thumbnail": thumbnail?.toJson(),
  };
}

class ProductTranslation {
  int? id;
  int? productId;
  String? name;
  String? unit;
  String? description;
  String? lang;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProductTranslation({
    this.id,
    this.productId,
    this.name,
    this.unit,
    this.description,
    this.lang,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductTranslation.fromRawJson(String str) => ProductTranslation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductTranslation.fromJson(Map<String, dynamic> json) => ProductTranslation(
    id: json["id"],
    productId: json["product_id"],
    name: json["name"],
    unit: json["unit"],
    description: json["description"],
    lang: json["lang"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "name": name,
    "unit": unit,
    "description": description,
    "lang": lang,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Thumbnail {
  int? id;
  String? fileOriginalName;
  String? fileName;
  int? userId;
  int? fileSize;
  String? extension;
  String? type;
  dynamic externalLink;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Thumbnail({
    this.id,
    this.fileOriginalName,
    this.fileName,
    this.userId,
    this.fileSize,
    this.extension,
    this.type,
    this.externalLink,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Thumbnail.fromRawJson(String str) => Thumbnail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
    id: json["id"],
    fileOriginalName: json["file_original_name"],
    fileName: json["file_name"],
    userId: json["user_id"],
    fileSize: json["file_size"],
    extension: json["extension"],
    type: json["type"],
    externalLink: json["external_link"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "file_original_name": fileOriginalName,
    "file_name": fileName,
    "user_id": userId,
    "file_size": fileSize,
    "extension": extension,
    "type": type,
    "external_link": externalLink,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
