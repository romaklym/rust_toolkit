class GlobalData {
  static final GlobalData _singleton = GlobalData._internal();

  factory GlobalData() {
    return _singleton;
  }

  GlobalData._internal();

  List<dynamic> items = [];

  // Method to update the items list
  void updateItems(List<dynamic> newItems) {
    items = newItems;
  }

  // Method to get the current state of items
  List<dynamic> getItems() {
    return items;
  }
}
