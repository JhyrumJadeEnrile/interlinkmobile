import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ApprovalPage extends StatefulWidget {
  final String? supervisorName;

  const ApprovalPage({
    super.key,
    this.supervisorName,
  });

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> with SingleTickerProviderStateMixin {
  late String supervisorName;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    supervisorName = widget.supervisorName ?? 'Maria Reyes';
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Timesheet Approvals'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pending timesheets tab
          Center(
            child: Text('Supervisor: $supervisorName - Pending Approvals'),
          ),
          // Approved timesheets tab
          Center(
            child: Text('Supervisor: $supervisorName - Approved Timesheets'),
          ),
        ],
      ),
    );
  }
}
