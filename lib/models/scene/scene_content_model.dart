class SceneContentModel {
  SceneContentModel(
    this.uuid,
    this.indexes,
    this.type,
    this.remarks,
    this.data,
    this.children,
  );

  factory SceneContentModel.initial(
    String uuid,
    List<int>? indexes,
    String type,
    dynamic data, {
    String? remarks,
    List<SceneContentModel>? children,
  }) =>
      SceneContentModel(
        uuid,
        indexes,
        type,
        remarks,
        data,
        children ?? [],
      );

  SceneContentModel copyWith({
    String? uuid,
    List<int>? indexes,
    String? type,
    String? remarks,
    dynamic data,
    List<SceneContentModel>? children,
  }) =>
      SceneContentModel(
        uuid ?? this.uuid,
        indexes ?? this.indexes,
        type ?? this.type,
        remarks ?? this.remarks,
        data ?? this.data,
        children ?? this.children,
      );

  String get contentId => indexes?.join('-') ?? '';

  final String uuid;
  final List<int>? indexes;
  final String type;
  final String? remarks;
  final dynamic data;
  final List<SceneContentModel> children;
}
