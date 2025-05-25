import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class ObjectLayerModel {
  int id;
  String type;
  List<LatLng> points;
  Color color;
  int weight;

  ObjectLayerModel({
    required this.id,
    required this.type,
    required this.points,
    required this.color,
    required this.weight
  });
}