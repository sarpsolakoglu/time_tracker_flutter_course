import 'dart:ui';

class Job {
  Job({required this.id, required this.name, required this.ratePerHour});

  final String id;
  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw ArgumentError('Data shouldn\'t be null');
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(id: documentId, name: name, ratePerHour: ratePerHour);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }

  @override
  int get hashCode => hashValues(id, name, ratePerHour);

  @override
  bool operator ==(Object other) {
    return other is Job &&
        id == other.id &&
        name == other.name &&
        ratePerHour == other.ratePerHour;
  }

  @override
  String toString() {
    return 'id: $id, name: $name, ratePerHour: $ratePerHour';
  }
}
