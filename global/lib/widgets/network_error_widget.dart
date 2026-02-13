import 'package:flutter/material.dart';

class NetworkErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const NetworkErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            const Text(
              "Connection Error",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _formatErrorMessage(message),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBA983F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Retry",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatErrorMessage(String error) {
    if (error.contains("SocketException") || error.contains("Network Error")) {
      return "Unable to connect to the server. Please check your internet connection and try again.";
    }
    if (error.contains("TimeoutException") ||
        error.contains("connectTimeout")) {
      return "The connection timed out. The server might be busy, please try again.";
    }
    return error.replaceAll("Exception:", "").trim();
  }
}
