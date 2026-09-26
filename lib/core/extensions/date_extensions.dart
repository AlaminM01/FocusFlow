import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  String get friendlyDate {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    if (isTomorrow) return 'Tomorrow';
    return DateFormat('MMM d').format(this);
  }

  String get friendlyDateTime {
    if (isToday) return 'Today, ${DateFormat('h:mm a').format(this)}';
    if (isYesterday) return 'Yesterday, ${DateFormat('h:mm a').format(this)}';
    return DateFormat('MMM d, h:mm a').format(this);
  }

  String get formattedTime => DateFormat('h:mm a').format(this);

  String get formattedDate => DateFormat('MMM d, yyyy').format(this);

  String get formattedDateShort => DateFormat('MMM d').format(this);

  String get dayOfWeek => DateFormat('EEEE').format(this);

  String get dayOfWeekShort => DateFormat('EEE').format(this);

  int get dayOfYear {
    return int.parse(DateFormat('D').format(this));
  }

  String get isoDate => DateFormat('yyyy-MM-dd').format(this);

  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formattedDate;
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
