import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_sec_kit/src/ui/l10n/sec_locale.dart';

/// Shows a progress bar that counts down from 30 seconds.
class CountDownProgress extends StatefulWidget {
  /// Creates a new instance of [CountDownProgress]
  const CountDownProgress({super.key});

  @override
  State<CountDownProgress> createState() => _CountDownProgressState();
}

class _CountDownProgressState extends State<CountDownProgress> {
  final _seconds = 30.0;

  late double _secondsLeft = _seconds;

  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), tick);
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double get _progress => _secondsLeft.clamp(0, _seconds) / _seconds;

  void tick(_) {
    if (mounted) {
      setState(() {
        _secondsLeft -= 0.1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LdAutoSpace(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FractionallySizedBox(
          widthFactor: 0.7,
          child: LinearProgressIndicator(
            value: _progress,
            borderRadius: LdTheme.of(context).radius(LdSize.s),
            backgroundColor: LdTheme.of(context).background,
            valueColor: AlwaysStoppedAnimation(
              LdTheme.of(context).primaryColor,
            ),
          ),
        ),
        LdMute(
          child: LdTextL(
            SecLocalizations.of(context).secondsLeft(
              _secondsLeft.toInt(),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
