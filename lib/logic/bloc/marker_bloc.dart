import 'dart:typed_data';

import 'package:assesment_map/data/model/marker.dart';
import 'package:assesment_map/data/repository/marker_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:meta/meta.dart';

part 'marker_event.dart';
part 'marker_state.dart';

class MarkerBloc extends Bloc<MarkerEvent, MarkerState> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  MarkerBloc() : super(MarkerInitial()) {
    on<GetMarkers>((event, emit) async {
      ///convert Uint8List

      emit(MarkerLoading());
      final markers = await databaseHelper.getMarkers();
      final data = await rootBundle.load('assets/images/pin4.png');
      final bytes = data.buffer.asUint8List();
      emit(MarkerLoaded(markers: markers!, bytes: bytes));
    });
  }
}
