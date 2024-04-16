import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final Function(String) onChanged;
  const MySearchBar({required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xffB2B2B2),
        ),
        hintText: 'Search Restaurant',
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xffB2B2B2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xffB2B2B2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xffB2B2B2),
            width: 2,
          ),
        ),
      ),
    );
  }
}
