import 'package:domus_app/ui_elements/theme/ui_constants.dart';
import 'package:flutter/material.dart';

class RadiusSlider extends StatefulWidget {
  final Function(double) onChanged;
  final double initialRadius;
  
  const RadiusSlider({super.key, required this.onChanged, required this.initialRadius});

  @override
  _RadiusSliderState createState() => _RadiusSliderState();
}

class _RadiusSliderState extends State<RadiusSlider> {
  double _radius = 2;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _radius = widget.initialRadius;
    _controller.text = widget.initialRadius.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
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
          style: TextStyle(fontSize: 18, color: context.outline),
        )
      ],
    );
  }
}