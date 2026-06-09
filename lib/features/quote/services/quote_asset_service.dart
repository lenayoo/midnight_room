import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../data/models/quote_item.dart';

class QuoteAssetService {
  const QuoteAssetService();

  Future<List<QuoteItem>> loadQuotes() async {
    final String jsonString = await rootBundle.loadString('assets/quotes.json');
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

    return jsonList
        .whereType<Map<String, dynamic>>()
        .map(QuoteItem.fromSimpleJson)
        .toList(growable: false);
  }
}
