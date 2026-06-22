enum AttendanceStatus {
  pending,
  approved,
  rejected,
}

class AttendanceRecord {
  final String id;
  final String studentId;
  final DateTime date;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final String? gpsLocationIn;
  final String? gpsLocationOut;
  final String? selfieImagePath;
  final String? dtrPhotoPath;
  final String? notes;
  final AttendanceStatus status;
  final String? supervisorSignature;
  final String? supervisorNotes;
  final double? renderedHours;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.date,
    this.timeIn,
    this.timeOut,
    this.gpsLocationIn,
    this.gpsLocationOut,
    this.selfieImagePath,
    this.dtrPhotoPath,
    this.notes,
    this.status = AttendanceStatus.pending,
    this.supervisorSignature,
    this.supervisorNotes,
    this.renderedHours,
    required this.createdAt,
    required this.updatedAt,
  });

  double calculateRenderedHours() {
    if (timeIn == null || timeOut == null) return 0;
    return timeOut!.difference(timeIn!).inMinutes / 60;
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      date: DateTime.parse(json['date'] as String),
      timeIn: json['time_in'] != null ? DateTime.parse(json['time_in']) : null,
      timeOut: json['time_out'] != null ? DateTime.parse(json['time_out']) : null,
      gpsLocationIn: json['gps_location_in'] as String?,
      gpsLocationOut: json['gps_location_out'] as String?,
      selfieImagePath: json['selfie_image_path'] as String?,
      dtrPhotoPath: json['dtr_photo_path'] as String?,
      notes: json['notes'] as String?,
      status: AttendanceStatus.pending,
      supervisorSignature: json['supervisor_signature'] as String?,
      supervisorNotes: json['supervisor_notes'] as String?,
      renderedHours: json['rendered_hours'] as double?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'date': date.toIso8601String(),
        'time_in': timeIn?.toIso8601String(),
        'time_out': timeOut?.toIso8601String(),
        'gps_location_in': gpsLocationIn,
        'gps_location_out': gpsLocationOut,
        'selfie_image_path': selfieImagePath,
        'dtr_photo_path': dtrPhotoPath,
        'notes': notes,
        'status': status.toString(),
        'supervisor_signature': supervisorSignature,
        'supervisor_notes': supervisorNotes,
        'rendered_hours': renderedHours,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  AttendanceRecord copyWith({
    String? id,
    String? studentId,
    DateTime? date,
    DateTime? timeIn,
    DateTime? timeOut,
    String? gpsLocationIn,
    String? gpsLocationOut,
    String? selfieImagePath,
    String? dtrPhotoPath,
    String? notes,
    AttendanceStatus? status,
    String? supervisorSignature,
    String? supervisorNotes,
    double? renderedHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      timeIn: timeIn ?? this.timeIn,
      timeOut: timeOut ?? this.timeOut,
      gpsLocationIn: gpsLocationIn ?? this.gpsLocationIn,
      gpsLocationOut: gpsLocationOut ?? this.gpsLocationOut,
      selfieImagePath: selfieImagePath ?? this.selfieImagePath,
      dtrPhotoPath: dtrPhotoPath ?? this.dtrPhotoPath,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      supervisorSignature: supervisorSignature ?? this.supervisorSignature,
      supervisorNotes: supervisorNotes ?? this.supervisorNotes,
      renderedHours: renderedHours ?? this.renderedHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
