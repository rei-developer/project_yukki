import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mana_studio/config/ui_config.dart';

class DebuggerModel {
  DebuggerModel(this.type, this.color, this.description, this.dateTime);

  factory DebuggerModel.initial({
    String? type,
    Color? color,
    String? description,
    DateTime? dateTime,
  }) =>
      DebuggerModel(
        type ?? '',
        color ?? primaryColor,
        description ?? '',
        dateTime ?? DateTime.now(),
      );

  DebuggerModel copyWith({
    String? type,
    Color? color,
    String? description,
    DateTime? dateTime,
  }) =>
      DebuggerModel(
        type ?? this.type,
        color ?? this.color,
        description ?? this.description,
        dateTime ?? this.dateTime,
      );

  String get time => DateFormat('HH:mm:ss').format(dateTime);

  final String type;
  final Color color;
  final String description;
  final DateTime dateTime;
}
