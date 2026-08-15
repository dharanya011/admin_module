class UserModel {

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.node,
    required this.status,
    this.admissionNumber,
    this.admissionDate,
    this.rollNumber,
    this.registrationNumber,
    this.domainEmail,
    this.gender,
    this.community,
    this.dateOfBirth,
    this.contactNumber,
    this.batch,
    this.section,
    this.bloodGroup,
    this.designation,
    this.joiningDate,
    this.qualification,
    this.employeeId,
  });
  final String id;
  final String name;
  final String email;
  final String role;
  final String department;
  final String node;
  final String status;

  // Student & Staff extended fields
  final String? admissionNumber;
  final String? admissionDate;
  final String? rollNumber;
  final String? registrationNumber;
  final String? domainEmail;
  final String? gender;
  final String? community;
  final String? dateOfBirth;
  final String? contactNumber;
  final String? batch;
  final String? section;
  final String? bloodGroup;
  final String? designation;
  final String? joiningDate;
  final String? qualification;
  final String? employeeId;

  bool get isStudent => role == 'Student';
  bool get isFacultyOrHod => role == 'Faculty' || role == 'Department HOD';

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? department,
    String? node,
    String? status,
    String? admissionNumber,
    String? admissionDate,
    String? rollNumber,
    String? registrationNumber,
    String? domainEmail,
    String? gender,
    String? community,
    String? dateOfBirth,
    String? contactNumber,
    String? batch,
    String? section,
    String? bloodGroup,
    String? designation,
    String? joiningDate,
    String? qualification,
    String? employeeId,
  }) => UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      department: department ?? this.department,
      node: node ?? this.node,
      status: status ?? this.status,
      admissionNumber: admissionNumber ?? this.admissionNumber,
      admissionDate: admissionDate ?? this.admissionDate,
      rollNumber: rollNumber ?? this.rollNumber,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      domainEmail: domainEmail ?? this.domainEmail,
      gender: gender ?? this.gender,
      community: community ?? this.community,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      contactNumber: contactNumber ?? this.contactNumber,
      batch: batch ?? this.batch,
      section: section ?? this.section,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      designation: designation ?? this.designation,
      joiningDate: joiningDate ?? this.joiningDate,
      qualification: qualification ?? this.qualification,
      employeeId: employeeId ?? this.employeeId,
    );
}
