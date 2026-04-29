import 'package:five_jars_ultra/core/common/palette.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/desktop_dashboard_sidebar.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/jars_distribution_chart.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/widgets/jars_grid.dart';
import 'package:flutter/material.dart';
import 'package:five_jars_ultra/shared/adaptive_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScreen(desktop: _buildDesktop, mobile: _buildMobile);
  }

  Widget _buildDesktop(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      body: Row(
        children: [
          const DesktopDashboardSidebar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                _buildHeader(context, isDesktop: true),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: JarsDistributionChart(),
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.all(32),
                  sliver: JarsGrid(crossAxisCount: 3), // Desktop Grid
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
        backgroundColor: Palette.background,
        elevation: 0,
        title: const Text(
          'My Jars',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const Drawer(child: DesktopDashboardSidebar()),
      body: const CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: JarsDistributionChart(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: JarsGrid(crossAxisCount: 1), // Mobile List
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palette.primaryPurple,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {required bool isDesktop}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(color: Palette.textDim, fontSize: 16),
                ),
                Text(
                  'Alex Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isDesktop)
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primaryPurple,
                  foregroundColor: Colors.white,
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
