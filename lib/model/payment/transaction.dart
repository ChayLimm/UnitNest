class Transaction {
  final String merchantType;
  final String? bakongAccountID;
  final String? accountInformation;
  final String? merchantID;
  final String? acquiringBank;
  final String? billNumber;
  final String? mobileNumber;
  final String? storeLabel;
  final String? terminalLabel;
  final String payloadFormatIndicator;
  final String pointofInitiationMethod;
  final String merchantCategoryCode;
  final String transactionCurrency;
  final String transactionAmount;
  final String countryCode;
  final String merchantName;
  final String merchantCity;
  final String timestamp;
  final String crc;

  Transaction({
    required this.merchantType,
    this.bakongAccountID,
    this.accountInformation,
    this.merchantID,
    this.acquiringBank,
    this.billNumber,
    this.mobileNumber,
    this.storeLabel,
    this.terminalLabel,
    required this.payloadFormatIndicator,
    required this.pointofInitiationMethod,
    required this.merchantCategoryCode,
    required this.transactionCurrency,
    required this.transactionAmount,
    required this.countryCode,
    required this.merchantName,
    required this.merchantCity,
    required this.timestamp,
    required this.crc,
  });

  // Optional: Method to convert JSON data into a Transaction object
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      merchantType: json['merchantType'] as String,
      bakongAccountID: json['bakongAccountID'] as String?,
      accountInformation: json['accountInformation'] as String?,
      merchantID: json['merchantID'] as String?,
      acquiringBank: json['acquiringBank'] as String?,
      billNumber: json['billNumber'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      storeLabel: json['storeLabel'] as String?,
      terminalLabel: json['terminalLabel'] as String?,
      payloadFormatIndicator: json['payloadFormatIndicator'] as String,
      pointofInitiationMethod: json['pointofInitiationMethod'] as String,
      merchantCategoryCode: json['merchantCategoryCode'] as String,
      transactionCurrency: json['transactionCurrency'] as String,
      transactionAmount: json['transactionAmount'] as String,
      countryCode: json['countryCode'] as String,
      merchantName: json['merchantName'] as String,
      merchantCity: json['merchantCity'] as String,
      timestamp: json['timestamp'] as String,
      crc: json['crc'] as String,
    );
  }

  // Optional: Method to convert Transaction object to JSON
  Map<String, dynamic> toJson() {
    return {
      'merchantType': merchantType,
      'bakongAccountID': bakongAccountID,
      'accountInformation': accountInformation,
      'merchantID': merchantID,
      'acquiringBank': acquiringBank,
      'billNumber': billNumber,
      'mobileNumber': mobileNumber,
      'storeLabel': storeLabel,
      'terminalLabel': terminalLabel,
      'payloadFormatIndicator': payloadFormatIndicator,
      'pointofInitiationMethod': pointofInitiationMethod,
      'merchantCategoryCode': merchantCategoryCode,
      'transactionCurrency': transactionCurrency,
      'transactionAmount': transactionAmount,
      'countryCode': countryCode,
      'merchantName': merchantName,
      'merchantCity': merchantCity,
      'timestamp': timestamp,
      'crc': crc,
    };
  }
}
