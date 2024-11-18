class UpdateSubject {
  final int? subjectId;
  final String? subjectName;
  final String? courseModule;
  final int? lab;
  final int? theory;
  final int? department;
  final int? teacher;
  final List departmentIdList;
  final List teacherList;
  final String? semester;
  const UpdateSubject(
      {this.courseModule,this.semester,
      this.lab,
      this.theory,
      this.subjectName,
      this.subjectId,
      this.department,
      this.teacher,
      required this.teacherList,
      required this.departmentIdList});
}
