import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:juan_restrepo_6_2021_2_p1/src//screens/settings_view.dart';
import 'package:juan_restrepo_6_2021_2_p1/src/components/loader_component.dart';
import 'package:juan_restrepo_6_2021_2_p1/src/helpers/api_helper.dart';
import 'package:juan_restrepo_6_2021_2_p1/src/helpers/constants.dart';
import 'package:juan_restrepo_6_2021_2_p1/src/models/new.dart';
import 'package:juan_restrepo_6_2021_2_p1/src/models/response.dart';
import 'new_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<New> _news = [];
  bool _showLoader = false;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.news),
          actions: <Widget>[
            _search.isNotEmpty
                ? IconButton(
                    onPressed: _removeFilter,
                    icon: const Icon(Icons.filter_none))
                : IconButton(
                    onPressed: _showFilter, icon: const Icon(Icons.filter_alt)),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: Center(
          child: _showLoader
              ? LoaderComponent(text: AppLocalizations.of(context)!.waitPlease)
              : _getContent(),
        ));
  }

  Future<void> _getNews() async {
    setState(() {
      _showLoader = true;
    });

    ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });

      await showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          message: AppLocalizations.of(context)!.checkConnection,
          actions: <AlertDialogAction>[
            AlertDialogAction(
                key: null, label: AppLocalizations.of(context)!.ok),
          ]);

      return;
    }

    Response response = await ApiHelper.getNews(
        _search.isEmpty ? Constants.filterAll : _search);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(
                key: null, label: AppLocalizations.of(context)!.ok),
          ]);
      return;
    }

    setState(() {
      _news = response.result;
    });
  }

  Widget _getContent() {
    return _news.isEmpty ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Text(
          _search.isNotEmpty
              ? AppLocalizations.of(context)!.noNewsFiltered
              : AppLocalizations.of(context)!.noNews,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getNews,
      child: ListView(
        children: _news.map((e) {
          return Card(
            child: InkWell(
              onTap: () => _goDetail(e),
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                child: FloatColumn(
                  children: [
                    Floatable(
                        float: FCFloat.start,
                        padding: const EdgeInsetsDirectional.only(end: 12),
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(e.imageUrl),
                        )),
                    const Floatable(
                        float: FCFloat.end,
                        padding: EdgeInsetsDirectional.only(start: 12, top: 12),
                        child: Icon(Icons.arrow_forward_ios)),
                    WrappableText(
                        text: TextSpan(
                            text: e.title,
                            style: const TextStyle(
                              fontSize: 20,
                            ))),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(AppLocalizations.of(context)!.filter),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(AppLocalizations.of(context)!.writeFilter),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  autofocus: true,
                  items: _getFilters(),
                  value: _search.isEmpty ? null : _search,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.writeFilter,
                    labelText: AppLocalizations.of(context)!.filter,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _search = value ?? '';
                    });
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    setState(() {
                      _search = '';
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.cancel)),
              TextButton(
                  onPressed: () => _filter(),
                  child: Text(AppLocalizations.of(context)!.filter)),
            ],
          );
        });
  }

  List<DropdownMenuItem<String>> _getFilters() => [
        DropdownMenuItem<String>(
            child: Text(AppLocalizations.of(context)!.national),
            value: 'national'),
        DropdownMenuItem<String>(
          child: Text(AppLocalizations.of(context)!.business),
          value: 'business',
        ),
        DropdownMenuItem<String>(
            child: Text(AppLocalizations.of(context)!.sports), value: 'sports'),
        DropdownMenuItem<String>(
            child: Text(AppLocalizations.of(context)!.world), value: 'world'),
        DropdownMenuItem<String>(
            child: Text(AppLocalizations.of(context)!.politics),
            value: 'politics'),
        DropdownMenuItem<String>(
            child: Text(AppLocalizations.of(context)!.technology),
            value: 'technology'),
        DropdownMenuItem<String>(
            child: Text(AppLocalizations.of(context)!.startup),
            value: 'startup'),
        DropdownMenuItem<String>(
            child: Text(AppLocalizations.of(context)!.entertainment),
            value: 'entertainment'),
        DropdownMenuItem<String>(
            child: Text(AppLocalizations.of(context)!.hatke), value: 'hatke'),
        DropdownMenuItem<String>(
            child: Text(AppLocalizations.of(context)!.science),
            value: 'science'),
        DropdownMenuItem<String>(
            child: Text(AppLocalizations.of(context)!.automobile),
            value: 'automobile')
      ];

  void _removeFilter() {
    setState(() {
      _search = '';
    });

    _getNews();
  }

  void _filter() {
    if (_search.isEmpty) {
      return;
    }

    _getNews();

    Navigator.of(context).pop();
  }

  void _goDetail(New record) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewScreen(
                  record: record,
                )));
  }
}
