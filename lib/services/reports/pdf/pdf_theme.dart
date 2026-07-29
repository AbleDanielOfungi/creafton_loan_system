import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfTheme {
  PdfTheme._();

  //==========================================================
  // COLORS
  //==========================================================

  static const PdfColor primary = PdfColor.fromInt(0xFF1565C0);

  static const PdfColor secondary = PdfColor.fromInt(0xFF2E7D32);

  static const PdfColor danger = PdfColor.fromInt(0xFFC62828);

  static const PdfColor warning = PdfColor.fromInt(0xFFF9A825);

  static const PdfColor background = PdfColor.fromInt(0xFFF5F5F5);

  static const PdfColor tableHeader = PdfColor.fromInt(0xFFE3F2FD);

  static const PdfColor border = PdfColor.fromInt(0xFFBDBDBD);

  static const PdfColor text = PdfColors.black;

  static const PdfColor grey = PdfColors.grey700;

  //==========================================================
  // PAGE
  //==========================================================

  static const PdfPageFormat pageFormat = PdfPageFormat.a4;

  static const double margin = 25;

  //==========================================================
  // TEXT STYLES
  //==========================================================

  static pw.TextStyle get title => pw.TextStyle(
        fontSize: 26,
        fontWeight: pw.FontWeight.bold,
        color: primary,
      );

  static pw.TextStyle get heading => pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
        color: primary,
      );

  static pw.TextStyle get subHeading => pw.TextStyle(
        fontSize: 14,
        fontWeight: pw.FontWeight.bold,
      );

  static pw.TextStyle get body => pw.TextStyle(
        fontSize: 11,
      );

  static pw.TextStyle get small => pw.TextStyle(
        fontSize: 9,
        color: grey,
      );

  static pw.TextStyle get tableHeaderStyle => pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      );

  static pw.TextStyle get tableCellStyle => pw.TextStyle(
        fontSize: 9,
      );

  static pw.TextStyle get kpiValue => pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
        color: secondary,
      );

  static pw.TextStyle get dangerValue => pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
        color: danger,
      );

  //==========================================================
  // DECORATIONS
  //==========================================================

  static pw.BoxDecoration get cardDecoration => pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(
          color: border,
          width: 0.6,
        ),
        borderRadius: pw.BorderRadius.circular(6),
      );

  static pw.BoxDecoration get headerDecoration => pw.BoxDecoration(
        color: primary,
      );

  static pw.BoxDecoration get tableHeaderDecoration => pw.BoxDecoration(
        color: primary,
      );

  static pw.BoxDecoration get greyCard => pw.BoxDecoration(
        color: background,
        borderRadius: pw.BorderRadius.circular(6),
      );

  //==========================================================
  // TABLE BORDER
  //==========================================================

  static pw.TableBorder get tableBorder => pw.TableBorder.all(
        color: border,
        width: .5,
      );

  //==========================================================
  // SPACING
  //==========================================================

  static const double xs = 4;

  static const double sm = 8;

  static const double md = 12;

  static const double lg = 18;

  static const double xl = 24;

  static const double xxl = 32;
}