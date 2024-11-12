class UpdateTeacher {
  final int? teacherId;
  final String? teacherName;
  final String? email;
  final int? department;
  final List departmentIdList;
  const UpdateTeacher(
      {this.teacherName,
      this.email,
      this.teacherId,
      this.department,
      required this.departmentIdList});
}