import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TimePickerDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TimePickerDemo extends StatefulWidget {
  const TimePickerDemo({Key? key}) : super(key: key);

  @override
  State<TimePickerDemo> createState() => _TimePickerDemoState();
}

class _TimePickerDemoState extends State<TimePickerDemo> {
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay customTime = TimeOfDay.now();
  DateTime cupertinoTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Picker Examples'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Basic Material Time Picker
            _buildSection(
              title: '1. Basic Material Time Picker',
              child: Column(
                children: [
                  Text(
                    'Selected Time: ${selectedTime.format(context)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showMaterialTimePicker(context),
                    child: const Text('Pick Time'),
                  ),
                ],
              ),
            ),

            // 2. Custom Time Picker Card
            _buildSection(
              title: '2. Custom Time Picker Card',
              child: CustomTimePickerCard(
                initialTime: customTime,
                onTimeChanged: (time) {
                  setState(() {
                    customTime = time;
                  });
                },
              ),
            ),

            // 3. Cupertino Time Picker
            _buildSection(
              title: '3. Cupertino (iOS Style) Time Picker',
              child: Column(
                children: [
                  Text(
                    'Selected Time: ${TimeOfDay.fromDateTime(cupertinoTime).format(context)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showCupertinoTimePicker(context),
                    child: const Text('Pick Time (iOS Style)'),
                  ),
                ],
              ),
            ),

            // 4. Inline Time Picker
            _buildSection(
              title: '4. Inline Time Picker',
              child: InlineTimePicker(
                initialTime: TimeOfDay.now(),
                onTimeChanged: (time) {
                  print('Inline time changed: ${time.format(context)}');
                },
              ),
            ),

            // 5. Time Range Picker
            _buildSection(
              title: '5. Time Range Picker',
              child: const TimeRangePicker(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Future<void> _showMaterialTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteTextColor: Colors.blue,
              hourMinuteColor: Colors.blue.withOpacity(0.1),
              dialHandColor: Colors.blue,
              dialBackgroundColor: Colors.grey.shade100,
              entryModeIconColor: Colors.blue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _showCupertinoTimePicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: cupertinoTime,
            onDateTimeChanged: (DateTime newTime) {
              setState(() {
                cupertinoTime = newTime;
              });
            },
          ),
        );
      },
    );
  }
}

// Custom Time Picker Card Widget
class CustomTimePickerCard extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const CustomTimePickerCard({
    Key? key,
    required this.initialTime,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  State<CustomTimePickerCard> createState() => _CustomTimePickerCardState();
}

class _CustomTimePickerCardState extends State<CustomTimePickerCard> {
  late TimeOfDay currentTime;

  @override
  void initState() {
    super.initState();
    currentTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                currentTime.format(context),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeAdjustButton(
                icon: Icons.remove,
                onPressed: () => _adjustTime(-1, true),
                label: 'Hour -',
              ),
              _buildTimeAdjustButton(
                icon: Icons.add,
                onPressed: () => _adjustTime(1, true),
                label: 'Hour +',
              ),
              _buildTimeAdjustButton(
                icon: Icons.remove,
                onPressed: () => _adjustTime(-1, false),
                label: 'Min -',
              ),
              _buildTimeAdjustButton(
                icon: Icons.add,
                onPressed: () => _adjustTime(1, false),
                label: 'Min +',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeAdjustButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.blue),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.blue),
        ),
      ],
    );
  }

  void _adjustTime(int delta, bool isHour) {
    setState(() {
      if (isHour) {
        int newHour = (currentTime.hour + delta) % 24;
        if (newHour < 0) newHour = 23;
        currentTime = TimeOfDay(hour: newHour, minute: currentTime.minute);
      } else {
        int newMinute = (currentTime.minute + delta) % 60;
        if (newMinute < 0) newMinute = 59;
        currentTime = TimeOfDay(hour: currentTime.hour, minute: newMinute);
      }
      widget.onTimeChanged(currentTime);
    });
  }
}

// Inline Time Picker Widget
class InlineTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const InlineTimePicker({
    Key? key,
    required this.initialTime,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  State<InlineTimePicker> createState() => _InlineTimePickerState();
}

class _InlineTimePickerState extends State<InlineTimePicker> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            selectedTime.format(context),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildWheelPicker(
                  title: 'Hour',
                  value: selectedTime.hour,
                  maxValue: 23,
                  onChanged: (value) {
                    setState(() {
                      selectedTime = TimeOfDay(hour: value, minute: selectedTime.minute);
                      widget.onTimeChanged(selectedTime);
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildWheelPicker(
                  title: 'Minute',
                  value: selectedTime.minute,
                  maxValue: 59,
                  onChanged: (value) {
                    setState(() {
                      selectedTime = TimeOfDay(hour: selectedTime.hour, minute: value);
                      widget.onTimeChanged(selectedTime);
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWheelPicker({
    required String title,
    required int value,
    required int maxValue,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: maxValue + 1,
              builder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: index == value ? FontWeight.bold : FontWeight.normal,
                      color: index == value ? Colors.blue : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Time Range Picker Widget
class TimeRangePicker extends StatefulWidget {
  const TimeRangePicker({Key? key}) : super(key: key);

  @override
  State<TimeRangePicker> createState() => _TimeRangePickerState();
}

class _TimeRangePickerState extends State<TimeRangePicker> {
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 17, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Select Time Range',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildTimeRangeButton(
                  title: 'Start Time',
                  time: startTime,
                  onPressed: () => _selectTime(context, true),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.arrow_forward, color: Colors.grey),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimeRangeButton(
                  title: 'End Time',
                  time: endTime,
                  onPressed: () => _selectTime(context, false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Duration: ${_calculateDuration()}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeButton({
    required String title,
    required TimeOfDay time,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            time.format(context),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? startTime : endTime,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  String _calculateDuration() {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final diff = endMinutes - startMinutes;

    if (diff <= 0) {
      return 'Invalid range';
    }

    final hours = diff ~/ 60;
    final minutes = diff % 60;

    return '${hours}h ${minutes}m';
  }
}