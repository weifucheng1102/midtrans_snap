library midtrans_snap;

import 'package:toolkit/map_utils.dart';
import 'package:toolkit/string_utils.dart';
import 'package:toolkit/toolkit.dart';

enum MidtransEnvironment { sandbox, production }

class MidtransResponse {
  MidtransResponse({
    this.orderId = '',
    this.finishRedirectUrl = '',
    this.grossAmount = 0,
    this.paymentCode = '',
    this.paymentType = '',
    this.pdfUrl = '',
    this.statusCode = 0,
    this.statusMessage = '',
    this.transactionStatus = '',
    this.transactionId = '',
    this.fraudStatus = '',
    this.billKey = '',
    this.billerCode = '',
    DateTime? transactionTime,
  }) {
    _transactionTime = transactionTime ?? DateTime.now();
  }

  factory MidtransResponse.fromJson(Map<dynamic, dynamic> json) =>
      MidtransResponse(
        finishRedirectUrl: json['finish_redirect_url'].toString().parse,
        grossAmount: json['gross_amount'].toString().asDouble,
        orderId: json['order_id'].toString().parse,
        paymentCode: json['payment_code'].toString().parse,
        paymentType: json['payment_type'].toString().parse,
        pdfUrl: json['pdf_url'].toString().parse,
        statusCode: json['status_code'].toString().asInt,
        statusMessage: json['status_message'].toString().parse,
        transactionStatus: json['transaction_status'].toString().parse,
        transactionId: json['transaction_id'].toString().parse,
        transactionTime: json['transaction_time'].toString().asDateTime,
        billKey: json['bill_key'].toString().parse,
        billerCode: json['biller_code'].toString().parse,
        fraudStatus: json['fraud_status'].toString().parse,
      );

  final String orderId,
      paymentType,
      statusMessage,
      transactionStatus,
      transactionId,
      pdfUrl,
      finishRedirectUrl,
      paymentCode,
      fraudStatus,
      billKey,
      billerCode;
  final int statusCode;
  final double grossAmount;

  late DateTime _transactionTime;
  DateTime get transactionTime => _transactionTime;

  Map<String, dynamic> _toJson() => {
        'order id': orderId,
        'payment type': paymentType,
        'payment code': paymentCode,
        'transaction id': transactionId,
        'transaction status': transactionStatus,
        'transaction time': transactionTime,
        'pdf url': pdfUrl,
        'status code': statusCode,
        'status message': statusMessage,
        'gross amount': grossAmount,
        'finish redirect url': finishRedirectUrl,
        'bill key': billKey,
        'biller code': billerCode,
        'fraud status': fraudStatus
      };

  Map<dynamic, dynamic> toJson() => _toJson().toMapTransform(ToolkitCase.camel);

  Map<dynamic, dynamic> toJsonSnake() =>
      _toJson().toMapTransform(ToolkitCase.snake);
}
