library loading_button;

import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

enum ButtonState { idle, loading, success, error }

class LoadingButton extends StatefulWidget {
  final LoadingButtonController? controller;
  final VoidCallback? onPressed;
  final Widget child;
  final Color color;
  final Color valueColor;
  final double height;
  final double borderRadius;

  const LoadingButton({
    Key? key,
    this.controller,
    this.onPressed,
    this.borderRadius = 35,
    required this.child,
    this.color = Colors.blue,
    this.valueColor = Colors.white,
    this.height = 50,
  }) : super(key: key);

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  final BehaviorSubject<ButtonState> _state =
      BehaviorSubject<ButtonState>.seeded(ButtonState.idle);

  @override
  void dispose() {
    _state.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _state.stream.listen((ButtonState event) {
      if (!mounted) {
        return;
      }
      widget.controller?._state.sink.add(event);
    });

    widget.controller?._addListeners(_start, _stop, _success, _error, _reset);
  }

  @override
  Widget build(BuildContext context) {
    Widget childStream = StreamBuilder<ButtonState>(
      stream: _state,
      builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
        return snapshot.data == ButtonState.loading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(widget.valueColor),
              )
            : widget.child;
      },
    );

    final ButtonTheme btn = ButtonTheme(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius)),
      padding: const EdgeInsets.all(0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, widget.height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          primary: widget.color,
          elevation: 2,
          padding: const EdgeInsets.all(0),
        ),
        onPressed: widget.onPressed,
        child: childStream,
      ),
    );

    return SizedBox(
      height: widget.height,
      child: Center(
        child: btn,
      ),
    );
  }

  void _start() {
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.loading);
  }

  void _stop() {
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.idle);
  }

  void _success() {
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.success);
  }

  void _error() {
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.error);
  }

  Future<void> _reset() async {
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.idle);
  }
}

class LoadingButtonController {
  VoidCallback? _startListener;
  VoidCallback? _stopListener;
  VoidCallback? _successListener;
  VoidCallback? _errorListener;
  VoidCallback? _resetListener;

  void _addListeners(
    VoidCallback startListener,
    VoidCallback stopListener,
    VoidCallback successListener,
    VoidCallback errorListener,
    VoidCallback resetListener,
  ) {
    _startListener = startListener;
    _stopListener = stopListener;
    _successListener = successListener;
    _errorListener = errorListener;
    _resetListener = resetListener;
  }

  final BehaviorSubject<ButtonState> _state =
      BehaviorSubject<ButtonState>.seeded(ButtonState.idle);

  void dispose() {
    _state.close();
  }

  Stream<ButtonState> get stateStream => _state.stream;

  ButtonState? get currentState => _state.value;

  void start() {
    _startListener?.call();
  }

  void stop() {
    _stopListener?.call();
  }

  void success() {
    _successListener?.call();
  }

  void error() {
    _errorListener?.call();
  }

  void reset() {
    _resetListener?.call();
  }
}
