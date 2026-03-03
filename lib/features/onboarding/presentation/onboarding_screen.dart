import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibemental_app/core/config/app_routes.dart';
import 'package:vibemental_app/core/settings/onboarding_controller.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  /// Purpose: Render multi-step onboarding with overflow-safe page content.
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = [
      _OnboardingData(title: l10n.onboardingTitle1, body: l10n.onboardingBody1),
      _OnboardingData(title: l10n.onboardingTitle2, body: l10n.onboardingBody2),
      _OnboardingData(title: l10n.onboardingTitle3, body: l10n.onboardingBody3),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${l10n.onboardingLabel} ${_index + 1}/3',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          TextButton(onPressed: _finish, child: Text(l10n.onboardingSkip)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (next) => setState(() => _index = next),
                itemCount: pages.length,
                itemBuilder: (context, i) {
                  final data = pages[i];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              data.body,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _index == i ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _index == i
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (_index == pages.length - 1) {
                    _finish();
                    return;
                  }
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOut,
                  );
                },
                child: Text(
                  _index == pages.length - 1
                      ? l10n.onboardingGetStarted
                      : l10n.onboardingNext,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Purpose: Persist onboarding completion and route to the home flow.
  Future<void> _finish() async {
    await ref.read(onboardingControllerProvider.notifier).markCompleted();
    if (!mounted) {
      return;
    }
    context.go(AppRoutes.home);
  }
}

class _OnboardingData {
  const _OnboardingData({required this.title, required this.body});

  final String title;
  final String body;
}
