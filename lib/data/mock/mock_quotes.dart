import '../models/quote_item.dart';

final List<QuoteItem> mockQuotes = <QuoteItem>[
  QuoteItem(
    id: 'quote_1',
    text: 'The best way to predict the future is to create it.',
    author: 'Peter Drucker',
    date: DateTime(2026, 5, 22),
    isSaved: true,
  ),
  QuoteItem(
    id: 'quote_2',
    text: 'Believe you can and you are halfway there.',
    author: 'Theodore Roosevelt',
    date: DateTime(2026, 5, 23),
  ),
  QuoteItem(
    id: 'quote_3',
    text: 'Silence is sometimes the most beautiful answer.',
    author: 'Unknown',
    date: DateTime(2026, 5, 24),
  ),
  QuoteItem(
    id: 'quote_4',
    text: 'Rest is not a reward. It is a rhythm.',
    author: 'Soundscape Days',
    date: DateTime(2026, 5, 25),
  ),
];
