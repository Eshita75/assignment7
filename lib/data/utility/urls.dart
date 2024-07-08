class Urls{
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static const String registration = '$_baseUrl/registration';
  static const String signIn = '$_baseUrl/login';
  static const String createTask = '$_baseUrl/createTask';
  static const String newTasks = '$_baseUrl/listTaskByStatus/New';
  static const String completedTasks = '$_baseUrl/listTaskByStatus/Completed';
  static const String progressTasks = '$_baseUrl/listTaskByStatus/Progress';
  static const String cancelledTasks = '$_baseUrl/listTaskByStatus/Cancelled';
  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static  String deleteTask(String id) => '$_baseUrl/deleteTask/$id';
  static  String progressTaskStatus(String id, String status) => '$_baseUrl/updateTaskStatus/$id/$status';
  static  String cancelledTaskStatus(String id) => '$_baseUrl/updateTaskStatus/$id/Cancelled';
  static  String completedTaskStatus(String id) => '$_baseUrl/updateTaskStatus/$id/Completed';
  static String updateProfile = '$_baseUrl/profileUpdate';
  static  String mailVerification(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static  String otpVerification(String email, String otp) => '$_baseUrl/RecoverVerifyOTP/$email/$otp';
  static const String recoverResetPass = '$_baseUrl/RecoverResetPass';

}