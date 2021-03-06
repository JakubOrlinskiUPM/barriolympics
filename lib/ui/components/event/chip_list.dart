import 'package:barriolympics/models/event_category.dart';
import 'package:barriolympics/provider/app_state.dart';
import 'package:barriolympics/ui/pages/events/event_filter_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChipList extends StatefulWidget {
  const ChipList(
      {Key? key, required this.filterData, required this.updateFilters})
      : super(key: key);

  final EventFilterData filterData;
  final Function updateFilters;

  @override
  State<ChipList> createState() => _ChipListState();
}

class FilteringChip {
  FilteringChip({
    required this.isFilter,
    this.icon,
    this.label,
    this.category,
    required this.selected,
  });

  final EventCategory? category;
  final bool isFilter;
  final IconData? icon;
  final String? label;
  bool selected;

  EventFilterData applyFilter(EventFilterData filterData) {
    if (this.category != null) {
      if (this.category!.isSpecial) {
        filterData = this.category!.applyFilter!(filterData);
      } else {
        List<EventCategory> tmp = filterData.categories.toList();
        if (tmp.contains(this.category)) {
          tmp.remove(this.category!);
        } else {
          tmp.add(this.category!);
        }
        filterData.categories = tmp;
      }
    }
    return filterData;
  }
}

class _ChipListState extends State<ChipList> {
  late List<FilteringChip> _chipsSelected;

  @override
  void initState() {
    super.initState();

    AppState state = Provider.of<AppState>(context, listen: false);
    _chipsSelected = state.eventCategories
        .map(
          (cat) =>
              FilteringChip(category: cat, isFilter: false, selected: false),
        )
        .toList();

    _chipsSelected = extendChipList();
  }

  @override
  void didUpdateWidget(ChipList oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _chipsSelected = extendChipList();
    });
  }

  List<FilteringChip> extendChipList() {
    List<FilteringChip> tmp = _chipsSelected.toList();
    tmp = tmp.where((chip) => !chip.isFilter).toList();

    List<FilteringChip> extraChips = widget.filterData.getFilterChips();

    for (FilteringChip chip in extraChips) {
      tmp.insert(0, chip);
    }

    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 33,
      child: ListView.separated(
        itemCount: _chipsSelected.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          if (!_chipsSelected[index].isFilter) {
            return FilterChip(
              avatar: _chipsSelected[index].selected ||
                      _chipsSelected[index].category!.isSpecial
                  ? null
                  : Icon(_chipsSelected[index].category!.iconData, size: 18,),
              labelStyle: _chipsSelected[index].selected
                  ? TextStyle(color: Theme.of(context).colorScheme.onPrimary)
                  : TextStyle(),
              selected: _chipsSelected[index].selected,
              label: Text(_chipsSelected[index].category!.label),
              onSelected: (bool value) {
                setState(() {
                  _chipsSelected[index].selected = value;
                });
                widget.updateFilters(
                    _chipsSelected[index].applyFilter(widget.filterData));
              },
            );
          } else {
            return InputChip(
              showCheckmark: false,
              selected: true,
              avatar: Icon(
                _chipsSelected[index].icon,
              ),
              deleteIcon: Icon(Icons.highlight_remove),
              onDeleted: () {
                setState(() {
                  _chipsSelected.removeAt(index);
                });
                widget.filterData.startDate = null;
                widget.updateFilters(widget.filterData);
              },
              label: Text(_chipsSelected[index].label!),
            );
          }
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 6,
          );
        },
      ),
    );
  }
}
