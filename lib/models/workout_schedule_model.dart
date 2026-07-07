class WorkoutScheduleModel {
  final String id;
  final String title;
  final String scheduleDate;
  final String startTime;
  final String? endTime;
  final String? trainingZone;
  final String? notes;
  final bool isCompleted;
  final String createdAt;

  WorkoutScheduleModel({
    required this.id,
    required this.title,
    required this.scheduleDate,
    required this.startTime,
    this.endTime,
    this.trainingZone,
    this.notes,
    required this.isCompleted,
    required this.createdAt,
  });

  factory WorkoutScheduleModel.fromJson(Map<String, dynamic> json) {
    return WorkoutScheduleModel(
      id: json['id'],
      title: json['title'],
      scheduleDate: json['schedule_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      trainingZone: json['training_zone'],
      notes: json['notes'],
      isCompleted: json['is_completed'],
      createdAt: json['created_at'] ?? '',
    );
  }

  /// Label training zone yang enak dibaca di UI.
  String get trainingZoneLabel {
    switch (trainingZone) {
      case 'recovery':
        return 'Recovery';
      case 'fat_burn':
        return 'Fat Burn';
      case 'cardio':
        return 'Cardio';
      case 'peak':
        return 'Peak';
      case 'maximum':
        return 'Maximum';
      default:
        return '-';
    }
  }
}
