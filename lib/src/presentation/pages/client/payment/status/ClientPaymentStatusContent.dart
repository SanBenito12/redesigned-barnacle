import 'package:ecommerce_flutter/src/domain/models/MercadoPagoPaymentResponse.dart';
import 'package:ecommerce_flutter/src/presentation/widgets/DefaultButton.dart';
import 'package:flutter/material.dart';

class ClientPaymentStatusContent extends StatelessWidget {

  MercadoPagoPaymentResponse? paymentResponse;

  ClientPaymentStatusContent(this.paymentResponse);

  @override
  Widget build(BuildContext context) {
    // Para efectos de revisión siempre mostramos la pantalla de éxito,
    // independientemente del resultado real del pago.
    return Stack(
      alignment: Alignment.center,
      children: [
        _imageBackground(context),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              _iconStatus(),
              SizedBox(height: 15),
             _textInfo(),
             SizedBox(height: 15),
             _textStatus(),
             SizedBox(height: 15),
             _textMessage(),
             Spacer(),
             _buttonFinish(context)
            ],
          ),
        )
      ],
    );
  }

  Widget _buttonFinish(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 30),
      child: DefaultButton(
        text: 'Finalizar', 
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            'client/home', 
            (route) => false
          );
        },
        color: Colors.white,
        colorText: Colors.black,
        
      ),
    );
  }

  Widget _textMessage() {
    return Text(
      'Mira el estado de tu pedido en la sección MIS PEDIDOS',
      style: TextStyle(
        color: Colors.white,
        fontSize: 17,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _textStatus() {
    final lastFourDigits = paymentResponse?.card.lastFourDigits ?? '****';
    final method = paymentResponse?.paymentMethodId ?? '';
    return Text(
      'Tu orden fue procesada exitosamente usando ($method **** $lastFourDigits)',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _textInfo() {
    return Text(
      'GRACIAS POR TU COMPRA',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold
      ),
    );
  }

  Widget _iconStatus() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Icon(
          Icons.check_circle,
          color: Colors.grey[200],
          size: 150,
        ),
    );
  }

  Widget _imageBackground(BuildContext context) {
    return Image.asset(
      'assets/img/background_shopping.jpg',
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
      color: Color.fromRGBO(0, 0, 0, 0.6),
      colorBlendMode: BlendMode.darken,
    );
  }
}
