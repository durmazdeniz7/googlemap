part of 'marker_bloc.dart';

@immutable
abstract class MarkerState {}

class MarkerInitial extends MarkerState {}

class MarkerLoading extends MarkerState {}

class MarkerLoaded extends MarkerState {
  final List<MarkerModel> markers;
  final Uint8List bytes;

  MarkerLoaded({
    required this.markers,
    required this.bytes,
  });
}
