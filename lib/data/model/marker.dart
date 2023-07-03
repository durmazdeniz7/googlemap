class MarkerModel {
  final int? id;
  final String? lat;
  final String? long;
  final String? description;
  MarkerModel({
    this.id,
    this.lat,
    this.long,
    this.description,
  });

  factory MarkerModel.fromJson(Map<String, Object?> json) {
    return MarkerModel(
        id: json['id'] as int?, lat: json['lat'] as String?, long: json['long'] as String?, description: json['description'] as String?);
  }

  @override
  String toString() => 'MarkerModel(id: $id, lat: $lat, long: $long)';
}
