class UpdateClass {
  final int? classId;
  final String? className;
  final String? classType;
  final int? department;
  final List departmentIdList;
  const UpdateClass(
      {this.classType,
      this.className,
      this.classId,
      this.department,
      required this.departmentIdList});
}
