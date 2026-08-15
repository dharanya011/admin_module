class GrievanceModel {
  final String id;
  final String grievanceId;
  final String submittedBy;
  final String category;
  final String details;
  final DateTime submissionDate;
  final String status;
  final String assignedTo;

  GrievanceModel({
    required this.id,
    required this.grievanceId,
    required this.submittedBy,
    required this.category,
    required this.details,
    required this.submissionDate,
    required this.status,
    required this.assignedTo,
  });

  factory GrievanceModel.fromJson(Map<String, dynamic> data) {
    return GrievanceModel(
      id: data['id']?.toString() ?? '',
      grievanceId: data['grievanceId'] ?? data['grievance_id'] ?? 'GRV-UNKNOWN',
      submittedBy: data['submittedBy'] ?? data['submitted_by'] ?? 'Anonymous',
      category: data['category'] ?? 'General',
      details: data['details'] ?? 'No details provided.',
      submissionDate: data['submissionDate'] != null
          ? DateTime.tryParse(data['submissionDate']) ?? DateTime.now()
          : (data['submission_date'] != null
              ? DateTime.tryParse(data['submission_date']) ?? DateTime.now()
              : DateTime.now()),
      status: data['status'] ?? 'Open',
      assignedTo: data['assignedTo'] ?? data['assigned_to'] ?? 'Unassigned',
    );
  }
}
