import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/document/document_bloc.dart';
import 'package:global/bloc/document/document_event.dart';
import 'package:global/bloc/document/document_state.dart';
import 'package:global/widgets/custom_loading_indicator.dart';
import 'package:global/widgets/custom_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  void initState() {
    super.initState();
    // Only fetch if not already loaded to avoid redundant API calls
    final state = context.read<DocumentBloc>().state;
    if (state is! DocumentFetchSuccess) {
      context.read<DocumentBloc>().add(FetchDocumentsRequested());
    }
  }

  Future<void> _onRefresh() async {
    context.read<DocumentBloc>().add(FetchDocumentsRequested());
  }

  Future<void> _launchUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) return;
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        CustomToast.show(context, 'Could not launch $urlString', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xFFF6F6F6),
              body: SafeArea(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                              ),
                            ),
                          ),
                          const Text(
                            "Documents",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ), // To balance the back button
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Document List
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: _buildBody(state),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (state is DocumentLoading) const CustomLoadingPage(),
          ],
        );
      },
    );
  }

  Widget _buildBody(DocumentState state) {
    if (state is DocumentFetchSuccess) {
      final docs = state.documents;
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          if (docs.governmentId != null)
            _buildDocumentCard(
              title: "Government ID",
              subtitle: docs.governmentId!.split('/').last,
              url: docs.governmentId,
            ),
          const SizedBox(height: 12),
          if (docs.businessLicence != null)
            _buildDocumentCard(
              title: "Business License",
              subtitle: docs.businessLicence!.split('/').last,
              url: docs.businessLicence,
            ),
          const SizedBox(height: 12),
          if (docs.proofOfAddress != null)
            _buildDocumentCard(
              title: "Proof of Address",
              subtitle: docs.proofOfAddress!.split('/').last,
              url: docs.proofOfAddress,
            ),
        ],
      );
    }

    if (state is DocumentFailure) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<DocumentBloc>().add(
                      FetchDocumentsRequested(),
                    ),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (state is! DocumentLoading) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 200,
          child: Center(child: Text("No documents found.")),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildDocumentCard({
    required String title,
    required String subtitle,
    String? url,
  }) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/home/doucmanticon.png',
                width: 32,
                height: 22,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.description_outlined),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Download Icon
          GestureDetector(
            onTap: () => _launchUrl(url),
            child: Image.asset(
              'assets/images/home/Download.png',
              width: 22,
              height: 24,
              color: const Color(0xFF0082D3),
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.download, color: Color(0xFF0082D3)),
            ),
          ),
        ],
      ),
    );
  }
}
