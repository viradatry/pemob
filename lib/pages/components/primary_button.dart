// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool? isLoading;
  final bool? isEnabled;
  final Color? color;
  final double? width;
  final double? height;
  final double? elevation;
  final Color? borderColor;
  final bool? reverseLoading;
  const PrimaryButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isLoading = false,
    this.reverseLoading = false,
    this.isEnabled = true,
    this.color,
    this.width,
    this.height,
    this.elevation,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled!
          ? !isLoading!
              ? onPressed
              : () {}
          : () {},
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? 1,
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
          side: borderColor != null
              ? BorderSide(
                  color: borderColor!,
                )
              : BorderSide.none,
        ),
        backgroundColor: !isLoading!
            ? color ?? Colors.blue
            : reverseLoading!
                ? Colors.white
                : Colors.grey.shade300,
        shadowColor: elevation != 0 ? null : Colors.transparent,
        minimumSize: Size(
          width ?? double.infinity,
          height ?? 40,
        ),
      ),
      child: !isLoading!
          ? child
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: reverseLoading! ? Colors.blue : Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Loading",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: reverseLoading! ? Colors.blue : Colors.white,
                  ),
                )
              ],
            ),
    );
  }
}
