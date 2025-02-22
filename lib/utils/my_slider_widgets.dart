import 'package:domus_app/theme/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class RadiusSlider extends StatefulWidget {
  final Function(double) onChanged;
  
  const RadiusSlider({Key? key, required this.onChanged}) : super(key: key);

  @override
  _RadiusSliderState createState() => _RadiusSliderState();
}

class _RadiusSliderState extends State<RadiusSlider> {
  double _radius = 2; // Valore iniziale del raggio in km
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = _radius.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 340,
          child: Slider(
            value: _radius,
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: Theme.of(context).colorScheme.onSecondary,
            inactiveColor: Theme.of(context).colorScheme.secondary,
            label: '$_radius km',
            onChanged: (value) {
              setState(() {
                _radius = value;
              });
              widget.onChanged(value);
            },
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "${_radius.toStringAsFixed(0)} km",
          style: TextStyle(fontSize: 18, color: context.onError),
        )
      ],
    );
  }
}