import 'package:creafton_financial_services/providers/borrower_statistics_provider.dart';
import 'package:creafton_financial_services/providers/expenditure_category_provider.dart';
import 'package:creafton_financial_services/providers/expenditure_provider.dart';
import 'package:creafton_financial_services/providers/field_officer_provider.dart';
import 'package:creafton_financial_services/providers/guarantor_provider.dart';
import 'package:creafton_financial_services/providers/loan_payment_details_provider.dart';
import 'package:creafton_financial_services/providers/loan_provider.dart';
import 'package:creafton_financial_services/providers/payment_provder.dart';
import 'package:creafton_financial_services/providers/payment_schedule_provider.dart';
import 'package:creafton_financial_services/providers/reports_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/borrower_provider.dart';
import 'providers/borrower_profile_provider.dart';

import 'screens/auth/login_screen.dart';

class CreaftonApp extends StatelessWidget {
  const CreaftonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BorrowerProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),

        ChangeNotifierProvider(create: (_) => BorrowerProfileProvider()),

        ChangeNotifierProvider(create: (_) => BorrowerStatisticsProvider()),

        // ChangeNotifierProvider(create: (_) => BorrowerProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),

        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => LoanPaymentDetailsProvider()),
        ChangeNotifierProvider(create: (_) => FieldOfficerProvider()),

        ChangeNotifierProvider(create: (_) => PaymentScheduleProvider()),
        ChangeNotifierProvider(create: (_) => GuarantorProvider()),
        ChangeNotifierProvider(create: (_) => ExpenditureCategoryProvider()),
        ChangeNotifierProvider(create: (_) => ExpenditureProvider()),
        // ChangeNotifierProvider(create: (_) => ReportsProvider()),

        // ChangeNotifierProvider(create: (_) => ExpenditureProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: "CREAFTON Financial Services",

        theme: ThemeData(useMaterial3: true, fontFamily: "Roboto"),

        home: const LoginScreen(),
      ),
    );
  }
}
