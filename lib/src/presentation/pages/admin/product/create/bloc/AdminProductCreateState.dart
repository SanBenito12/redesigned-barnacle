import 'dart:io';
import 'package:ecommerce_flutter/src/domain/models/Category.dart';
import 'package:ecommerce_flutter/src/domain/models/Product.dart';
import 'package:ecommerce_flutter/src/domain/utils/Resource.dart';
import 'package:ecommerce_flutter/src/presentation/utils/BlocFormItem.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AdminProductCreateState extends Equatable {

  final int idCategory;
  final BlocFormItem name;
  final BlocFormItem description;
  final BlocFormItem price;
  final BlocFormItem imageUrl1;
  final BlocFormItem imageUrl2;
  final GlobalKey<FormState>? formKey;
  File? file1;
  File? file2;
  final Resource? response;

  AdminProductCreateState({
    this.name = const BlocFormItem(error: 'Ingresa el nombre'),
    this.description = const BlocFormItem(error: 'Ingresa la descripcion'),
    this.price = const BlocFormItem(error: 'Ingresa el precio'),
    this.imageUrl1 = const BlocFormItem(value: ''),
    this.imageUrl2 = const BlocFormItem(value: ''),
    this.idCategory = 0,
    this.formKey,
    this.response,
    this.file1,
    this.file2
  });

  toProduct() => Product(
    name: name.value, 
    description: description.value, 
    price: double.parse(price.value),
    idCategory: idCategory,
    image1: imageUrl1.value.isNotEmpty ? imageUrl1.value : null,
    image2: imageUrl2.value.isNotEmpty ? imageUrl2.value : null
  );

  AdminProductCreateState resetForm() {
    return AdminProductCreateState(
      name: const BlocFormItem(error: 'Ingresa el nombre'),
      description: const BlocFormItem(error: 'Ingresa la descripcion'),
      imageUrl1: const BlocFormItem(value: ''),
      imageUrl2: const BlocFormItem(value: ''),
    );
  }

  AdminProductCreateState copyWith({
    int? idCategory,
    BlocFormItem? name,
    BlocFormItem? description,
    BlocFormItem? price,
    BlocFormItem? imageUrl1,
    BlocFormItem? imageUrl2,
    GlobalKey<FormState>? formKey,
    File? file1,
    File? file2,
    Resource? response
  }) {
    return AdminProductCreateState(
      idCategory: idCategory ?? this.idCategory,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl1: imageUrl1 ?? this.imageUrl1,
      imageUrl2: imageUrl2 ?? this.imageUrl2,
      file1: file1 ?? this.file1,
      file2: file2 ?? this.file2,
      formKey: formKey,
      response: response
    );
  }

  @override
  List<Object?> get props => [idCategory, name, description, price, imageUrl1, imageUrl2, file1, file2, response];

}
