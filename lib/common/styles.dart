import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color primaryColor = Color(0xFFFFFFFF);
final Color secondaryColor = Color(0xFF2FDD92);
final Color backgroundColor = Color(0xFFdcddde);

final TextTheme myTextTheme = TextTheme(
  headline4: GoogleFonts.rubik(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.25,
      color: Colors.white),
  headline5: GoogleFonts.rubik(fontSize: 23, fontWeight: FontWeight.bold),
  headline6: GoogleFonts.rubik(
      fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: GoogleFonts.rubik(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      color: Colors.black),
  subtitle2: GoogleFonts.rubik(
      fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.1),
  bodyText1: GoogleFonts.rubik(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.rubik(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Colors.white),
);
