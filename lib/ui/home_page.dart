import 'dart:async';

import 'package:ewarung/common/styles.dart';
import 'package:ewarung/data/model/summary_result.dart';
import 'package:ewarung/provider/news_provider.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:ewarung/provider/summary_provider.dart';
import 'package:ewarung/provider/utils_provider.dart';
import 'package:ewarung/utils/get_formatted.dart';
import 'package:ewarung/utils/result_state.dart';
import 'package:ewarung/widgets/custom_notification_snackbar.dart';
import 'package:ewarung/widgets/custom_notification_widget.dart';
import 'package:ewarung/widgets/item_news.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool deactivateTimer = false;
  bool _isGetSummary = true;

  @override
  Widget build(BuildContext context) {
    PreferencesProvider pref = Provider.of<PreferencesProvider>(context);
    UtilsProvider utilsProvider = Provider.of<UtilsProvider>(context);
    SummaryProvider summaryProvider = Provider.of<SummaryProvider>(context);

    return Scaffold(
        backgroundColor: primaryColor,
        body: _buildHome(pref, utilsProvider, summaryProvider)
    );
  }

  Widget _buildHome(PreferencesProvider pref, UtilsProvider utilsProvider, SummaryProvider summaryProvider) {
    if (mounted) {
      Timer t = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          deactivateTimer = true;
        });
        if (_isGetSummary) {
          setState(() {
            _isGetSummary = false;
          });
          getSummary(summaryProvider, pref, utilsProvider);
        }
      });

      if (deactivateTimer) {
        setState(() {
          t.cancel();
        });
      } else {
        if (_isGetSummary) {
          t;
        } else {
          setState(() {
            t.cancel();
          });
        }
      }
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: kToolbarHeight,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Welcome Back,\n",
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 19.0),
                              ),
                              TextSpan(
                                text: pref.userLogin.nama != "" ? pref.userLogin.nama ?? "" : pref.userLogin.email,
                                style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600,),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 210.0,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  color: colorWhiteBlue,
                ),
                padding: const EdgeInsets.symmetric(vertical: 24.0,),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummary(utilsProvider),
                    const SizedBox(height: 16.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0,),
                          child: Text(
                            "News",
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 20.0,),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Consumer<NewsProvider>(
                          builder: (context, state, _) {
                            if (state.stateNews == ResultState.loading) {
                              return SizedBox(height: MediaQuery.of(context).size.height/2, child: const Center(child: CircularProgressIndicator(),));
                            } else if (state.stateNews == ResultState.hasData) {
                              var dataNews = state.resultNews.data;
                              return MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: dataNews.length,
                                    itemBuilder: (context, index) {
                                      return ItemNews(news: dataNews[index]);
                                    }
                                ),
                              );
                            } else if (state.stateNews == ResultState.noData) {
                              return SizedBox(height: 50, child: CustomNotificationWidget(message: state.messageNews));
                            } else if (state.stateNews == ResultState.error) {
                              return SizedBox(height: 50, child: CustomNotificationWidget(message: state.messageNews));
                            } else {
                              return const SizedBox(height: 50, child: CustomNotificationWidget(message: "Error: Went Something Wrong.."));
                            }
                          }
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(UtilsProvider utilsProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,),
          child: Text(
            "Orders",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 20.0,),
          ),
        ),
        const SizedBox(height: 16.0,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 150,
                height: 90,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: colorDashboardRed,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Orders",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      GetFormatted().number(utilsProvider.summary.totalOrders),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150,
                height: 90,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: colorDashboardOrange,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today Orders",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      GetFormatted().number(utilsProvider.summary.todayOrders),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150,
                height: 90,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: colorDashboardBlue,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Month Orders",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      GetFormatted().number(utilsProvider.summary.monthOrders),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150,
                height: 90,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: colorDashboardPurple,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Year Orders",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      GetFormatted().number(utilsProvider.summary.yearOrders),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,),
          child: Text(
            "Revenue",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 20.0,),
          ),
        ),
        const SizedBox(height: 16.0,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 150,
                height: 90,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: colorDashboardPattern1,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Revenue",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Rp. ${GetFormatted().number(utilsProvider.summary.totalRevenue)}",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150,
                height: 90,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: colorDashboardPattern2,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today Revenue",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Rp. ${GetFormatted().number(utilsProvider.summary.totalTodayRevenue)}",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150,
                height: 90,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: colorDashboardPattern3,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Month Revenue",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Rp. ${GetFormatted().number(utilsProvider.summary.totalMonthRevenue)}",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150,
                height: 90,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: colorDashboardPattern4,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Year Revenue",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Rp. ${GetFormatted().number(utilsProvider.summary.totalYearRevenue)}",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,),
          child: Text(
            "Products",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 20.0,),
          ),
        ),
        const SizedBox(height: 16.0,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 150,
                height: 90,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: colorDashboardGreen,
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Products",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      GetFormatted().number(utilsProvider.summary.totalProducts),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  getSummary(SummaryProvider summaryProvider, PreferencesProvider pref, UtilsProvider utilsProvider) async {
    utilsProvider.setIndexBottomNav(0);

    try {
      final Future<SummaryResult> response = summaryProvider.fetchSummaryStore(pref.userLogin.id);

      response.then((value) {
        if (value.status) {
          utilsProvider.setSummary(value.data!);
        } else {
          CustomNotificationSnackbar(context: context, message: value.message);
        }
      });
    } catch (e) {
      CustomNotificationSnackbar(context: context, message: "Error : $e");
    }
  }
}