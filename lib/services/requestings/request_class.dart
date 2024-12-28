class ClassRequest {
  final int requestingDepartment;
  final int requestedClass;
  final String purpose;

  ClassRequest({
    required this.requestingDepartment,
    required this.requestedClass,
    required this.purpose,
  });

  Map<String, dynamic> toJson() {
    return {
      'department_id': requestingDepartment,
      'class_id': requestedClass,
      'purpose': purpose,
    };
  }
}
