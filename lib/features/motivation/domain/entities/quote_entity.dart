/// A single motivational quote with its author.
class QuoteEntity {
  final String quote;
  final String author;

  const QuoteEntity({
    required this.quote,
    required this.author,
  });

  QuoteEntity copyWith({String? quote, String? author}) {
    return QuoteEntity(
      quote: quote ?? this.quote,
      author: author ?? this.author,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteEntity &&
          runtimeType == other.runtimeType &&
          quote == other.quote &&
          author == other.author;

  @override
  int get hashCode => quote.hashCode ^ author.hashCode;

  @override
  String toString() => '"$quote" — $author';
}
