import '../../domain/entities/quote_entity.dart';

class QuotesRepository {
  static const List<QuoteEntity> _quotes = [
    // Stoic Philosophy
    QuoteEntity(
      quote:
          'You have power over your mind – not outside events. Realize this, and you will find strength.',
      author: 'Marcus Aurelius',
    ),
    QuoteEntity(
      quote:
          'The impediment to action advances action. What stands in the way becomes the way.',
      author: 'Marcus Aurelius',
    ),
    QuoteEntity(
      quote:
          'Begin at once to live, and count each separate day as a separate life.',
      author: 'Seneca',
    ),
    QuoteEntity(
      quote:
          'It is not that we have a short time to live, but that we waste much of it.',
      author: 'Seneca',
    ),
    QuoteEntity(
      quote:
          'First say to yourself what you would be; and then do what you have to do.',
      author: 'Epictetus',
    ),
    QuoteEntity(
      quote:
          'Wealth consists not in having great possessions, but in having few wants.',
      author: 'Epictetus',
    ),

    // Deep Work & Habits
    QuoteEntity(
      quote:
          'Deep work is the ability to focus without distraction on a cognitively demanding task.',
      author: 'Cal Newport',
    ),
    QuoteEntity(
      quote:
          'Clarity about what matters provides clarity about what does not.',
      author: 'Cal Newport',
    ),
    QuoteEntity(
      quote:
          'You do not rise to the level of your goals. You fall to the level of your systems.',
      author: 'James Clear',
    ),
    QuoteEntity(
      quote:
          'Every action you take is a vote for the type of person you wish to become.',
      author: 'James Clear',
    ),
    QuoteEntity(
      quote:
          'Success is the product of daily habits — not once-in-a-lifetime transformations.',
      author: 'James Clear',
    ),

    // Modern Innovators & Thinkers
    QuoteEntity(
      quote:
          'Specific knowledge is found by pursuing your genuine curiosity and passion rather than whatever is hot right now.',
      author: 'Naval Ravikant',
    ),
    QuoteEntity(
      quote:
          'A calm mind, a fit body, and a house full of love. These things cannot be bought — they must be earned.',
      author: 'Naval Ravikant',
    ),
    QuoteEntity(
      quote:
          'The most important skill for getting rich is becoming a perpetual learner.',
      author: 'Naval Ravikant',
    ),
    QuoteEntity(
      quote:
          'The only way to do great work is to love what you do.',
      author: 'Steve Jobs',
    ),
    QuoteEntity(
      quote:
          'Your time is limited, so don’t waste it living someone else’s life.',
      author: 'Steve Jobs',
    ),
    QuoteEntity(
      quote:
          'Simplicity is the ultimate sophistication.',
      author: 'Leonardo da Vinci',
    ),
    QuoteEntity(
      quote:
          'Creativity is intelligence having fun.',
      author: 'Albert Einstein',
    ),
    QuoteEntity(
      quote:
          'In the middle of difficulty lies opportunity.',
      author: 'Albert Einstein',
    ),
    QuoteEntity(
      quote:
          'The secret of getting ahead is getting started.',
      author: 'Mark Twain',
    ),
    QuoteEntity(
      quote:
          'Where focus goes, energy flows.',
      author: 'Tony Robbins',
    ),
    QuoteEntity(
      quote:
          'Done is better than perfect.',
      author: 'Sheryl Sandberg',
    ),
    QuoteEntity(
      quote:
          'Focus on being productive instead of busy.',
      author: 'Tim Ferriss',
    ),
    QuoteEntity(
      quote:
          'Fall seven times, stand up eight.',
      author: 'Japanese Proverb',
    ),
    QuoteEntity(
      quote:
          'The journey of a thousand miles begins with a single step.',
      author: 'Lao Tzu',
    ),
    QuoteEntity(
      quote:
          'Vision without action is a daydream. Action without vision is a nightmare.',
      author: 'Japanese Proverb',
    ),
    QuoteEntity(
      quote:
          'Small daily improvements over time lead to stunning results.',
      author: 'Robin Sharma',
    ),
    QuoteEntity(
      quote:
          'Discipline is the bridge between goals and accomplishment.',
      author: 'Jim Rohn',
    ),
    QuoteEntity(
      quote:
          'It always seems impossible until it is done.',
      author: 'Nelson Mandela',
    ),
    QuoteEntity(
      quote:
          'Believe you can and you’re halfway there.',
      author: 'Theodore Roosevelt',
    ),
    QuoteEntity(
      quote:
          'Start where you are. Use what you have. Do what you can.',
      author: 'Arthur Ashe',
    ),
    QuoteEntity(
      quote:
          'The best way to predict the future is to create it.',
      author: 'Peter Drucker',
    ),
    QuoteEntity(
      quote:
          'Peace comes from within. Do not seek it without.',
      author: 'Buddha',
    ),
    QuoteEntity(
      quote:
          'The present moment is filled with joy and happiness. If you are attentive, you will see it.',
      author: 'Thich Nhat Hanh',
    ),
    QuoteEntity(
      quote:
          'Work hard in silence, let your success be your noise.',
      author: 'Frank Ocean',
    ),
    QuoteEntity(
      quote:
          'Great things never came from comfort zones.',
      author: 'Neil Strauss',
    ),
    QuoteEntity(
      quote:
          'The mind is everything. What you think you become.',
      author: 'Buddha',
    ),
    QuoteEntity(
      quote:
          'Knowing is not enough; we must apply. Wishing is not enough; we must do.',
      author: 'Johann Wolfgang von Goethe',
    ),
    QuoteEntity(
      quote:
          'The future belongs to those who believe in the beauty of their dreams.',
      author: 'Eleanor Roosevelt',
    ),
    QuoteEntity(
      quote:
          'Action is the foundational key to all success.',
      author: 'Pablo Picasso',
    ),
    QuoteEntity(
      quote:
          'Do one thing every day that scares you.',
      author: 'Eleanor Roosevelt',
    ),
    QuoteEntity(
      quote:
          'The only limit to our realization of tomorrow will be our doubts of today.',
      author: 'Franklin D. Roosevelt',
    ),
    QuoteEntity(
      quote:
          'Doubt kills more dreams than failure ever will.',
      author: 'Suzy Kassem',
    ),
    QuoteEntity(
      quote:
          'He who has a why to live can bear almost any how.',
      author: 'Friedrich Nietzsche',
    ),
    QuoteEntity(
      quote:
          'Energy flows where attention goes.',
      author: 'Michael Beckwith',
    ),
    QuoteEntity(
      quote:
          'Focus is a muscle. The more you practice it, the stronger it gets.',
      author: 'Daniel Goleman',
    ),
    QuoteEntity(
      quote:
          'What we achieve inwardly will change outer reality.',
      author: 'Plutarch',
    ),
    QuoteEntity(
      quote:
          'Act as if what you do makes a difference. It does.',
      author: 'William James',
    ),
    QuoteEntity(
      quote:
          'Be not afraid of going slowly, be afraid only of standing still.',
      author: 'Chinese Proverb',
    ),
    QuoteEntity(
      quote:
          'Success is getting what you want. Happiness is wanting what you get.',
      author: 'Dale Carnegie',
    ),
  ];

  static List<QuoteEntity> getAllQuotes() => _quotes;

  static QuoteEntity getDailyQuote() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    return _quotes[dayOfYear % _quotes.length];
  }

  static QuoteEntity getRandomQuote() {
    final idx = DateTime.now().millisecondsSinceEpoch % _quotes.length;
    return _quotes[idx];
  }
}
