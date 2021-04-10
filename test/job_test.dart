import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_app/app/models/job.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      final job = Job.fromMap(null, 'abc');
      expect(job, throwsArgumentError);
    });

    test('job with all properties', () {
      final job = Job.fromMap(
        {
          'name': 'Blogging',
          'ratePerHour': 10,
        },
        'abc',
      );
      expect(
          job,
          Job(
            id: 'abc',
            name: 'Blogging',
            ratePerHour: 10,
          ));
    });

    test('job with missing properties', () {
      final job = Job.fromMap(
        {
          'ratePerHour': 10,
        },
        'abc',
      );
      expect(
        job,
        throwsArgumentError,
      );
    });
  });

  group('toMap', () {
    test('valid name, ratePerHour', () {
      final job = Job(name: 'Blogging', ratePerHour: 10, id: '123');
      expect(job.toMap(), {
        'name': 'Blogging',
        'ratePerHour': 10,
      });
    });
  });
}
