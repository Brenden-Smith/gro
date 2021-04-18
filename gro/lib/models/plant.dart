class Plant {

  int id;
  String name;
  String scientificName;
  String image;

  Plant({ this.id, this.name, this.scientificName, this.image});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return new Plant(
      id: json['id'],
      name: json['common_name'].toString(),
      scientificName: json['scientific_name'].toString(),
      image: json['image_url'].toString(),
    );
  }
}