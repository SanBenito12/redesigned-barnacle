import 'package:ecommerce_flutter/src/domain/models/Role.dart';
import 'package:ecommerce_flutter/src/presentation/widgets/RemoteImage.dart';
import 'package:flutter/material.dart';

class RolesItem extends StatelessWidget {
  
  Role role;
  RolesItem(this.role);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(context, role.route, (route) => false);
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10, top: 15),
            height: 100,
            child: RemoteImage(
              imageUrl: role.image,
              fit: BoxFit.contain,
              fadeInDuration: Duration(seconds: 1),
            ),
          ),
          Text(
            role.name,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),  
          ),
        ],
      ),
    );
  }
}
