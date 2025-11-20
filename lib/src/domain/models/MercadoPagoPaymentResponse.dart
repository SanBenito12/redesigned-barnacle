import 'dart:convert';

MercadoPagoPaymentResponse mercadoPagoPaymentResponseFromJson(String str) =>
    MercadoPagoPaymentResponse.fromJson(json.decode(str));

String mercadoPagoPaymentResponseToJson(MercadoPagoPaymentResponse data) =>
    json.encode(data.toJson());

class MercadoPagoPaymentResponse {
  final int? id;
  final String status;
  final String statusDetail;
  final String paymentMethodId;
  final PaymentCard card;

  MercadoPagoPaymentResponse({
    required this.id,
    required this.status,
    required this.statusDetail,
    required this.paymentMethodId,
    required this.card,
  });

  factory MercadoPagoPaymentResponse.fromJson(Map<String, dynamic> json) {
    return MercadoPagoPaymentResponse(
      id: json['id'] is num ? (json['id'] as num).toInt() : int.tryParse(json['id']?.toString() ?? ''),
      status: json['status'] ?? '',
      statusDetail: json['status_detail'] ?? '',
      paymentMethodId: json['payment_method_id'] ?? '',
      card: PaymentCard.fromJson(json['card'] ?? const {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'status_detail': statusDetail,
        'payment_method_id': paymentMethodId,
        'card': card.toJson(),
      };
}

class PaymentCard {
  final String lastFourDigits;

  const PaymentCard({required this.lastFourDigits});

  factory PaymentCard.fromJson(Map<String, dynamic> json) {
    return PaymentCard(
      lastFourDigits: json['last_four_digits']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'last_four_digits': lastFourDigits,
      };
}
