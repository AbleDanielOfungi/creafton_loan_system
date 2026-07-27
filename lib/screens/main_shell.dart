import 'package:creafton_financial_services/screens/expenditures/expenditure_screen.dart';
import 'package:creafton_financial_services/screens/field%20offficers/field_officers_screen.dart';
import 'package:creafton_financial_services/screens/guarantors/main_guarantor_screen.dart';
import 'package:creafton_financial_services/screens/reports/expenditure_reports_screen.dart';
// import 'package:creafton_financial_services/screens/guarantors/main_guarantors_screen.dart';
import 'package:flutter/material.dart';

import '../screens/dashboard/dashboard_screen.dart';
import '../screens/borrowers/borrowers_screen.dart';

import '../widgets/sidebar.dart';
import '../widgets/top_bar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  bool collapsed = false;

  Widget _selectedPage = const DashboardScreen();

  void changePage(String menu) {
    setState(() {
      switch (menu) {
        case "Dashboard":
          _selectedPage = const DashboardScreen();

          break;

        case "Borrowers":
          _selectedPage = const BorrowersScreen();

          break;

        case "Field Officers":
          // _selectedPage = const Center(child: Text("Field Officers Module"));
          _selectedPage = const FieldOfficersScreen();

          break;

        case "Guarantors":
          _selectedPage = const GuarantorsScreen();

          break;

        // case "Loans":
        // _selectedPage = const Center(child: Text("Loans Module"));

        // break;

        case "Expenditures":
          _selectedPage = ExpendituresScreen();

          break;

        case "Expenditures Reports":
          _selectedPage = ExpenditureReportsScreen();

          break;

        case "Reports":
          _selectedPage = const Center(child: Text("Reports Module"));

          break;

        case "Settings":
          _selectedPage = const Center(child: Text("Settings Module"));

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            collapsed: collapsed,

            onToggle: () {
              setState(() {
                collapsed = !collapsed;
              });
            },

            onMenuSelected: changePage,
          ),

          Expanded(
            child: Column(
              children: [
                const TopBar(),

                Expanded(child: _selectedPage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
