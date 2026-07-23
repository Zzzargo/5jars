import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_state.dart';
import 'package:five_jars_ultra/features/dashboard/dtos/create_jar_request.dart';
import 'package:five_jars_ultra/features/dashboard/dtos/money_op_request.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_bloc.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_distribution_view.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_event.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_view.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/dashboard_sidebar.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/dialogs/create_jar_dialog.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/dialogs/distribute_income_dialog.dart';
import 'package:five_jars_ultra/shared/adaptive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScreen(desktop: _buildDesktop, mobile: _buildMobile);
  }

  Widget _buildDesktop(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: Row(
        children: [
          const DashboardSidebar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                _buildHeader(context, isDesktop: true),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: JarsDistributionView(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(32),
                  sliver: JarsView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: const Text(
          'My Jars',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Distribute income',
            onPressed: () => _onDistributeIncome(context),
            icon: Icon(Icons.payments, color: cs.primary),
          ),
        ],
      ),
      drawer: const Drawer(child: DashboardSidebar(isDrawer: true)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: JarsDistributionView(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: JarsView(), // Mobile List
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: cs.primary,
        onPressed: () => _onNewJar(context),
        child: Icon(Icons.add, color: cs.onPrimary),
      ),
    );
  }

  void _onNewJar(BuildContext context) async {
    final CreateJarRequest? request = await showDialog<CreateJarRequest>(
      context: context,
      builder: (context) => const CreateJarDialog(),
    );

    // If the user didn't cancel and the request is valid
    if (request != null && context.mounted) {
      context.read<JarsBloc>().add(NewJarRequested(request));
    }
  }

  void _onDistributeIncome(BuildContext context) async {
    final MoneyOpRequest? request = await showDialog<MoneyOpRequest>(
      context: context,
      builder: (context) => const DistributeIncomeDialog(),
    );

    // If the user didn't cancel and the request is valid
    if (request != null && context.mounted) {
      context.read<JarsBloc>().add(DistributeIncomeRequested(request));
    }
  }

  Widget _buildHeader(BuildContext context, {required bool isDesktop}) {
    final state = context.watch<AuthSessionBloc>().state;
    final String? uname = switch (state) {
      AuthSessionAuthenticated(:final user) => user.username,
      _ => null,
    };

    final cs = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 16),
                ),
                Text(
                  uname ?? 'Unknown User',
                  style: TextStyle(
                    color: cs.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isDesktop)
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _onNewJar(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Jar'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => _onDistributeIncome(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.payments),
                    label: const Text('Distribute Income'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
