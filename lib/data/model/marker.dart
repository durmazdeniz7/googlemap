class MarkerModel {
  final int? id;
  final String? lat;
  final String? long;
  MarkerModel({this.id, this.lat, this.long});

  factory MarkerModel.fromJson(Map<String, Object?> json) {
    return MarkerModel(id: json['id'] as int?, lat: json['lat'] as String?, long: json['long'] as String?);
  }

  @override
  String toString() => 'MarkerModel(id: $id, lat: $lat, long: $long)';
}
