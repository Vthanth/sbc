import 'dart:io';

import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/stores/challan_info_page.store.dart';

class ChallanInfoDetailPage extends StatefulWidget {
  final String serviceUuid;
  final String customerName;

  const ChallanInfoDetailPage({super.key, required this.serviceUuid, required this.customerName});

  @override
  State<ChallanInfoDetailPage> createState() => _ChallanInfoDetailPageState();
}

class _ChallanInfoDetailPageState extends State<ChallanInfoDetailPage> {
  final _store = ChallanInfoPageStore();

  @override
  void initState() {
    super.initState();
    _store.loadChallanServiceDetail(widget.serviceUuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primarySand,
      appBar: _buildAppBar(),
      body: Observer(
        builder:
            (_) => _store.challanServiceDetail.when(
              (detail) => _buildDetailContent(detail),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, message) => _buildErrorState(error, message ?? 'Unknown error occurred'),
              none: (_) => const Center(child: Text('No data available')),
              exhausted: (_) => const Center(child: Text('No more data available')),
            ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ThemeColors.themeBlue,
      foregroundColor: ThemeColors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Service Details', style: ThemeFonts.text20Bold(textColor: ThemeColors.white)),
          Text(widget.customerName, style: ThemeFonts.text12(textColor: ThemeColors.white.withOpacity(0.8))),
        ],
      ),
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
    );
  }

  Widget _buildDetailContent(ChallanServiceDetail detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServiceCard(detail),
          const SizedBox(height: 16),
          _buildProductInfoCard(detail),
          const SizedBox(height: 16),
          _buildServiceTimelineCard(detail),
          if (detail.additionalStaff.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildStaffCard(detail.additionalStaff),
          ],
          if (detail.images.isNotEmpty) ...[const SizedBox(height: 16), _buildImagesCard(detail.images)],
          if (detail.challanPdfLink != null) ...[const SizedBox(height: 16), _buildPdfCard(detail.challanPdfLink!)],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildServiceCard(ChallanServiceDetail detail) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: ThemeColors.lightGrey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeColors.themeBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.build, color: ThemeColors.themeBlue, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Service Details', style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
                    Text(
                      'ID: ${detail.serviceUuid.substring(0, 8)}',
                      style: ThemeFonts.text12(textColor: ThemeColors.midGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(detail.ticketSubject, style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
          const SizedBox(height: 8),
          Text('Created: ${detail.ticketCreatedAt}', style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
        ],
      ),
    );
  }

  Widget _buildProductInfoCard(ChallanServiceDetail detail) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: ThemeColors.lightGrey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory, color: ThemeColors.themeBlue, size: 20),
              const SizedBox(width: 12),
              Text('Product Information', style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow('Model Number', detail.productModelNo),
          const SizedBox(height: 12),
          _buildInfoRow('Serial Number', detail.productSerialNo),
        ],
      ),
    );
  }

  Widget _buildServiceTimelineCard(ChallanServiceDetail detail) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: ThemeColors.lightGrey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: ThemeColors.themeBlue, size: 20),
              const SizedBox(width: 12),
              Text('Service Timeline', style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
            ],
          ),
          const SizedBox(height: 20),
          _buildTimelineItem(
            'Start Time',
            detail.serviceStartTime ?? 'Not Started',
            detail.serviceStartTime != null ? ThemeColors.themeBlue : ThemeColors.lightGrey,
          ),
          const SizedBox(height: 12),
          _buildTimelineItem(
            'End Time',
            detail.serviceEndTime ?? 'Not Ended',
            detail.serviceEndTime != null ? ThemeColors.notificationRed : ThemeColors.lightGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard(List<AdditionalStaff> staff) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: ThemeColors.lightGrey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people, color: ThemeColors.themeBlue, size: 20),
              const SizedBox(width: 12),
              Text('Additional Staff', style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
            ],
          ),
          const SizedBox(height: 20),
          ...staff.map(
            (member) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: ThemeColors.themeBlue, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 12),
                  Text(member.name, style: ThemeFonts.text14(textColor: ThemeColors.primaryBlack)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesCard(List<String> images) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: ThemeColors.lightGrey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.photo_library, color: ThemeColors.themeBlue, size: 20),
              const SizedBox(width: 12),
              Text('Service Images', style: ThemeFonts.text16Bold(textColor: ThemeColors.primaryBlack)),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final imageUrl = 'https://erp.sbccindia.com/storage/${images[index]}';
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: ThemeColors.lightGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.broken_image, color: ThemeColors.midGrey),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPdfCard(String pdfLink) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _launchPdf(pdfLink),
        icon: Icon(Icons.download, color: ThemeColors.white),
        label: Text('Download PDF', style: ThemeFonts.text14Bold(textColor: ThemeColors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.notificationRed,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 120, child: Text(label, style: ThemeFonts.text12(textColor: ThemeColors.midGrey))),
        Expanded(child: Text(value, style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack))),
      ],
    );
  }

  Widget _buildTimelineItem(String label, String value, Color color) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: ThemeFonts.text12(textColor: ThemeColors.midGrey)),
              Text(value, style: ThemeFonts.text14Bold(textColor: color)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(Object? error, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: ThemeColors.notificationRed),
          const SizedBox(height: 16),
          Text('Error loading details', style: ThemeFonts.text16(textColor: ThemeColors.notificationRed)),
          Text(message, style: ThemeFonts.text14(textColor: ThemeColors.midGrey)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () => _store.loadChallanServiceDetail(widget.serviceUuid), child: Text('Retry')),
        ],
      ),
    );
  }

  Future<void> _launchPdf(String url) async {
    try {
      // Show downloading toast
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Downloading...'), duration: Duration(seconds: 2)));

      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      // Create directory if it doesn't exist
      final directory = Directory(dirloc);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Generate filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'challan_${widget.serviceUuid.substring(0, 8)}_$timestamp.pdf';
      final filePath = '$dirloc$fileName';

      // Download the file
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Save the file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF downloaded successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Failed to download PDF: ${response.statusCode}');
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading PDF'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
