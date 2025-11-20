import 'dart:io';
import 'package:ecommerce_flutter/src/domain/models/Category.dart';
import 'package:ecommerce_flutter/src/domain/utils/Resource.dart';
import 'package:ecommerce_flutter/src/presentation/utils/BlocFormItem.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AdminCategoryCreateState extends Equatable {

  final BlocFormItem name;
  final BlocFormItem description;
  final BlocFormItem imageUrl;
  final GlobalKey<FormState>? formKey;
  File? file;
  final Resource? response;

  AdminCategoryCreateState({
    this.name = const BlocFormItem(error: 'Ingresa el nombre'),
    this.description = const BlocFormItem(error: 'Ingresa la descripcion'),
    this.imageUrl = const BlocFormItem(value: ''),
    this.formKey,
    this.response,
    this.file
  });

  toCategory() => Category(
    name: name.value, 
    description: description.value, 
    image: imageUrl.value.isNotEmpty ? imageUrl.value : null
  );

  AdminCategoryCreateState resetForm() {
    return AdminCategoryCreateState(
      name: const BlocFormItem(error: 'Ingresa el nombre'),
      description: const BlocFormItem(error: 'Ingresa la descripcion'),
      imageUrl: const BlocFormItem(value: ''),
      file: null,
      response: null,
      formKey: formKey,
    );
  }

  AdminCategoryCreateState copyWith({
    BlocFormItem? name,
    BlocFormItem? description,
    BlocFormItem? imageUrl,
    GlobalKey<FormState>? formKey,
    File? file,
    Resource? response
  }) {
    return AdminCategoryCreateState(
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      file: file ?? this.file,
      formKey: formKey,
      response: response
    );
  }

  @override
  List<Object?> get props => [name, description, imageUrl, file, response];

}
