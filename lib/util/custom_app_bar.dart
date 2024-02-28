import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  CustomAppBar({Key? key, required this.title})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: TextStyle(
          color: Color(0xff6003A2),
          fontSize: 20,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: IconThemeData(color: Color(0xff6003A2)),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () async => Navigator.pushNamed(context, '/mytickets'),
            icon: const Icon(
              Icons.local_activity,
              size: 36,
            ),
          ),
        ),
      ],
    );
  }
}
