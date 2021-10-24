import 'package:float_column/float_column.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:juan_restrepo_6_2021_2_p1/src/models/new.dart';
import 'package:juan_restrepo_6_2021_2_p1/src/screens/settings_view.dart';
import 'package:url_launcher/url_launcher.dart';

class NewScreen extends StatelessWidget {
  final New record;

  const NewScreen({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.news),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: FloatColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                    image: NetworkImage(record.imageUrl),
                    width: MediaQuery.of(context).size.width * 1),
                Text(record.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                Floatable(
                    float: FCFloat.end,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Text(record.author,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic)),
                    )),
                Floatable(
                    float: FCFloat.start,
                    child: Text(record.time,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 15))),
                Floatable(
                    float: FCFloat.end,
                    child: Text(record.date,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 15))),
                Text(record.content,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 20)),
                Center(
                    child: InkWell(
                  onTap: () => launch(record.url),
                  child: Text(AppLocalizations.of(context)!.source,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 15, decoration: TextDecoration.underline)),
                )),
                Center(
                    child: record.readMoreUrl != null
                        ? InkWell(
                            onTap: () => launch(record.readMoreUrl.toString()),
                            child: Text(AppLocalizations.of(context)!.readMore,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline)),
                          )
                        : const Text(''))
              ],
            ),
          ),
        ));
  }
}
