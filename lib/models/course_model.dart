class CourseModel {

  const CourseModel({
    required this.id,
    required this.code,
    required this.name,
    required this.department,
    required this.subjectsCount,
    required this.status,
  });
  final String id;
  final String code;
  final String name;
  final String department;
  final int subjectsCount;
  final String status;

  CourseModel copyWith({
    String? id,
    String? code,
    String? name,
    String? department,
    int? subjectsCount,
    String? status,
  }) => CourseModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      department: department ?? this.department,
      subjectsCount: subjectsCount ?? this.subjectsCount,
      status: status ?? this.status,
    );
}

class SubjectModel {

  const SubjectModel({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.credits,
    required this.status,
    this.department = 'CSE',
  });
  final String id;
  final String code;
  final String name;
  final String type; // Theory, Lab, Elective
  final int credits;
  final String status;
  final String department;

  SubjectModel copyWith({
    String? id,
    String? code,
    String? name,
    String? type,
    int? credits,
    String? status,
    String? department,
  }) => SubjectModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      credits: credits ?? this.credits,
      status: status ?? this.status,
      department: department ?? this.department,
    );
}
