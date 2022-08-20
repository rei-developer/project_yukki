class SceneContentModel {
  SceneContentModel(
    this.indexes,
    this.type,
    this.remarks,
    this.data,
    this.children,
  );

  factory SceneContentModel.initial(
    List<int>? indexes,
    String type,
    dynamic data, {
    String? remarks,
    List<SceneContentModel>? children,
  }) =>
      SceneContentModel(
        indexes,
        type,
        remarks,
        data,
        children ?? [],
      );

  factory SceneContentModel.initial2({
    List<int>? indexes,
    String? type,
    dynamic data,
    String? remarks,
    List<SceneContentModel>? children,
  }) =>
      SceneContentModel(
        indexes,
        type ?? '',
        remarks,
        data,
        children ?? [],
      );

  SceneContentModel copyWith({
    List<int>? indexes,
    String? type,
    String? remarks,
    dynamic data,
    List<SceneContentModel>? children,
  }) =>
      SceneContentModel(
        indexes ?? this.indexes,
        type ?? this.type,
        remarks ?? this.remarks,
        data ?? this.data,
        children ?? this.children,
      );

  String get contentId => indexes?.join('-') ?? '';

  final List<int>? indexes;
  final String type;
  final String? remarks;
  final dynamic data;
  final List<SceneContentModel> children;
}
