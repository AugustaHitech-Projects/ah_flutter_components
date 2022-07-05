library loading_button;

import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';


enum ButtonState { idle, loading, success, error }

class LoadingButton extends StatefulWidget {
  final RoundedLoadingButtonController controller;
  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final double height;
  final double width;
  final double loaderSize;
  final double loaderStrokeWidth;
  final bool animateOnTap;
  final Color valueColor;
  final bool resetAfterDuration;
  final Curve curve;
  final double borderRadius;
  final Duration duration;
  final double elevation;
  final Duration resetDuration;
  final Color? errorColor;
  final Color? successColor;
  final Color? disabledColor;
  final IconData successIcon;
  final IconData failedIcon;
  final Curve completionCurve;
  final Duration completionDuration;

  Duration get _borderDuration {
    return Duration(milliseconds: (duration.inMilliseconds / 2).round());
  }

  const LoadingButton({
    Key? key,
    required this.controller,
    required this.onPressed,
    required this.child,
    this.color = Colors.lightBlue,
    this.height = 50,
    this.width = 300,
    this.loaderSize = 24.0,
    this.loaderStrokeWidth = 2.0,
    this.animateOnTap = true,
    this.valueColor = Colors.white,
    this.borderRadius = 35,
    this.elevation = 2,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOutCirc,
    this.errorColor = Colors.red,
    this.successColor,
    this.resetDuration = const Duration(seconds: 15),
    this.resetAfterDuration = false,
    this.successIcon = Icons.check,
    this.failedIcon = Icons.close,
    this.completionCurve = Curves.elasticOut,
    this.completionDuration = const Duration(milliseconds: 1000),
    this.disabledColor,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton>
    with TickerProviderStateMixin {
  late AnimationController _buttonController;
  late AnimationController _borderController;
  late AnimationController _checkButtonControler;

  late Animation<double> _squeezeAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<BorderRadius?> _borderAnimation;

  final BehaviorSubject<ButtonState> _state =
  BehaviorSubject<ButtonState>.seeded(ButtonState.idle);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Widget check = Container(
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: widget.successColor ?? theme.primaryColor,
        borderRadius:
        BorderRadius.all(Radius.circular(_bounceAnimation.value / 2)),
      ),
      width: _bounceAnimation.value,
      height: _bounceAnimation.value,
      child: _bounceAnimation.value > 20
          ? Icon(
        widget.successIcon,
        color: widget.valueColor,
      )
          : null,
    );

    Widget cross = Container(
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: widget.errorColor,
        borderRadius:
        BorderRadius.all(Radius.circular(_bounceAnimation.value / 2)),
      ),
      width: _bounceAnimation.value,
      height: _bounceAnimation.value,
      child: _bounceAnimation.value > 20
          ? Icon(
        widget.failedIcon,
        color: widget.valueColor,
      )
          : null,
    );

    Widget loader = SizedBox(
      height: widget.loaderSize,
      width: widget.loaderSize,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(widget.valueColor),
        strokeWidth: widget.loaderStrokeWidth,
      ),
    );

    Widget childStream = StreamBuilder<ButtonState>(
      stream: _state,
      builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: snapshot.data == ButtonState.loading ? loader : widget.child,
        );
      },
    );

    final ButtonTheme btn = ButtonTheme(
      shape: RoundedRectangleBorder(
          borderRadius: _borderAnimation.value ??
              BorderRadius.circular(widget.borderRadius)),
      disabledColor: widget.disabledColor,
      padding: const EdgeInsets.all(0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onSurface: widget.disabledColor,
          minimumSize: Size(_squeezeAnimation.value, widget.height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          primary: widget.color,
          elevation: widget.elevation,
          padding: const EdgeInsets.all(0),
        ),
        onPressed: widget.onPressed == null ? null : _btnPressed,
        child: childStream,
      ),
    );

    return SizedBox(
      height: widget.height,
      child: Center(
        child: _state.value == ButtonState.error
            ? cross
            : _state.value == ButtonState.success
            ? check
            : btn,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _buttonController =
        AnimationController(duration: widget.duration, vsync: this);

    _checkButtonControler =
        AnimationController(duration: widget.completionDuration, vsync: this);

    _borderController =
        AnimationController(duration: widget._borderDuration, vsync: this);

    _bounceAnimation = Tween<double>(begin: 0, end: widget.height).animate(
      CurvedAnimation(
        parent: _checkButtonControler,
        curve: widget.completionCurve,
      ),
    );
    _bounceAnimation.addListener(() {
      setState(() {});
    });

    _squeezeAnimation =
        Tween<double>(begin: widget.width, end: widget.height).animate(
          CurvedAnimation(parent: _buttonController, curve: widget.curve),
        );

    _squeezeAnimation.addListener(() {
      setState(() {});
    });

    _squeezeAnimation.addStatusListener((AnimationStatus state) {
      if (state == AnimationStatus.completed && widget.animateOnTap) {
        widget.onPressed?.call();
      }
    });


    _borderAnimation = BorderRadiusTween(
      begin: BorderRadius.circular(widget.borderRadius),
      end: BorderRadius.circular(widget.height),
    ).animate(_borderController);

    _borderAnimation.addListener(() {
      setState(() {});
    });

    // There is probably a better way of doing this...
    _state.stream.listen((ButtonState event) {
      if (!mounted) {
        return;
      }
      widget.controller._state.sink.add(event);
    });

    widget.controller._addListeners(_start, _stop, _success, _error, _reset);
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _checkButtonControler.dispose();
    _borderController.dispose();
    _state.close();
    super.dispose();
  }

  void _btnPressed() {
    if (widget.animateOnTap) {
      _start();
    } else {
      widget.onPressed?.call();
    }
  }

  void _start() {
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.loading);
    _borderController.forward();
    _buttonController.forward();
    if (widget.resetAfterDuration) {
      _reset();
    }
  }

  void _stop() {
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.idle);
    _buttonController.reverse();
    _borderController.reverse();
  }

  void _success() {
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.success);
    _checkButtonControler.forward();
  }

  void _error() {
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.error);
    _checkButtonControler.forward();
  }

  Future<void> _reset() async {
    if (widget.resetAfterDuration) {
      await Future<void>.delayed(widget.resetDuration);
    }
    if (!mounted) {
      return;
    }
    _state.sink.add(ButtonState.idle);
    unawaited(_buttonController.reverse());
    unawaited(_borderController.reverse());
    _checkButtonControler.reset();
  }
}

class RoundedLoadingButtonController {
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
