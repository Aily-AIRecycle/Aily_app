class MapTitle {
  final List<String> title;

  MapTitle({required this.title});

  factory MapTitle.withDefault() {
    return MapTitle(title: []);
  }
}
