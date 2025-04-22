import 'package:flutter/material.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/widgets/custom_check_box.dart';

class ParameterDropdown extends StatefulWidget {
  /// The title to show in the header (e.g. “Daily Thought”)
  final String title;

  /// A little icon or image to show at the left of the title
  final Widget? leading;

  /// The list of options to pick from
  final List<String> items;

  /// The currently selected value
  final String selected;

  /// Called when the user taps a new value
  final ValueChanged<String> onChanged;

  const ParameterDropdown({
    Key? key,
    required this.title,
    this.leading,
    required this.items,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ParameterDropdown> createState() => _ParameterDropdownState();
}

class _ParameterDropdownState extends State<ParameterDropdown> {
  bool _isOpen = false;

  void _toggle() => setState(() => _isOpen = !_isOpen);

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: appSecondary,
        child: Column(
          children: [
            // ───── header ─────
            GestureDetector(
              onTap: _toggle,
              child: Container(
                decoration: BoxDecoration(
                  color: appPrimary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    widget.leading ?? SizedBox.shrink(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTextStyles.kw600s16,
                      ),
                    ),
                    // the arrow
                    AnimatedRotation(
                      turns: _isOpen ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child:
                          Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            // ───── options ─────
            // ───── options ─────
            if (_isOpen)
              Container(
                decoration: BoxDecoration(
                  color: appSecondary,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                  border: Border.all(color: appPrimary.withAlpha(50)),
                ),
                // constrain the height so ListView knows its bounds
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: appPrimary.withAlpha(50), height: 1),
                    itemBuilder: (context, idx) {
                      final item = widget.items[idx];
                      final selected = item == widget.selected;
                      return InkWell(
                        onTap: () {
                          widget.onChanged(item);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              CustomCheckbox(
                                value: selected,
                                onChanged: (_) {
                                  widget.onChanged(item);
                                  _toggle();
                                },
                                activeColor: appPrimary,
                                borderColor: appPrimary,
                                scale: 1.2,
                                borderRadius: 4.0,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item,
                                style: selected
                                    ? AppTextStyles.kw600s16
                                        .copyWith(color: appDarkGrey)
                                    : AppTextStyles.kw600s16
                                        .copyWith(color: appTertiary),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ));
  }
}
