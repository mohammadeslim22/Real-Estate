import 'package:flutter/material.dart';

import 'widgets/text_form_input.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key, this.search}) : super(key: key);
  final String search;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(children: [
            Text(widget.search),
          ]),
        ),
        body: ListView(children: [
          TextFormInput(
              text: "ادخل الموقع",
             // cController: locationController,
              prefixIcon: Icons.my_location,
              kt: TextInputType.visiblePassword,
              readOnly: true,
              onTab: () async {
                try {
                  Navigator.popAndPushNamed(context, '/AutoLocate',
                      arguments: <String, double>{
                        "lat": 24.774265,
                        "long": 46.738586
                      });
                } catch (e) {}
              },
              suffixicon: IconButton(
                icon: const Icon(Icons.add_location, color: Colors.blue),
                onPressed: () {},
              ),
              obscureText: false,
              // focusNode: focus1,
              validator: (String value) {
                if (value.isEmpty) {
                  return "حدد العنوان من فضلك";
                }
                return null;
              }),
        ]));
  }
}
