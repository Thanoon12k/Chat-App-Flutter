import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: TextField(
          controller: dateController,
          decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today), labelText: " تاريخ الميلاد"),
          textAlign: TextAlign.right,
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.utc(2000),
              firstDate: DateTime(1970),
              lastDate: DateTime(2030),
            );
            if (pickedDate != null) {
              String formattedDate =
                  DateFormat("yyyy-MM-dd").format(pickedDate);

              setState(() {
                dateController.text = formattedDate.toString();
              });
            } else {
              print(" لم يتم الاختيار");
            }
          },
        ),
      ),
    );
  }
}
