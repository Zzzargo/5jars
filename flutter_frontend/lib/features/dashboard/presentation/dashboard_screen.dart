import 'package:five_jars_ultra/features/dashboard/dtos/create_jar_request.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_bloc.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_distribution_view.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_event.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_view.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/dialogs/create_jar_dialog.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/dashboard_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:five_jars_ultra/shared/adaptive_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScreen(desktop: _buildDesktop, mobile: _buildMobile);
  }

  Widget _buildDesktop(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: const Text(
          'My Jars',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () => _onNewJar(context),
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
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

  Widget _buildHeader(BuildContext context, {required bool isDesktop}) {
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
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Alex Doe',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isDesktop)
              ElevatedButton.icon(
                onPressed: () => _onNewJar(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
          ],
        ),
      ),
    );
  }
}
