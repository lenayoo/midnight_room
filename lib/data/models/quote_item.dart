class QuoteItem {
  const QuoteItem({
    required this.id,
    required this.text,
    required this.category,
    required this.author,
    required this.date,
    this.isSaved = false,
  });

  final String id;
  final String text;
  final String category;
  final String author;
  final DateTime date;
  final bool isSaved;

  factory QuoteItem.fromSimpleJson(Map<String, dynamic> json) {
    return QuoteItem(
      id: json['id'].toString(),
      text:
          (json['quote'] as String? ?? json['quotes'] as String? ?? '').trim(),
      category: (json['category'] as String? ?? 'calm').trim().toLowerCase(),
      author: '',
      date: DateTime.now(),
    );
  }

  QuoteItem copyWith({
    String? id,
    String? text,
    String? category,
    String? author,
    DateTime? date,
    bool? isSaved,
  }) {
    return QuoteItem(
      id: id ?? this.id,
      text: text ?? this.text,
      category: category ?? this.category,
      author: author ?? this.author,
      date: date ?? this.date,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
