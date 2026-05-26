class QuoteItem {
  const QuoteItem({
    required this.id,
    required this.text,
    required this.author,
    required this.date,
    this.isSaved = false,
  });

  final String id;
  final String text;
  final String author;
  final DateTime date;
  final bool isSaved;

  QuoteItem copyWith({
    String? id,
    String? text,
    String? author,
    DateTime? date,
    bool? isSaved,
  }) {
    return QuoteItem(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      date: date ?? this.date,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
