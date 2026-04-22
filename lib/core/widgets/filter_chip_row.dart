import 'package:flutter/material.dart';

class FilterChipRow<T> extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.values,
    required this.selected,
    required this.labelBuilder,
    required this.onSelected,
  });

  final List<T> values;
  final T selected;
  final String Function(T value) labelBuilder;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: values
            .map(
              (value) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(labelBuilder(value)),
                  selected: value == selected,
                  onSelected: (_) => onSelected(value),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
