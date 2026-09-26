import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/quote_entity.dart';
import '../../data/repositories/quotes_repository.dart';

final quotesProvider = Provider<List<QuoteEntity>>((ref) {
  return QuotesRepository.getAllQuotes();
});

final dailyQuoteProvider = Provider<QuoteEntity>((ref) {
  return QuotesRepository.getDailyQuote();
});

class RandomQuoteNotifier extends StateNotifier<QuoteEntity> {
  RandomQuoteNotifier() : super(QuotesRepository.getDailyQuote());

  void randomize() {
    state = QuotesRepository.getRandomQuote();
  }
}

final randomQuoteProvider =
    StateNotifierProvider<RandomQuoteNotifier, QuoteEntity>((ref) {
  return RandomQuoteNotifier();
});

final quoteNotifierProvider =
    StateNotifierProvider<RandomQuoteNotifier, QuoteEntity>((ref) {
  return RandomQuoteNotifier();
});
