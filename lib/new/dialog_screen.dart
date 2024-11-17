import 'package:flutter/material.dart';
import 'package:shiv_wallpaper/ad_helper/native_ad_widget.dart';

void optionDialog({
  required BuildContext context,
  VoidCallback? onPressedFirst,
  VoidCallback? onPressedSecond,
  VoidCallback? onPressedThird,
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return OptionsPage(
          onPressedFirst: onPressedFirst,
          onPressedSecond: onPressedSecond,
          onPressedThird: onPressedThird,
        );
      });
}

class OptionsPage extends StatefulWidget {
  const OptionsPage({
    Key? key,
    this.onPressedFirst,
    this.onPressedSecond,
    this.onPressedThird,
  }) : super(key: key);
  final VoidCallback? onPressedFirst;
  final VoidCallback? onPressedSecond;
  final VoidCallback? onPressedThird;
  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

ButtonStyle buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.amber))));

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.withOpacity(0.5)),
            child: Column(
              children: [
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: widget.onPressedFirst,
                  child: Text(
                    'Set As HomeScreen',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: widget.onPressedSecond,
                  child: Text(
                    'Set As LockScreen',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: widget.onPressedThird,
                  child: Text(
                    'Download',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // SizedBox(height: 370, width: 400, child: NativeAdWidget())
        ],
      ),
    );
  }
}
