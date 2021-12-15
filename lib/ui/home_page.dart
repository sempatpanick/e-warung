import 'package:auto_size_text/auto_size_text.dart';
import 'package:ewarung/common/styles.dart';
import 'package:ewarung/data/model/menu_item.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:ewarung/provider/utils_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PreferencesProvider pref = Provider.of<PreferencesProvider>(context);
    UtilsProvider utilsProvider = Provider.of<UtilsProvider>(context);

    return Scaffold(
        backgroundColor: colorWhiteBlue,
        body: _buildHome(pref, utilsProvider)
    );
  }

  Widget _buildHome(PreferencesProvider pref, UtilsProvider utilsProvider) {
    MenuItem itemAddProduct = MenuItem(
        title: "Add Product",
        subtitle: "add your new product",
        event: "",
        icon: Icons.library_add_outlined,
        click: () {
          setState(() {
            utilsProvider.setIndexBottomNav(1);
          });
        }
    );

    MenuItem itemAddStock = MenuItem(
        title: "Add Stock",
        subtitle: "add your stock of your product",
        event: "",
        icon: Icons.note_add_outlined,
        click: () {}
    );
    List<MenuItem> myMenu = [itemAddProduct, itemAddStock];
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 100) / 2;
    final double itemWidth = size.width / 2;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0))
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 3.5,
              widthFactor: 1.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome,",
                    style: Theme.of(context).textTheme.headline6!.copyWith(color: colorWhiteBlue, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    pref.userLogin.nama != "" ? pref.userLogin.nama ?? "" : pref.userLogin.email,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: colorWhiteBlue, fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24,),
        Flexible(
          child: GridView.count(
              physics: ScrollPhysics(),
              childAspectRatio: (itemWidth / itemHeight),
              padding: const EdgeInsets.only(left: 16, right: 16),
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              shrinkWrap: true,
              children: myMenu.map((e) {
                return GestureDetector(
                  onTap: e.click,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          e.icon,
                          color: textColorWhite,
                          size: 60,
                        ),
                        const SizedBox(height: 14,),
                        AutoSizeText(
                          e.title,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontSize: 16.0, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8.0,),
                        AutoSizeText(
                          e.subtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(color: textColorWhite, fontSize: 10.0),
                        ),
                        const SizedBox(height: 14,),
                        e.event != ""
                            ? AutoSizeText(
                          e.event,
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(color: textColorWhite, fontSize: 11.0, fontWeight: FontWeight.w600),
                        )
                            : Container(),
                      ],
                    ),
                  ),
                );
              }).toList()
          ),
        )
      ],
    );
  }
}
