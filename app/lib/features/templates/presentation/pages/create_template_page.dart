import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';
import 'package:diyar/features/templates/presentation/cubit/templates_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CreateTemplatePage extends StatefulWidget {
  final TemplateEntity? template;

  const CreateTemplatePage({super.key, this.template});

  @override
  State<CreateTemplatePage> createState() => _CreateTemplatePageState();
}

class _CreateTemplatePageState extends State<CreateTemplatePage> {
  final _formKey = GlobalKey<FormState>();
  final _templateNameController = TextEditingController();
  late final AddressFormControllers _addressControllers;
  late final ContactFormControllers _contactControllers;
  bool _isOperationSuccessful = false;

  @override
  void initState() {
    super.initState();
    _addressControllers = AddressFormControllers();
    _contactControllers = ContactFormControllers();

    if (widget.template != null) {
      _populateFields(widget.template!);
    }
  }

  void _populateFields(TemplateEntity template) {
    _templateNameController.text = template.templateName;
    _addressControllers.address.text = template.addressData.address;
    _addressControllers.house.text = template.addressData.houseNumber;
    _contactControllers.userName.text = template.contactInfo.userName;
    _contactControllers.phone.text = template.contactInfo.userPhone;
    _addressControllers.comment.text = template.addressData.comment ?? '';
    _addressControllers.entrance.text = template.addressData.entrance ?? '';
    _addressControllers.floor.text = template.addressData.floor ?? '';
    _addressControllers.intercom.text = template.addressData.intercom ?? '';
    _addressControllers.kvOffice.text = template.addressData.kvOffice ?? '';
  }

  @override
  void dispose() {
    _templateNameController.dispose();
    _addressControllers.dispose();
    _contactControllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<TemplatesCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Создания шаблонов'),
        ),
        body: BlocConsumer<TemplatesCubit, TemplatesState>(
          listener: (context, state) {
            final snackBar = SnackBarMessage();
            if (state is TemplatesCreationSuccess) {
              _isOperationSuccessful = true;
              context.router.maybePop();
              snackBar.showSuccessSnackBar(
                message: 'Шаблон успешно создан',
                context: context,
              );
            } else if (state is TemplatesUpdateSuccess) {
              _isOperationSuccessful = true;
              context.router.maybePop();
              snackBar.showSuccessSnackBar(
                message: 'Шаблон успешно обновлен',
                context: context,
              );
            } else if (state is TemplatesError) {
              // Игнорируем ошибки после успешной операции,
              // так как они могут быть вызваны fetchTemplates() из cubit
              if (!_isOperationSuccessful) {
                snackBar.showErrorSnackBar(
                  message: state.message,
                  context: context,
                );
              }
            }
          },
          builder: (context, state) {
            final isLoading = state is TemplatesLoading;
            final theme = Theme.of(context);
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  CustomInputWidget(
                    titleColor: theme.colorScheme.onSurface,
                    filledColor: theme.colorScheme.surface,
                    controller: _templateNameController,
                    hintText: 'Название шаблона *',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите название шаблона';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ContactFieldsWidget(
                    theme: theme,
                    controllers: _contactControllers,
                  ),
                  const SizedBox(height: 10),
                  AddressFieldsWidget(
                    theme: theme,
                    controllers: _addressControllers,
                    isAddressReadOnly: false,
                    showComment: true,
                  ),
                  const SizedBox(height: 24),
                  SubmitButtonWidget(
                    title: widget.template == null ? 'Создать шаблон' : 'Обновить шаблон',
                    bgColor: theme.colorScheme.primary,
                    isLoading: isLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _isOperationSuccessful = false; // Сбрасываем флаг перед новой операцией
                        final phone = _contactControllers.phone.text.replaceAll(RegExp(r'[^0-9]'), '');

                        final addressData = AddressEntity(
                          address: _addressControllers.address.text,
                          houseNumber: _addressControllers.house.text,
                          comment: _addressControllers.comment.text.isEmpty ? null : _addressControllers.comment.text,
                          entrance:
                              _addressControllers.entrance.text.isEmpty ? null : _addressControllers.entrance.text,
                          floor: _addressControllers.floor.text.isEmpty ? null : _addressControllers.floor.text,
                          intercom:
                              _addressControllers.intercom.text.isEmpty ? null : _addressControllers.intercom.text,
                          kvOffice:
                              _addressControllers.kvOffice.text.isEmpty ? null : _addressControllers.kvOffice.text,
                        );

                        final contactInfo = ContactInfoEntity(
                          userName: _contactControllers.userName.text,
                          userPhone: phone,
                        );

                        if (widget.template == null) {
                          // Создание нового шаблона - без id
                          final template = TemplateEntity(
                            id: null,
                            templateName: _templateNameController.text,
                            addressData: addressData,
                            contactInfo: contactInfo,
                          );
                          context.read<TemplatesCubit>().saveTemplate(template);
                        } else {
                          // Обновление существующего шаблона - с id
                          final template = TemplateEntity(
                            id: widget.template!.id,
                            templateName: _templateNameController.text,
                            addressData: addressData,
                            contactInfo: contactInfo,
                          );
                          context.read<TemplatesCubit>().updateTemplate(template);
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
