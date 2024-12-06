
const digiEventName = 'DIGI_STATUS';
const salesEventName = 'SALES_STATUS';
const equalSdkEventName = 'EQUAL_SDK_STATUS';
enum DigiLockerStatus { SUCCESS, FAILED }
class DigiEventModel {
  String? eventType;
  String? aadhaarDigiStatusKey;
  String? aadhaarDigiResponse;
  String? errorCode;
  String? digiState;
  String? digiCode;

  DigiEventModel(
      {this.eventType = digiEventName,
      this.aadhaarDigiStatusKey,
      this.aadhaarDigiResponse,
      this.digiState,
      this.digiCode,
      this.errorCode});

  DigiEventModel.fromJson(Map<dynamic, dynamic> json) {
    eventType = json['eventType'];
    aadhaarDigiStatusKey = json['aadhaarDigiStatusKey'];
    aadhaarDigiResponse = json['aadhaarDigiResponse'];
    digiState = json['digiState'];
    digiCode = json['digiCode'];
    errorCode = json['error_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventType'] = eventType;
    data['aadhaarDigiStatusKey'] = aadhaarDigiStatusKey;
    data['aadhaarDigiResponse'] = aadhaarDigiResponse;
    data['error_code'] = errorCode;
    data['digiState'] = digiState;
    data['digiCode'] = digiCode;
    return data;
  }

  Map<String, String> toEventData() {
    final Map<String, String> data = <String, String>{};
    data['event_type'] = eventType ?? '';
    data['aadhaar_digi_status_key'] = aadhaarDigiStatusKey ?? '';
    data['aadhaar_digi_response'] = aadhaarDigiResponse ?? '';
    data['error_code'] = errorCode ?? '';
    data['digi_state'] = digiState ?? '';
    return data;
  }
}


class SDKEventModel {
  String? eventType;
  String? transactionId;
  String? status;
  String? statusCode;
  String? message;

  SDKEventModel(
      {this.eventType = equalSdkEventName,
      this.status,
      this.message,
      this.statusCode,
      this.transactionId});

  SDKEventModel.fromJson(Map<String, dynamic> json) {
    eventType = json['eventType'];
    status = json['status'];
    message = json['message'];
    transactionId = json['transaction_id'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventType'] = eventType;
    data['status'] = status;
    data['message'] = message;
    data['status_code'] = statusCode;
    data['transaction_id'] = transactionId;
    return data;
  }
}
