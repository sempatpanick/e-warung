class DeleteProductUserResult {
  DeleteProductUserResult({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory DeleteProductUserResult.fromJson(Map<String, dynamic> json) => DeleteProductUserResult(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
