import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:Aily/class/mapTitle.dart';

class TitleProvider extends ChangeNotifier {
  MapTitle? _title;

  TitleProvider() {
    _title = MapTitle.withDefault();
  }

  MapTitle get title => _title!;

  void addTitle(String newTitle) {
    final newTitleList = List<String>.from(_title!.title)..add(newTitle);
    updateTitle(MapTitle(title: newTitleList));
  }

  void updateTitle(MapTitle newTitle) {
    _title = newTitle;
    notifyListeners();
  }
}
