import 'dart:async';
import 'package:flutter/material.dart';
import 'package:global/widgets/gbtn.dart';
import 'package:global/screens/login/verification_pending_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final List<DocumentItem> _documents = [
    DocumentItem(title: 'Government ID', subtitle: 'Passport or National ID'),
    DocumentItem(
      title: 'Business License',
      subtitle: 'Upload Valid Registration',
    ),
    DocumentItem(
      title: 'Proof of Address',
      subtitle: 'Utility bill or bank statement',
    ),
  ];

  void _showFilePicker(int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Document Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  _startUpload(index, image.name);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  _startUpload(index, image.name);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_present_outlined),
              title: const Text('Files'),
              onTap: () async {
                Navigator.pop(context);
                FilePickerResult? result = await FilePicker.platform
                    .pickFiles();
                if (result != null) {
                  _startUpload(index, result.files.single.name);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _startUpload(int index, String fileName) {
    setState(() {
      _documents[index].isUploading = true;
      _documents[index].progress = 0.0;
    });

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_documents[index].progress < 1.0) {
          _documents[index].progress += 0.05;
        } else {
          _documents[index].isUploading = false;
          _documents[index].isCompleted = true;
          _documents[index].fileName = fileName;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int completedCount = _documents.where((doc) => doc.isCompleted).length;
    double overallProgress = completedCount / _documents.length;

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Progress Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Step 2 of 3',
                    style: TextStyle(
                      color: Color(0xFFBA983F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${(overallProgress * 100).toInt()}% Completed',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: overallProgress,
                  backgroundColor: const Color(0xffE0E0E0),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFBA983F),
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Upload Document',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please upload following documents to activate your account',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              // Document List
              Expanded(
                child: ListView.separated(
                  itemCount: _documents.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final doc = _documents[index];
                    return InkWell(
                      onTap: doc.isUploading || doc.isCompleted
                          ? null
                          : () => _showFilePicker(index),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.badge_outlined,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    doc.isCompleted
                                        ? doc.fileName!
                                        : doc.subtitle,
                                    style: TextStyle(
                                      color: doc.isCompleted
                                          ? Colors.grey
                                          : Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (doc.isUploading) ...[
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(2),
                                      child: LinearProgressIndicator(
                                        value: doc.progress,
                                        backgroundColor: const Color(
                                          0xffF0F0F0,
                                        ),
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                              Color(0xFFBA983F),
                                            ),
                                        minHeight: 4,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (doc.isCompleted)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            else if (doc.isUploading)
                              Text(
                                '${(doc.progress * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Color(0xFFBA983F),
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            else
                              ElevatedButton(
                                onPressed: () => _showFilePicker(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff636363),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text('Upload'),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              GBtn(
                text: 'Submit for Verification',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerificationPendingScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentItem {
  final String title;
  final String subtitle;
  bool isUploading;
  bool isCompleted;
  double progress;
  String? fileName;

  DocumentItem({
    required this.title,
    required this.subtitle,
    this.isUploading = false,
    this.isCompleted = false,
    this.progress = 0.0,
    this.fileName,
  });
}
