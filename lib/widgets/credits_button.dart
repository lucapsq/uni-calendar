import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreditsButton extends StatelessWidget {
  final mediaQuery;
  const CreditsButton(this.mediaQuery, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mediaQuery.size.height * 0.15,
      height: mediaQuery.size.height * 0.06,
      child: ElevatedButton(
          onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  title: const Text('Crediti'),
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            'Vuoi mandarmi un feedback?\nPuoi contattarmi sui seguenti social:'),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  child: Icon(FontAwesomeIcons.instagram,
                                      color: Colors.pink[300], size: 35.0),
                                  onTap: () => launchUrl(Uri.parse(
                                      'https://www.instagram.com/lucapsq/'))),
                              SizedBox(
                                width: 50,
                              ),
                              InkWell(
                                  child: Icon(FontAwesomeIcons.telegram,
                                      color: Colors.blue, size: 35.0),
                                  onTap: () => launchUrl(
                                      Uri.parse('https://www.t.me/lucapsq'))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Quest'app ti piace e vuoi offrirmi un caffè?"),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: InkWell(
                              child: Icon(FontAwesomeIcons.paypal,
                                  color: Colors.blue, size: 35.0),
                              onTap: () => launchUrl(
                                  Uri.parse('https://www.paypal.me/lucapsq/'))),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                            "UniCalendar è realizzata da Luca Pasquale e distribuita in formato Open Source."),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: InkWell(
                              child: Icon(FontAwesomeIcons.github,
                                  color: Colors.black, size: 35.0),
                              onTap: () => launchUrl(Uri.parse(
                                  'https://github.com/lucapsq/uni-calendar'))),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
          child: Text(
            "Crediti e aiuto",
            textAlign: TextAlign.center,
          )),
    );
  }
}
