import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/constants/utils.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onTap;
  const DateSelector({super.key, required this.selectedDate,required this.onTap});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

int weekOffset = 0;

class _DateSelectorState extends State<DateSelector> {
  @override
  Widget build(BuildContext context) {
    final weekDates = generateWeekDates(weekOffset);
    String monthName = DateFormat("MMMM").format(weekDates.first);
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    weekOffset--;
                  });
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text(
                monthName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    weekOffset++;
                  });
                },
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weekDates.length,
              itemBuilder: (context, index) {
                final date = weekDates[index];
                bool isSelected = DateFormat('d').format(widget.selectedDate) ==
                        DateFormat('d').format(date) &&
                    widget.selectedDate.month == date.month &&
                    widget.selectedDate.year == date.year;
                return GestureDetector(
                  onTap:()=> widget.onTap(date),
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(
                      right: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepOrangeAccent : null,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: isSelected
                              ? Colors.deepOrangeAccent
                              : Colors.grey.shade300,
                          width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat("d").format(date),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat("E").format(date),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
