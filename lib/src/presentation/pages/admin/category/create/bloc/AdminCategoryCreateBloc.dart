import 'dart:io';
import 'package:ecommerce_flutter/src/domain/useCases/categories/CategoriesUseCases.dart';
import 'package:ecommerce_flutter/src/domain/utils/Resource.dart';
import 'package:ecommerce_flutter/src/presentation/pages/admin/category/create/bloc/AdminCategoryCreateEvent.dart';
import 'package:ecommerce_flutter/src/presentation/pages/admin/category/create/bloc/AdminCategoryCreateState.dart';
import 'package:ecommerce_flutter/src/presentation/utils/BlocFormItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AdminCategoryCreateBloc extends Bloc<AdminCategoryCreateEvent, AdminCategoryCreateState> {

  CategoriesUseCases categoriesUseCases;

  AdminCategoryCreateBloc(this.categoriesUseCases): super(AdminCategoryCreateState()) {
    on<AdminCategoryCreateInitEvent>(_onInitEvent);
    on<NameChanged>(_onNameChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<ImageUrlChanged>(_onImageUrlChanged);
    on<FormSubmit>(_onFormSubmit);
    on<ResetForm>(_onResetForm);
    on<PickImage>(_onPickImage);
    on<TakePhoto>(_onTakePhoto);
  }

  final formKey = GlobalKey<FormState>();

  Future<void> _onInitEvent(AdminCategoryCreateInitEvent event, Emitter<AdminCategoryCreateState> emit) async {
    emit(
      state.copyWith(
        formKey: formKey
      )
    );
  }

  Future<void> _onNameChanged(NameChanged event, Emitter<AdminCategoryCreateState> emit) async {
    emit(
      state.copyWith(
        name: BlocFormItem(
          value: event.name.value,
          error: event.name.value.isNotEmpty ? null : 'Ingresa el nombre'
        ),
        formKey: formKey
      )
    );
  }

  Future<void> _onDescriptionChanged(DescriptionChanged event, Emitter<AdminCategoryCreateState> emit) async {
    emit(
      state.copyWith(
        description: BlocFormItem(
          value: event.description.value,
          error: event.description.value.isNotEmpty ? null : 'Ingresa la descripcion'
        ),
        formKey: formKey
      )
    );
  }

  Future<void> _onImageUrlChanged(ImageUrlChanged event, Emitter<AdminCategoryCreateState> emit) async {
    emit(
      state.copyWith(
        imageUrl: BlocFormItem(
          value: event.imageUrl.value,
          error: null
        ),
        file: null,
        formKey: formKey
      )
    );
  }

  Future<void> _onPickImage(PickImage event, Emitter<AdminCategoryCreateState> emit) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      emit(
        state.copyWith(
          file: File(image.path),
          imageUrl: const BlocFormItem(value: ''),
          formKey: formKey
        )
      );
    }
  }

  Future<void> _onTakePhoto(TakePhoto event, Emitter<AdminCategoryCreateState> emit) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      emit(
        state.copyWith(
          file: File(image.path),
          imageUrl: const BlocFormItem(value: ''),
          formKey: formKey
        )
      );
    }
  }

  Future<void> _onFormSubmit(FormSubmit event, Emitter<AdminCategoryCreateState> emit) async {
      if (state.file == null && state.imageUrl.value.isEmpty) {
        emit(
          state.copyWith(
            response: Error('Selecciona una imagen o ingresa el link'),
            formKey: formKey
          )
        );
        return;
      }
      emit(
        state.copyWith(
          response: Loading(),
          formKey: formKey
        )
      );
      Resource response = await categoriesUseCases.create.run(state.toCategory(), state.file);
      emit(
        state.copyWith(
          response: response,
          formKey: formKey
        )
      );
  }

  Future<void> _onResetForm(ResetForm event, Emitter<AdminCategoryCreateState> emit) async {
    emit(
      state.resetForm()
    );    
    // state.formKey?.currentState?.reset();
  }
}
