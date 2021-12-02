import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ewarung/common/styles.dart';
import 'package:ewarung/provider/cart_provider.dart';
import 'package:ewarung/ui/cart_page.dart';
import 'package:ewarung/ui/home_page.dart';
import 'package:ewarung/ui/list_page.dart';
import 'package:ewarung/ui/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main';

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>  with SingleTickerProviderStateMixin {
  int _bottomNavIndex = 0;
  final autoSizeGroup = AutoSizeGroup();
  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;

  final List<IconData> _listIcon = [
    Icons.home_outlined,
    Icons.text_snippet_outlined,
    Icons.shopping_cart_outlined,
    Icons.account_circle_outlined,
  ];

  final List<Widget> _listWidget = [
    const HomePage(),
    const ListPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  final List<String> _listMenu = [
    "Home",
    "List",
    "Cart",
    "Profile",
  ];

  @override
  void initState() {
    super.initState();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: textColorWhite,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      const Duration(milliseconds: 500),
          () => _animationController.forward(),
    );
  }

  Future<void> scanBarcodeNormal(CartProvider pref) async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    if (barcodeScanRes != "-1") {
      setState(() {
        pref.addResultBarcode(barcodeScanRes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _bottomNav();
  }

  Widget _bottomNav() {
    CartProvider pref = Provider.of<CartProvider>(context);

    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      backgroundColor: colorWhiteBlue,
      floatingActionButton: ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          elevation: 8,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(41)),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [colorLinearStart, colorLinearEnd],
              ),
            ),
            child: const Icon(
              Icons.crop_free,
              color: textColorWhite,
            ),
          ),
          onPressed: () {
            scanBarcodeNormal(pref);
            _animationController.reset();
            _animationController.forward();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        backgroundColor: textColorWhite,
        itemCount: _listIcon.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? colorMenu : textFieldColorGrey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _listIcon[index],
                size: 24,
                color: color,
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AutoSizeText(
                  _listMenu[index],
                  maxLines: 1,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: color, fontSize: 12.0),
                  group: autoSizeGroup,
                ),
              ),
            ],
          );
        },
        splashColor: primaryColor,
        notchAndCornersAnimation: animation,
        splashSpeedInMilliseconds: 300,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        rightCornerRadius: 10,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}