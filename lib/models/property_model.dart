class PropertyModel {
  String? id;
  bool? availability;
  List<String>? images;
  String? price;
  String? region;
  String? city;
  String? subcity;
  String? description;
  String? contact;
  String? updatedAt;
  String? userId;

  Map<String, dynamic>? details;

  PropertyModel({
    this.id,
    this.userId,
    this.images,
    this.availability,
    this.region,
    this.city,
    this.subcity,
    this.price,
    this.details,
    this.description,
    this.contact,
    this.updatedAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> value) {
    var images = [];
    try {
      final List<dynamic>? data = value["Images"];
      if (data != null) {
        images = List<String>.from(data);
      }
    } catch (error) {
      images = [];
    }

    return PropertyModel(
      id: value["id"],
      images: images as List<String>,
      price: value["price"],
      details: value['details'],
      region: value['region'],
      city: value['city'],
      subcity: value['subcity'],
      description: value["description"],
      contact: value["contact"],
      updatedAt: value["updatedAt"],
    );
  }
}
