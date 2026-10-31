import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const new({
    super.key,
    required this.onChanged,
    required this.hint,
  });

  final ValueChanged<String> onChanged;
  final String hint;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          onChanged: widget.onChanged,
          obscureText: !_show,
          decoration: InputDecoration(
            hintText: widget.hint,
          ),
        ),
        Align(
          alignment: .centerRight,
          child: IconButton(
            onPressed: () => setState(() => _show = !_show),
            icon: Icon(
              _show ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            ),
          ),
        ),
      ],
    );
  }
}
