import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/shared/shared.dart';
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
  final _addressController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userPhoneController = TextEditingController();
  final _commentController = TextEditingController();
  final _entranceController = TextEditingController();
  final _floorController = TextEditingController();
  final _intercomController = TextEditingController();
  final _kvOfficeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      _populateFields(widget.template!);
    }
  }

  void _populateFields(TemplateEntity template) {
    _templateNameController.text = template.templateName;
    _addressController.text = template.addressData.address;
    _houseNumberController.text = template.addressData.houseNumber;
    _userNameController.text = template.contactInfo.userName;
    _userPhoneController.text = template.contactInfo.userPhone;
    _commentController.text = template.addressData.comment ?? '';
    _entranceController.text = template.addressData.entrance ?? '';
    _floorController.text = template.addressData.floor ?? '';
    _intercomController.text = template.addressData.intercom ?? '';
    _kvOfficeController.text = template.addressData.kvOffice ?? '';
  }

  @override
  void dispose() {
    _templateNameController.dispose();
    _addressController.dispose();
    _houseNumberController.dispose();
    _userNameController.dispose();
    _userPhoneController.dispose();
    _commentController.dispose();
    _entranceController.dispose();
    _floorController.dispose();
    _intercomController.dispose();
    _kvOfficeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<TemplatesCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.template == null ? 'Create Template' : 'Edit Template'),
        ),
        body: BlocConsumer<TemplatesCubit, TemplatesState>(
          listener: (context, state) {
            if (state is TemplatesCreationSuccess) {
              context.router.maybePop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Template created successfully')),
              );
            } else if (state is TemplatesUpdateSuccess) {
              context.router.maybePop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Template updated successfully')),
              );
            } else if (state is TemplatesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is TemplatesLoading;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _templateNameController,
                    decoration: const InputDecoration(
                      labelText: 'Template Name *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter template name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _houseNumberController,
                    decoration: const InputDecoration(
                      labelText: 'House Number *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter house number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _userNameController,
                    decoration: const InputDecoration(
                      labelText: 'User Name *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter user name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _userPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'User Phone *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter user phone';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Comment',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _entranceController,
                    decoration: const InputDecoration(
                      labelText: 'Entrance',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _floorController,
                    decoration: const InputDecoration(
                      labelText: 'Floor',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _intercomController,
                    decoration: const InputDecoration(
                      labelText: 'Intercom',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _kvOfficeController,
                    decoration: const InputDecoration(
                      labelText: 'KV/Office',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final addressData = AddressEntity(
                                address: _addressController.text,
                                houseNumber: _houseNumberController.text,
                                comment: _commentController.text.isEmpty ? null : _commentController.text,
                                entrance: _entranceController.text.isEmpty ? null : _entranceController.text,
                                floor: _floorController.text.isEmpty ? null : _floorController.text,
                                intercom: _intercomController.text.isEmpty ? null : _intercomController.text,
                                kvOffice: _kvOfficeController.text.isEmpty ? null : _kvOfficeController.text,
                              );

                              final contactInfo = ContactInfoEntity(
                                userName: _userNameController.text,
                                userPhone: _userPhoneController.text,
                              );

                              final template = TemplateEntity(
                                id: widget.template?.id,
                                templateName: _templateNameController.text,
                                addressData: addressData,
                                contactInfo: contactInfo,
                              );

                              if (widget.template == null) {
                                context.read<TemplatesCubit>().saveTemplate(template);
                              } else {
                                context.read<TemplatesCubit>().updateTemplate(template);
                              }
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(widget.template == null ? 'Create Template' : 'Update Template'),
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
