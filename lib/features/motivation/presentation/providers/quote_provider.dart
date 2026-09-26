import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusflow/features/motivation/domain/entities/quote_entity.dart';

/// Hard-coded motivational quotes (will later be seeded from Hive).
const _quotes = [
  QuoteEntity(
    quote: 'The secret of getting ahead is getting started.',
    author: 'Mark Twain',
  ),
  QuoteEntity(
    quote: 'Focus on being productive instead of busy.',
    author: 'Tim Ferriss',
  ),
  QuoteEntity(
    quote: 'Do what you can, with what you have, where you are.',
    author: 'Theodore Roosevelt',
  ),
  QuoteEntity(
    quote: 'It always seems impossible until it\'s done.',
    author: 'Nelson Mandela',
  ),
  QuoteEntity(
    quote: 'Don\'t watch the clock; do what it does. Keep going.',
    author: 'Sam Levenson',
  ),
  QuoteEntity(
    quote: 'The only way to do great work is to love what you do.',
    author: 'Steve Jobs',
  ),
  QuoteEntity(
    quote: 'Success is not final, failure is not fatal: it is the courage to continue that counts.',
    author: 'Winston Churchill',
  ),
  QuoteEntity(
    quote: 'Believe you can and you\'re halfway there.',
    author: 'Theodore Roosevelt',
  ),
  QuoteEntity(
    quote: 'The future depends on what you do today.',
    author: 'Mahatma Gandhi',
  ),
  QuoteEntity(
    quote: 'Act as if what you do makes a difference. It does.',
    author: 'William James',
  ),
];

final quoteIndexProvider = StateProvider<int>((ref) {
  return DateTime.now().dayOfYear % _quotes.length;
});

extension on DateTime {
  int get dayOfYear {
    final startOfYear = DateTime(year, 1, 1);
    return difference(startOfYear).inDays + 1;
  }
}

final currentQuoteProvider = Provider<QuoteEntity>((ref) {
  final index = ref.watch(quoteIndexProvider);
  return _quotes[index % _quotes.length];
});

class QuoteNotifier extends StateNotifier<QuoteEntity> {
  QuoteNotifier(QuoteEntity initial) : super(initial);

  int _index = 0;

  void nextQuote() {
    _index = (_index + 1) % _quotes.length;
    state = _quotes[_index];
  }
}

final quoteNotifierProvider =
    StateNotifierProvider<QuoteNotifier, QuoteEntity>((ref) {
  final initial = ref.read(currentQuoteProvider);
  return QuoteNotifier(initial);
});
