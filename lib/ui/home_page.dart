import 'package:ewarung/common/styles.dart';
import 'package:ewarung/provider/news_provider.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:ewarung/provider/utils_provider.dart';
import 'package:ewarung/utils/result_state.dart';
import 'package:ewarung/widgets/custom_notification_widget.dart';
import 'package:ewarung/widgets/item_news.dart';
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
  Widget build(BuildContext context) {
    PreferencesProvider pref = Provider.of<PreferencesProvider>(context);
    UtilsProvider utilsProvider = Provider.of<UtilsProvider>(context);

    return Scaffold(
        backgroundColor: primaryColor,
        body: _buildHome(pref, utilsProvider)
    );
  }

  Widget _buildHome(PreferencesProvider pref, UtilsProvider utilsProvider) {
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
                        Consumer<NewsProvider>(
                            builder: (context, state, _) {
                              if (state.stateNews == ResultState.loading) {
                                return const Center(child: CircularProgressIndicator(),);
                              } else if (state.stateNews == ResultState.hasData) {
                                var dataNews = state.resultNews.data;
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: dataNews.length,
                                    itemBuilder: (context, index) {
                                      return ItemNews(news: dataNews[index]);
                                    }
                                );
                              } else if (state.stateNews == ResultState.noData) {
                                return CustomNotificationWidget(message: state.messageNews);
                              } else if (state.stateNews == ResultState.error) {
                                return CustomNotificationWidget(message: state.messageNews);
                              } else {
                                return const CustomNotificationWidget(message: "Error: Went Something Wrong..");
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
}
