import 'dart:convert';

import 'package:ecommerce_flutter/src/data/api/ApiConfig.dart';
import 'package:ecommerce_flutter/src/domain/models/MercadoPagoCardTokenBody.dart';
import 'package:ecommerce_flutter/src/domain/models/MercadoPagoCardTokenResponse.dart';
import 'package:ecommerce_flutter/src/domain/models/MercadoPagoIdentificationType.dart';
import 'package:ecommerce_flutter/src/domain/models/MercadoPagoInstallments.dart';
import 'package:ecommerce_flutter/src/domain/models/MercadoPagoPaymentBody.dart';
import 'package:ecommerce_flutter/src/domain/models/MercadoPagoPaymentResponse.dart';
import 'package:ecommerce_flutter/src/domain/utils/ListToString.dart';
import 'package:ecommerce_flutter/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;

class MercadoPagoService {

  Future<String> token;

  MercadoPagoService(this.token);

   Future<Resource<List<MercadoPagoIdentificationType>>> getIdentificationTypes() async {
     try {
      Uri url = Uri.http(ApiConfig.API_ECOMMERCE, '/mercadopago/identification_types'); 
      Map<String, String> headers = { 
        "Content-Type": "application/json",
        "Authorization": await token
      };
      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<MercadoPagoIdentificationType> identificationTypes = MercadoPagoIdentificationType.fromJsonList(data);
        return Success(identificationTypes);
      }
      else { // ERROR
        return Error(listToString(data['message']));
      }      
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }

  Future<Resource<MercadoPagoCardTokenResponse>> createCardToken(MercadoPagoCardTokenBody mercadoPagoCardTokenBody) async {
     try {
      Uri url = Uri.http(ApiConfig.API_ECOMMERCE, '/mercadopago/card_token'); 
      Map<String, String> headers = { 
        "Content-Type": "application/json",
        "Authorization": await token
      };
      String body = json.encode(mercadoPagoCardTokenBody.toJson());
      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        MercadoPagoCardTokenResponse mercadoPagoCardTokenResponse = MercadoPagoCardTokenResponse.fromJson(data);
        return Success(mercadoPagoCardTokenResponse);
      }
      else { // ERROR
        return Error(listToString(data['message']));
      }      
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }

  Future<Resource<MercadoPagoPaymentResponse>> createPayment(MercadoPagoPaymentBody mercadoPagoPaymentBody) async {
     try {
      Uri url = Uri.http(ApiConfig.API_ECOMMERCE, '/mercadopago/payments'); 
      Map<String, String> headers = { 
        "Content-Type": "application/json",
        "Authorization": await token
      };
      String body = json.encode(mercadoPagoPaymentBody.toJson());
      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        MercadoPagoPaymentResponse mercadoPagoPaymentResponse = MercadoPagoPaymentResponse.fromJson(data);
        return Success(mercadoPagoPaymentResponse);
      }
      else { // ERROR
        return Error(listToString(data['message']));
      }      
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }

  Future<Resource<MercadoPagoInstallments>> getInstallments(String firstSixDigits, String amount) async {
     try {
      Uri url = Uri.http(ApiConfig.API_ECOMMERCE, '/mercadopago/installments/$firstSixDigits/$amount'); 
      Map<String, String> headers = { 
        "Content-Type": "application/json",
        "Authorization": await token
      };
      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final installmentsPayload = _extractInstallmentsPayload(data);
        if (installmentsPayload == null) {
          return Error('No se pudo obtener la información de cuotas');
        }
        MercadoPagoInstallments mercadoPagoInstallments = MercadoPagoInstallments.fromJson(installmentsPayload);
        return Success(mercadoPagoInstallments);
      }
      else { // ERROR
        return Error(listToString(data['message']));
      }      
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }

  Map<String, dynamic>? _extractInstallmentsPayload(dynamic data) {
    if (data is List && data.isNotEmpty) {
      final firstElement = data.first;
      if (firstElement is Map<String, dynamic>) {
        return firstElement;
      }
    }
    if (data is Map<String, dynamic>) {
      return data;
    }
    return null;
  }

}
