class EventResponse {
  String? eventType;
  String? status;
  String? message;
  String? statusCode;
  String? transactionId;

  EventResponse(
      {this.eventType = "EQUAL_SDK_STATUS",
      this.status,
      this.message,
      this.statusCode,
      this.transactionId});

  EventResponse.fromJson(Map<String, dynamic> json) {
    eventType = json['eventType'];
    status = json['status'];
    message = json['message'];
    statusCode = json['status_code'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventType'] = this.eventType;
    data['status'] = this.status;
    data['message'] = this.message;
    data['status_code'] = this.statusCode;
    data['transaction_id'] = this.transactionId;
    return data;
  }
}
