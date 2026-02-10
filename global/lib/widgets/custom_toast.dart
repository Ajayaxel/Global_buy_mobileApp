import 'package:flutter/material.dart';
import 'dart:async';

class CustomToast {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    // success colors
    final Color validBg = Colors.white;
    final Color validText = Colors.green.shade700;
    final Color validIcon = Colors.green.shade700;

    // error colors
    final Color errorBg = Colors.white;
    final Color errorText = Colors.red.shade700;
    final Color errorIcon = Colors.red.shade700;

    final Color bgColor = isError ? errorBg : validBg;
    final Color textColor = isError ? errorText : validText;
    final Color iconColor = isError ? errorIcon : validIcon;

    final IconData icon = isError
        ? Icons.error_outline
        : Icons.check_circle_outline;

    final OverlayState overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60, // Adjust for status bar + padding
        right: 20, // Right align
        child: Material(
          color: Colors.transparent,
          child: Container(
            // Constrain width to avoid overflowing if message is long
            width: MediaQuery.of(context).size.width * 0.85,
            constraints: const BoxConstraints(maxWidth: 350),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Satoshi',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
