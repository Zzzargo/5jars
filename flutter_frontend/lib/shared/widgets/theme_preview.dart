import 'package:five_jars_ultra/shared/app_theme.dart';
import 'package:five_jars_ultra/shared/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(group: 'Theme')
Widget themePreview() => const _ThemePreview();

class _ThemePreview extends StatelessWidget {
  const _ThemePreview();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Theme Preview')),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Section(title: 'Color Palette', child: _ColorPalettePreview()),
                _Section(title: 'Typography', child: _TypographyPreview()),
                _Section(title: 'Buttons', child: _ButtonsPreview()),
                _Section(title: 'Input Fields', child: _InputsPreview()),
                _Section(title: 'Cards', child: _CardsPreview()),
                _Section(title: 'Chips', child: _ChipsPreview()),
                _Section(
                  title: 'Semantic Colors',
                  child: _SemanticColorsPreview(),
                ),
                _Section(title: 'Components', child: _ComponentsPreview()),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Section wrapper
// ─────────────────────────────────────────────
class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Divider(color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Color Palette
// ─────────────────────────────────────────────
class _ColorPalettePreview extends StatelessWidget {
  const _ColorPalettePreview();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final pairs = [
      ('primary', cs.primary, cs.onPrimary, 'onPrimary'),
      (
        'primaryContainer',
        cs.primaryContainer,
        cs.onPrimaryContainer,
        'onPrimaryContainer',
      ),
      ('secondary', cs.secondary, cs.onSecondary, 'onSecondary'),
      (
        'secondaryContainer',
        cs.secondaryContainer,
        cs.onSecondaryContainer,
        'onSecondaryContainer',
      ),
      ('surface', cs.surface, cs.onSurface, 'onSurface'),
      (
        'surfaceContainerHighest',
        cs.surfaceContainerHighest,
        cs.onSurfaceVariant,
        'onSurfaceVariant',
      ),
      ('error', cs.error, cs.onError, 'onError'),
      (
        'errorContainer',
        cs.errorContainer,
        cs.onErrorContainer,
        'onErrorContainer',
      ),
      (
        'inverseSurface',
        cs.inverseSurface,
        cs.onInverseSurface,
        'onInverseSurface',
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: pairs.map((p) {
        final (bgLabel, bg, fg, fgLabel) = p;
        return Container(
          width: 200,
          height: 72,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cs.outline.withAlpha(60)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$bgLabel (Container color)',
                style: TextStyle(
                  color: fg,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$fgLabel (Text color)',
                style: TextStyle(color: fg, fontSize: 10),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
//  Typography
// ─────────────────────────────────────────────
class _TypographyPreview extends StatelessWidget {
  const _TypographyPreview();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final styles = [
      (
        'displayLarge',
        tt.displayLarge,
        'Display Large — ${tt.displayLarge?.fontSize}px w${tt.displayLarge?.fontWeight?.value} h${tt.displayLarge?.height} spacing=${tt.displayLarge?.letterSpacing}',
      ),
      (
        'displayMedium',
        tt.displayMedium,
        'Display Medium — ${tt.displayMedium?.fontSize}px w${tt.displayMedium?.fontWeight?.value} h${tt.displayMedium?.height} spacing=${tt.displayMedium?.letterSpacing}',
      ),
      (
        'displaySmall',
        tt.displaySmall,
        'Display Small — ${tt.displaySmall?.fontSize}px w${tt.displaySmall?.fontWeight?.value} h${tt.displaySmall?.height} spacing=${tt.displaySmall?.letterSpacing}',
      ),
      (
        'headlineLarge',
        tt.headlineLarge,
        'Headline Large — ${tt.headlineLarge?.fontSize}px w${tt.headlineLarge?.fontWeight?.value} h${tt.headlineLarge?.height} spacing=${tt.headlineLarge?.letterSpacing}',
      ),
      (
        'headlineMedium',
        tt.headlineMedium,
        'Headline Medium — ${tt.headlineMedium?.fontSize}px w${tt.headlineMedium?.fontWeight?.value} h${tt.headlineMedium?.height} spacing=${tt.headlineMedium?.letterSpacing}',
      ),
      (
        'headlineSmall',
        tt.headlineSmall,
        'Headline Small — ${tt.headlineSmall?.fontSize}px w${tt.headlineSmall?.fontWeight?.value} h${tt.headlineSmall?.height} spacing=${tt.headlineSmall?.letterSpacing}',
      ),
      (
        'titleLarge',
        tt.titleLarge,
        'Title Large — ${tt.titleLarge?.fontSize}px w${tt.titleLarge?.fontWeight?.value} h${tt.titleLarge?.height} spacing=${tt.titleLarge?.letterSpacing}',
      ),
      (
        'titleMedium',
        tt.titleMedium,
        'Title Medium — ${tt.titleMedium?.fontSize}px w${tt.titleMedium?.fontWeight?.value} h${tt.titleMedium?.height} spacing=${tt.titleMedium?.letterSpacing}',
      ),
      (
        'titleSmall',
        tt.titleSmall,
        'Title Small — ${tt.titleSmall?.fontSize}px w${tt.titleSmall?.fontWeight?.value} h${tt.titleSmall?.height} spacing=${tt.titleSmall?.letterSpacing}',
      ),
      (
        'bodyLarge',
        tt.bodyLarge,
        'Body Large — ${tt.bodyLarge?.fontSize}px w${tt.bodyLarge?.fontWeight?.value} h${tt.bodyLarge?.height} spacing=${tt.bodyLarge?.letterSpacing}',
      ),
      (
        'bodyMedium',
        tt.bodyMedium,
        'Body Medium — ${tt.bodyMedium?.fontSize}px w${tt.bodyMedium?.fontWeight?.value} h${tt.bodyMedium?.height} spacing=${tt.bodyMedium?.letterSpacing}',
      ),
      (
        'bodySmall',
        tt.bodySmall,
        'Body Small — ${tt.bodySmall?.fontSize}px w${tt.bodySmall?.fontWeight?.value} h${tt.bodySmall?.height} spacing=${tt.bodySmall?.letterSpacing}',
      ),
      (
        'labelLarge',
        tt.labelLarge,
        'Label Large — ${tt.labelLarge?.fontSize}px w${tt.labelLarge?.fontWeight?.value} h${tt.labelLarge?.height} spacing=${tt.labelLarge?.letterSpacing}',
      ),
      (
        'labelMedium',
        tt.labelMedium,
        'Label Medium — ${tt.labelMedium?.fontSize}px w${tt.labelMedium?.fontWeight?.value} h${tt.labelMedium?.height} spacing=${tt.labelMedium?.letterSpacing}',
      ),
      (
        'labelSmall',
        tt.labelSmall,
        'Label Small — ${tt.labelSmall?.fontSize}px w${tt.labelSmall?.fontWeight?.value} h${tt.labelSmall?.height} spacing=${tt.labelSmall?.letterSpacing}',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: styles.map((s) {
        final (name, style, sample) = s;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: 180,
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              Expanded(child: Text(sample, style: style)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
//  Buttons
// ─────────────────────────────────────────────
class _ButtonsPreview extends StatelessWidget {
  const _ButtonsPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PreviewRow(
          label: 'ElevatedButton',
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Primary')),
            ElevatedButton(onPressed: null, child: const Text('Disabled')),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('With Icon'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _PreviewRow(
          label: 'TextButton',
          children: [
            TextButton(onPressed: () {}, child: const Text('Text Button')),
            TextButton(onPressed: null, child: const Text('Disabled')),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info_outline, size: 18),
              label: const Text('With Icon'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _PreviewRow(
          label: 'OutlinedButton',
          children: [
            OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
            OutlinedButton(onPressed: null, child: const Text('Disabled')),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('With Icon'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _PreviewRow(
          label: 'IconButton',
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_outline),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share_outlined),
            ),
            IconButton.filled(onPressed: () {}, icon: const Icon(Icons.add)),
            IconButton.filledTonal(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_outline),
            ),
            IconButton.outlined(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Input Fields
// ─────────────────────────────────────────────
class _InputsPreview extends StatelessWidget {
  const _InputsPreview();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your username',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Error state',
            errorText: 'This field is required',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Disabled field',
            hintText: 'Not editable',
            prefixIcon: Icon(Icons.block_outlined),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Cards
// ─────────────────────────────────────────────
class _CardsPreview extends StatelessWidget {
  const _CardsPreview();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: cs.primary,
                    ),
                    const SizedBox(width: 12),
                    Text('Necessities Jar', style: tt.titleMedium),
                    const Spacer(),
                    Chip(label: Text('55%', style: tt.labelSmall)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '\$2,750.00',
                  style: tt.headlineMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'of \$5,000.00 budget',
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: 0.55,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ListTile(
                  tileColor: cs.primaryContainer,
                  leading: CircleAvatar(
                    backgroundColor: cs.secondaryContainer,
                    child: Icon(
                      Icons.restaurant_outlined,
                      color: cs.onSecondaryContainer,
                      size: 20,
                    ),
                  ),
                  title: const Text('Food & Dining'),
                  subtitle: const Text('Yesterday at 7:30 PM'),
                  trailing: Text(
                    '-\$42.50',
                    style: tt.bodyLarge?.copyWith(color: Palette.error),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  tileColor: cs.primaryContainer,
                  leading: CircleAvatar(
                    backgroundColor: cs.secondaryContainer,
                    child: Icon(
                      Icons.work_outline,
                      color: cs.onSecondaryContainer,
                      size: 20,
                    ),
                  ),
                  title: const Text('Salary Deposit'),
                  subtitle: const Text('Monday at 9:00 AM'),
                  trailing: Text(
                    '+\$3,200.00',
                    style: tt.bodyLarge?.copyWith(color: Palette.success),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Chips
// ─────────────────────────────────────────────
class _ChipsPreview extends StatelessWidget {
  const _ChipsPreview();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        const Chip(label: Text('Default chip')),
        Chip(
          label: const Text('With icon'),
          avatar: Icon(
            Icons.star_outline,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Chip(
          label: Text('Deletable'),
          onDeleted: null,
          deleteIcon: Icon(Icons.close, size: 14),
        ),
        FilterChip(
          label: const Text('Filter'),
          onSelected: (_) {},
          selected: false,
        ),
        FilterChip(
          label: const Text('Selected'),
          onSelected: (_) {},
          selected: true,
        ),
        ActionChip(
          label: const Text('Action'),
          onPressed: () {},
          avatar: const Icon(Icons.flash_on_outlined, size: 16),
        ),
        ChoiceChip(
          label: const Text('Choice'),
          selected: true,
          onSelected: (_) {},
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Semantic Colors
// ─────────────────────────────────────────────
class _SemanticColorsPreview extends StatelessWidget {
  const _SemanticColorsPreview();

  @override
  Widget build(BuildContext context) {
    final semantics = [
      (
        'Success',
        Palette.success,
        Palette.successLight,
        Icons.check_circle_outline,
      ),
      ('Error', Palette.error, Palette.errorLight, Icons.error_outline),
      (
        'Warning',
        Palette.warning,
        Palette.warningLight,
        Icons.warning_amber_outlined,
      ),
      ('Info', Palette.info, Palette.infoLight, Icons.info_outline),
    ];

    return Column(
      children: semantics.map((s) {
        final (label, color, bg, icon) = s;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withAlpha(80)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$label: This is a $label state message.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: color),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
//  Components
// ─────────────────────────────────────────────
class _ComponentsPreview extends StatelessWidget {
  const _ComponentsPreview();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PreviewRow(
          label: 'Switch',
          children: [
            Switch(value: true, onChanged: (_) {}),
            Switch(value: false, onChanged: (_) {}),
            Switch(value: true, onChanged: null),
          ],
        ),
        const SizedBox(height: 16),
        _PreviewRow(
          label: 'Checkbox',
          children: [
            Checkbox(value: true, onChanged: (_) {}),
            Checkbox(value: false, onChanged: (_) {}),
            Checkbox(value: null, tristate: true, onChanged: (_) {}),
            Checkbox(value: true, onChanged: null),
          ],
        ),
        const SizedBox(height: 16),
        _PreviewRow(
          label: 'Progress',
          children: [
            const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(),
            ),
            const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(value: 0.7),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const LinearProgressIndicator(),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: 0.65,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 16),
        const _PreviewRow(label: 'Divider', children: []),
        const Divider(),
        const SizedBox(height: 8),
        _PreviewRow(
          label: 'Badges',
          children: [
            Badge(
              label: const Text('3'),
              child: const Icon(Icons.notifications_outlined),
            ),
            Badge(
              label: const Text('99+'),
              child: const Icon(Icons.mail_outline),
            ),
            const Badge(child: Icon(Icons.circle_notifications_outlined)),
          ],
        ),
        const SizedBox(height: 16),
        _PreviewRow(
          label: 'Tooltip',
          children: [
            Tooltip(
              message: 'This is a themed tooltip',
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Hover me'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _PreviewRow(label: 'Surfaces', children: []),
        const SizedBox(height: 8),
        Row(
          children:
              [
                ('Lowest', cs.surfaceContainerLowest),
                ('Low', cs.surfaceContainerLow),
                ('Container', cs.surfaceContainer),
                ('High', cs.surfaceContainerHigh),
                ('Highest', cs.surfaceContainerHighest),
              ].map((pair) {
                final (label, color) = pair;
                return Expanded(
                  child: Container(
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: cs.outline.withAlpha(40)),
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 9,
                          color: cs.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Helper: labeled row of widgets
// ─────────────────────────────────────────────
class _PreviewRow extends StatelessWidget {
  final String label;
  final List<Widget> children;

  const _PreviewRow({required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ...children.map(
          (c) => Padding(padding: const EdgeInsets.only(right: 12), child: c),
        ),
      ],
    );
  }
}
