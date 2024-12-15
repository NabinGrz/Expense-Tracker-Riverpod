import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterDateCard extends ConsumerWidget {
  final TextEditingController controller;
  final void Function() onTap;
  final String title;
  const FilterDateCard({
    super.key,
    required this.onTap,
    required this.controller,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          readOnly: true,
          decoration: InputDecoration(
            floatingLabelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            label: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
    //   return InkWell(
    //     onTap: onTap,
    //     child: Container(
    //       width: MediaQuery.sizeOf(context).width * 0.5,
    //       padding: const EdgeInsets.all(14),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(8),
    //         border: Border.all(
    //           color: Colors.white,
    //         ),
    //       ),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Text(
    //             date.toFormattedDateString(),
    //             style: const TextStyle(
    //               fontSize: 14,
    //               color: Colors.white,
    //             ),
    //           ),
    //           SvgPicture.asset("assets/images/calendar_white.svg")
    //         ],
    //       ),
    //     ),
    //   );
  }
}
