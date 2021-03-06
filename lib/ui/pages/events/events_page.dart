import 'package:barriolympics/provider/app_state.dart';
import 'package:barriolympics/ui/components/banner/top_banner.dart';
import 'package:barriolympics/ui/components/event/chip_list.dart';
import 'package:barriolympics/ui/pages/events/event_filter_data.dart';
import 'package:flutter/material.dart';
import 'package:barriolympics/ui/components/event/event_list.dart';
import 'package:barriolympics/ui/pages/events/filter_page.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late EventFilterData _filterData;

  @override
  void initState() {
    super.initState();

    _filterData = EventFilterData(
        user: Provider.of<AppState>(context, listen: false).user);
  }

  void setFilters(EventFilterData filters) {
    setState(() {
      _filterData = filters;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          TopBanner(),
          SliverAppBar(
            toolbarHeight: 73,
            backgroundColor: Theme.of(context).colorScheme.background,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Events',
                        style: Theme.of(context).textTheme.headline6),
                    ChipList(
                        filterData: _filterData, updateFilters: setFilters),
                  ],
                ),
              ),
            ),
          ),
          Consumer<AppState>(builder: (context, state, widget) {
            return EventList(
                events: state.getEvents(_filterData), filters: _filterData);
          }),
          SliverPadding(padding: EdgeInsets.only(bottom: 70)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffFFF521),
        hoverElevation: 1.5,
        elevation: 10,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilterPage(setFilters: this.setFilters)),
          );
        },
        child: const Icon(Icons.filter_alt, size: 30),
      ),
    );
  }
}
