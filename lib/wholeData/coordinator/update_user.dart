class UpdateAccount {
  final int? userId;
  final String? name;
  final String? email;
  final String? password;
  final int? departmentId;
  final List department;
  const UpdateAccount(
      {this.email, this.name, this.password, this.userId, this.departmentId , required this.department});
}
