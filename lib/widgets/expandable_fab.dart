import 'package:ewarung/common/styles.dart';
import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({Key? key}) : super(key: key);

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {
  bool _isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: primaryColor,
      end: colorRed,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!_isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isOpened = !_isOpened;
  }

  Widget addProduct() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _isOpened
          ? Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: textColorBlue,
                border: Border.all(color: textColorGrey),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                "Add Product",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            )
          : Container(),
        const FloatingActionButton(
          onPressed: null,
          tooltip: 'Add Product',
          child: Icon(Icons.add),
        ),
      ],
    );
  }

  Widget addStock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _isOpened
            ? Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: textColorBlue,
                  border: Border.all(color: textColorGrey),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  "Add Stock",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
              )
            : Container(),
        const FloatingActionButton(
          onPressed: null,
          tooltip: 'Add stock',
          child: Icon(Icons.note_add_outlined),
        ),
      ],
    );
  }

  Widget toggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          backgroundColor: _buttonColor.value,
          onPressed: animate,
          tooltip: _isOpened ? 'Close Menu' : 'Open Menu',
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animateIcon,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: addProduct(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: addStock(),
        ),
        toggle(),
      ],
    );
  }
}