import 'package:flutter/material.dart';

String dropdownValue = '14';

class SettingText extends StatefulWidget {
  const SettingText({super.key});

  @override
  State<SettingText> createState() => _SettingTextState();
}

class _SettingTextState extends State<SettingText> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text("Размер текста"),
            trailing: DropdownButton<String>(
              // Step 3.
              value: dropdownValue,
              // Step 4.
              items: <String>['14', '16', '18', '20', '22', '24', '26', '28', '30']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(),
                  ),
                );
              }).toList(),
              // Step 5.
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
