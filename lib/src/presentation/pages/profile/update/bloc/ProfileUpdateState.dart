import 'dart:io';

import 'package:ecommerce_flutter/src/domain/models/User.dart';
import 'package:ecommerce_flutter/src/domain/utils/Resource.dart';
import 'package:ecommerce_flutter/src/presentation/utils/BlocFormItem.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class ProfileUpdateState extends Equatable {

  final int id;
  final BlocFormItem name;
  final BlocFormItem lastname;
  final BlocFormItem phone;
  final BlocFormItem imageUrl;
  final File? image; 
  final String? notificationToken;
  final GlobalKey<FormState>? formKey;
  final Resource? response;

  const ProfileUpdateState({
    this.id = 0,
    this.name = const BlocFormItem(error: 'Ingresa el nombre'),
    this.lastname = const BlocFormItem(error: 'Ingresa el apellido'),
    this.phone = const BlocFormItem(error: 'Ingresa el telefono'),
    this.imageUrl = const BlocFormItem(value: ''),
    this.notificationToken,
    this.formKey,
    this.image,
    this.response
  });

  toUser() => User(
    id: id,
    name: name.value, 
    lastname: lastname.value, 
    phone: phone.value,
    image: imageUrl.value.isNotEmpty ? imageUrl.value : null,
    notificationToken: notificationToken
  );

  ProfileUpdateState copyWith({
    int? id,
    BlocFormItem? name,
    BlocFormItem? lastname,
    BlocFormItem? phone,
    BlocFormItem? imageUrl,
    File? image,
    String? notificationToken,
    GlobalKey<FormState>? formKey,
    Resource? response
  }) {
    return ProfileUpdateState(
      id: id ?? this.id,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      image: image ?? this.image,
      notificationToken: notificationToken ?? this.notificationToken,
      formKey: formKey,
      response: response
    );
  }

  @override
  List<Object?> get props => [id, name, lastname, phone, imageUrl, image, notificationToken, response];

}
