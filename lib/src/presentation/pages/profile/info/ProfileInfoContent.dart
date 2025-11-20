import 'package:ecommerce_flutter/src/domain/models/User.dart';
import 'package:ecommerce_flutter/src/presentation/widgets/RemoteImage.dart';
import 'package:flutter/material.dart';

class ProfileInfoContent extends StatelessWidget {

  User? user;

  ProfileInfoContent(this.user);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: _imageBackground()),
        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _imageProfile(),
                SizedBox(height: 24),
                _cardProfileInfo(context)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _cardProfileInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        )
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            ListTile(
              title: Text('${user?.name ?? ''} ${user?.lastname ?? ''}'),
              subtitle: Text('Nombre de usuario'),
              leading: Icon(Icons.person),
            ),
            ListTile(
              title: Text(user?.email ?? ''),
              subtitle: Text('Correo electronico'),
              leading: Icon(Icons.email),
            ),
            ListTile(
              title: Text(user?.phone ?? ''),
              subtitle: Text('Telefono'),
              leading: Icon(Icons.phone),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {
                  Navigator.pushNamed(context, 'profile/update', arguments: user);
                },
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _imageProfile() {
    return Container(
      width: 150,
      child: AspectRatio(
        aspectRatio: 1/1,
        child: ClipOval(
          child: user != null 
          ? RemoteImage(
            imageUrl: user?.image,
            fit: BoxFit.cover,
            fadeInDuration: Duration(seconds: 1),
          )
          : Container(),
        ),
      ),
    ); 
  }

  Widget _imageBackground() {
    return Image.asset(
      'assets/img/background1.jpg',
      fit: BoxFit.cover,
      color: Color.fromRGBO(0, 0, 0, 0.7),
      colorBlendMode: BlendMode.darken,
    );
  }
}
