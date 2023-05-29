import 'package:intl/intl.dart';

extension StringExtension on String {
  /// Format the date to a named format
  ///  E.g `"20-03-2020T02:00:00Z".toDateFormat('dd-MMMM-yyyy')` => `"20-Mar-2020"`
  String toDateFormat(String format) {
    return DateFormat(format).format(DateTime.parse(this));
  }

  /// Capitalize each word inside string
  /// Example: `your name` => `Your Name`
  String get capitalize {
    return split(' ').map((e) => e.capitalizeFirst).join(' ');
  }

  /// Uppercase first letter inside string and let the others lowercase
  /// Example: `your name` => `Your name`
  String get capitalizeFirst {
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
