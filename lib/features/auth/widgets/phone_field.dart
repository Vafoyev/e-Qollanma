import 'package:e_qollanma/core/utils/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;

  const PhoneField({
    super.key,
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:       controller,
      keyboardType:     TextInputType.phone,
      textInputAction:  textInputAction,
      onChanged:        onChanged,
      onEditingComplete: onEditingComplete,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12),
      ],
      decoration: InputDecoration(
        hintText:   'login_phone_hint'.tr(),
        prefixIcon: const Icon(Icons.phone_outlined),
        prefixText: '+',
      ),
      validator: AppValidators.phone,
    );
  }
}