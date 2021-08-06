class HistoryItem {
  final String date;
  final String order;
  final String status;
  final String comment;
  final String image;

  HistoryItem({
    required this.date,
    required this.order,
    required this.status,
    required this.comment,
    required this.image,
  });

  factory HistoryItem.fromMap(Map data) {
    return HistoryItem(
      date: data['date'] ?? "",
      order: data['order'] ?? "",
      status: data['status'] ?? "",
      comment: data['comment'] ?? "",
      image: data['image'] ?? "",
    );
  }
}
