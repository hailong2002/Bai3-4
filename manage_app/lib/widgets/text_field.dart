import 'package:flutter/material.dart';

final textInputEmail = InputDecoration(
  labelText: 'Email',
  hintStyle: const TextStyle(color: Colors.grey, fontSize: 25),
  prefixIcon: const Icon(Icons.email, color: Colors.grey),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(width: 2, color: Colors.orange)
  ),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(width: 2, color: Colors.black)
  ),
  errorBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(width: 2, color: Colors.red)
  ),
);

final textInputPassword = InputDecoration(
  labelText: 'Password',
  hintStyle: const TextStyle(color: Colors.grey, fontSize: 25),
  prefixIcon: const Icon(Icons.key, color: Colors.grey),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(width: 2, color: Colors.orange)
  ),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(width: 2, color: Colors.black)
  ),
  errorBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(width: 2, color: Colors.red)
  ),

);