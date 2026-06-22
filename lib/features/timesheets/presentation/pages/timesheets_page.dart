import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TimesheetsPage extends StatefulWidget {
  final String? userName;
  final String? role;

  const TimesheetsPage({
    super.key,
    this.userName,
    this.role,
  });

  @override
  State<TimesheetsPage> createState() => _TimesheetsPageState();
}

class _TimesheetsPageState extends State<TimesheetsPage> with SingleTickerProviderStateMixin {
  late String displayName;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    displayName = widget.userName ?? _getDefaultNameByRole();
    _tabController = TabController(length: 3, vsync: this);
  }

  String _getDefaultNameByRole() {
    switch (widget.role) {
      case 'teacher':
        return 'Fernando Santos';
      case 'supervisor':
        return 'Maria Reyes';
      case 'admin':
        return 'Admin User';
      default:
        return 'Natnat Garcia';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timesheets'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Current'),
            Tab(text: 'History'),
            Tab(text: 'Reports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Current timesheet tab
          Center(
            child: Text('Current Timesheet for $displayName'),
          ),
          // History tab
          Center(
            child: Text('Timesheet History for $displayName'),
          ),
          // Reports tab
          Center(
            child: Text('Timesheet Reports for $displayName'),
          ),
        ],
      ),
    );
  }
}
