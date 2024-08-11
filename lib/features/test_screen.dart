import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // const PinnedHeaderSliver(
          //   child: Text(
          //     "Hello World",
          //     style: TextStyle(
          //       fontSize: 24,
          //     ),
          //   ),
          // ),
          SliverAppBar.large(
            expandedHeight: 200,
            title: const Text("Appbar"),
            flexibleSpace: FlexibleSpaceBar(
              // title: const Text("Appbar"),
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const FlutterLogo(
                    size: 70,
                  ),
                  10.hGap,
                  const Text(
                    "Hello",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Hello",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              centerTitle: false,
              stretchModes: const [
                StretchMode.zoomBackground,
              ],
            ),
            // bottom: PreferredSize(
            //   preferredSize: Size(double.infinity, 72),
            //   child: Text(
            //     "Hello",
            //     style: TextStyle(
            //       fontSize: 20,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
          ),
          // Floating
          SliverList(
              delegate: SliverChildBuilderDelegate(
            childCount: 60,
            (context, index) {
              return const Text(
                "Hello",
                style: TextStyle(
                  fontSize: 20,
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
