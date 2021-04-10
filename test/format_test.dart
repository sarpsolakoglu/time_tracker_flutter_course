import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_app/app/home_page/job_entries/format.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(
        Format.hours(10),
        '10h',
      );
    });
    test('zero', () {
      expect(
        Format.hours(0),
        '0h',
      );
    });
    test('negative', () {
      expect(
        Format.hours(-5),
        '0h',
      );
    });
    test('decimal', () {
      expect(
        Format.hours(4.5),
        '4.5h',
      );
    });
  });

  group('date - GB Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_GB';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('2019-08-12', () {
      expect(
        Format.date(DateTime(2019, 8, 12)),
        '12 Aug 2019',
      );
    });
    test('2019-07-16', () {
      expect(
        Format.date(DateTime(2019, 7, 16)),
        '16 Jul 2019',
      );
    });
  });

  group('dayOfWeek - GB Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_GB';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('Monday', () {
      expect(
        Format.dayOfWeek(DateTime(2019, 8, 12)),
        'Mon',
      );
    });
  });

  group('dayOfWeek - TR Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'tr_TR';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('Monday', () {
      expect(
        Format.dayOfWeek(DateTime(2019, 8, 12)),
        'Pzt',
      );
    });
  });

  group('currency - US Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_US';
    });
    test('positive', () {
      expect(
        Format.currency(10),
        '\$10',
      );
    });
    test('zero', () {
      expect(
        Format.currency(0),
        '',
      );
    });
    test('negative', () {
      expect(
        Format.currency(-5),
        '-\$5',
      );
    });
  });
}
