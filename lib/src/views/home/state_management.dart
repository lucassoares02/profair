import 'package:profair/src/components/progress_indicator.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StateManagement extends StatefulWidget {
  const StateManagement({
    Key? key,
    required this.width,
    required this.component,
    this.widgetLoading,
    required this.listenable,
  }) : super(key: key);

  final double width;
  final Widget component;
  final Widget? widgetLoading;
  final ValueListenable listenable;

  @override
  State<StateManagement> createState() => _StateManagementState();
}

class _StateManagementState extends State<StateManagement> {
  _start() {
    return Container(
      padding: const EdgeInsets.all(appPadding),
      child: const Text('Não possui dados'),
    );
  }

  _error() {
    return const Text('error');
  }

  _loading() {
    return widget.widgetLoading ??
        Container(
          padding: const EdgeInsets.all(appPadding),
          child: AppProgressIndicator(),
        );
  }

  _success() {
    return widget.component;
  }

  stateManagement(StateApp state) {
    switch (state) {
      case StateApp.start:
        return _start();
      case StateApp.success:
        return _success();
      case StateApp.error:
        return _error();
      case StateApp.loading:
        return _loading();
      default:
        return _start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.listenable,
      builder: ((context, value) {
        return stateManagement(widget.listenable.value);
      }),
    );
  }
}
