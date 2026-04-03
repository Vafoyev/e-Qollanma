import 'package:e_qollanma/core/utils/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final String? hintText;

  const PasswordField({
    super.key,
    required this.controller,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.onEditingComplete,
    this.hintText,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:        widget.controller,
      obscureText:       _obscure,
      textInputAction:   widget.textInputAction,
      onChanged:         widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      decoration: InputDecoration(
        hintText:   widget.hintText ?? 'login_password_hint'.tr(),
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      validator: AppValidators.password,
    );
  }
}