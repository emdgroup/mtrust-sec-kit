import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_urp_ui/mtrust_urp_ui.dart';

/// ScanningInstruction is a widget that guides the user to the correct
/// scanning position.
class ScanningInstruction extends StatefulWidget {
  /// Creates a new instance of [ScanningInstruction]
  const ScanningInstruction({super.key});

  @override
  State<ScanningInstruction> createState() => _ScanningInstructionState();
}

class _ScanningInstructionState extends State<ScanningInstruction>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  @override
  void initState() {
    _startAnimation();
    super.initState();
  }

  Future<void> _startAnimation() async {
    if (urpUiDisableAnimations) {
      return;
    }
    if (!mounted) {
      return;
    }
    await _controller.forward();
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) {
      return;
    }
    await _controller.reverse();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      unawaited(_startAnimation());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LdTheme.of(context, listen: true);
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final value = CurvedAnimation(
              parent: _controller,
              curve: Curves.easeInOut,
            ).value;
            final color = Color.alphaBlend(
              theme.primaryColor.withAlpha((255 * value).toInt()),
              theme.errorColor,
            );
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 100 + (100 * value).toInt(),
                  child: Image.asset(
                    'assets/sec_reader_side.png',
                    package: 'mtrust_sec_kit',
                    alignment: Alignment.centerRight,
                    fit: BoxFit.fitHeight,
                    height: double.infinity,
                  ),
                ),
                ldSpacerS,
                Expanded(
                  flex: 200 - (50 * value).toInt(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container(
                            height: 16,
                            width: 2,
                            color: color,
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: color,
                            ),
                          ),
                          ldSpacerS,
                          Expanded(
                            flex: 2,
                            child: LdTextL(
                              '${(12 + 12 * (1 - value)).toStringAsFixed(2)}mm',
                              color: color,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                          ldSpacerS,
                          Expanded(
                            child: Container(
                              height: 2,
                              color: color,
                            ),
                          ),
                          Container(
                            height: 16,
                            width: 2,
                            color: color,
                          ),
                        ],
                      ),
                      Opacity(
                        opacity: (-1 + value * 2).clamp(0, 1),
                        child: const LdIndicator(type: LdIndicatorType.success),
                      ),
                    ],
                  ),
                ),
                ldSpacerS,
              ],
            );
          },
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.surface,
                  theme.surface.withAlpha(0),
                  theme.surface.withAlpha(0),
                  theme.surface,
                ],
                stops: const [0, 0.1, 0.9, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
