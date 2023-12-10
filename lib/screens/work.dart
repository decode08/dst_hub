import 'dart:developer';

import 'package:dst_hub/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController describeController = TextEditingController();
  TextEditingController hoursController = TextEditingController();

  void _saveWorkData() {
    if (_formKey.currentState!.validate()) {
      String workDescription = describeController.text;
      double hoursSpent = double.parse(hoursController.text);

      if (hoursSpent < 6) {
        // FirebaseApi();
        NotificationService().showNotification(
            title: 'DST HUB',
            body: 'Your working hours are less than 6 hours.');
      } else {
        log("ok");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("DST HUB LLP"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: describeController,
                      decoration: InputDecoration(
                          labelText: 'What you have done today?'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please state your work done';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: hoursController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "No. of hours you've worked today?"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter no. of hours';
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _saveWorkData();
                        },
                        child: Text("Save Work Details")),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
