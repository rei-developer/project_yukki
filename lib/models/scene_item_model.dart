class SceneItemModel {
  SceneItemModel(
    this.indexes,
    this.type,
    this.parentId,
    this.tag,
    this.remarks,
    this.data,
    this.children,
  );

  factory SceneItemModel.initial(
    List<int>? indexes,
    String type,
    dynamic data, {
    String? parentId,
    String? tag,
    String? remarks,
    List<SceneItemModel>? children,
  }) =>
      SceneItemModel(
        indexes,
        type,
        parentId,
        tag,
        remarks,
        data,
        children ?? [],
      );

  SceneItemModel copyWith({
    List<int>? indexes,
    String? type,
    String? parentId,
    String? tag,
    String? remarks,
    dynamic data,
    List<SceneItemModel>? children,
  }) =>
      SceneItemModel(
        indexes ?? this.indexes,
        type ?? this.type,
        parentId ?? this.parentId,
        tag ?? this.tag,
        remarks ?? this.remarks,
        data ?? this.data,
        children ?? this.children,
      );

  final List<int>? indexes;
  final String type;
  final String? parentId;
  final String? tag;
  final String? remarks;
  final dynamic data;
  final List<SceneItemModel> children;
}
