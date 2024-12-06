class EqualSDKConfig {
  final String clientId;
  final String idempotencyId;
  final String token;
  final String? mobile;

  EqualSDKConfig(
      {required this.clientId,
      required this.idempotencyId,
      required this.token,
      this.mobile});
}
