import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  String? city;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  void _submit() {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });
    final form = _formKey.currentState;
    if(form != null && form.validate()){
      form.save();
      Navigator.pop(context, city!.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                autofocus: true,
                style: const TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                    labelText: 'City name',
                    hintText: 'more than 2 char',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().length < 2) {
                    return 'City name must be at least 2 char long';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  city = newValue;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: _submit,
                child: const Text(
                  "How's weather?",
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
