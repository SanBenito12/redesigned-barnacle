import 'package:ecommerce_flutter/src/domain/models/Order.dart';
import 'package:ecommerce_flutter/src/domain/models/Product.dart';
import 'package:ecommerce_flutter/src/presentation/widgets/RemoteImage.dart';
import 'package:flutter/material.dart';

class AdminOrderDetailItem extends StatelessWidget {

  OrderHasProduct? orderHasProduct;

  AdminOrderDetailItem(this.orderHasProduct);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: orderHasProduct != null 
        ? Container(
          width: 70,
          child: RemoteImage(
            imageUrl: orderHasProduct?.product.image1,
            fit: BoxFit.contain,
            fadeInDuration: Duration(seconds: 1),
          ),
        ) 
        : Container(),
      title: Text(
        orderHasProduct?.product.name ?? ''
      ),
      subtitle: Text(
        'Cantidad: ${orderHasProduct?.quantity}'
      ),
    );
  }
}
