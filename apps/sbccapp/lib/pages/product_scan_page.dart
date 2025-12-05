import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/pages/product_details.dart';
import 'package:sbccapp/pages/side_drawer.dart';
import 'package:sbccapp/services/qr_code_service.dart';

class ProductScanPage extends StatefulWidget {
  const ProductScanPage({super.key});

  @override
  State<ProductScanPage> createState() => _ProductScanPageState();
}

class _ProductScanPageState extends State<ProductScanPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeColors.primarySand,
      appBar: _ProductScanAppBar(onBackPressed: () => context.pop()),
      drawer: const SideDrawer(),
      body: Column(
        children: [
          // Main Content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: ThemeColors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              ),
              child: _MainContent(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom AppBar for the product scan page
class _ProductScanAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;

  const _ProductScanAppBar({required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeColors.themeBlue,
      foregroundColor: ThemeColors.white,
      elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBackPressed),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Scan', style: ThemeFonts.text20Bold(textColor: ThemeColors.white)),
          Text('Scan and manage products', style: ThemeFonts.text12(textColor: ThemeColors.white.withOpacity(0.8))),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Main content section
class _MainContent extends StatefulWidget {
  @override
  State<_MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<_MainContent> {
  final QRCodeService _qrCodeService = GetIt.instance<QRCodeService>();
  bool _isLoading = false;
  Map<String, dynamic>? _qrCodeData;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Tap on the icon below to scan a QR code',
              textAlign: TextAlign.center,
              style: ThemeFonts.text14(textColor: ThemeColors.midGrey),
            ),
          ),
          const SizedBox(height: 32),

          // Scan Button
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: ThemeColors.themeBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: ThemeColors.themeBlue.withOpacity(0.3), width: 2),
              ),
              child: IconButton(
                onPressed: () async {
                  var status = await Permission.camera.status;
                  if (!status.isGranted) {
                    await Permission.camera.request();
                  }
                  if (status.isGranted) {
                    final scannedCode = await Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => const _QRCodeScannerPage()));

                    if (scannedCode != null) {
                      await _handleScannedCode(scannedCode);
                    }
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Camera permission is required to scan QR codes')));
                  }
                },
                icon: Icon(Icons.qr_code_scanner, size: 80, color: ThemeColors.themeBlue),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Loading indicator
          if (_isLoading)
            Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.themeBlue)),
                  const SizedBox(height: 16),
                  Text('Fetching order data...', style: ThemeFonts.text16Bold(textColor: ThemeColors.themeBlue)),
                ],
              ),
            ),

          // Error message
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_errorMessage!, style: ThemeFonts.text14(textColor: Colors.red))),
                ],
              ),
            ),

          // QR Code Data Display
          if (_qrCodeData != null)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: ThemeColors.themeBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ThemeColors.themeBlue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: ThemeColors.themeBlue, size: 20),
                      const SizedBox(width: 8),
                      Text('Product Data Retrieved', style: ThemeFonts.text16Bold(textColor: ThemeColors.themeBlue)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Product ID: ${_qrCodeData!['order_id'] ?? 'N/A'}',
                    style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_qrCodeData != null && _qrCodeData!['order_id'] != null) {
                          final productId = _qrCodeData!['order_id'];
                          Navigator.of(
                            context,
                          ).push(MaterialPageRoute(builder: (context) => ProductDetailsPage(orderId: productId)));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.themeYellow,
                        foregroundColor: ThemeColors.primaryBlack,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Product Details', style: ThemeFonts.text14Bold(textColor: ThemeColors.primaryBlack)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Handles the scanned QR code
  Future<void> _handleScannedCode(String scannedCode) async {
    // Reset state for new scan
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _qrCodeData = null;
    });

    try {
      // Validate if it's a valid SBCC URL
      if (!_qrCodeService.isValidSBCCUrl(scannedCode)) {
        setState(() {
          _errorMessage = 'Invalid QR code: Not a valid SBCC ERP URL';
          _isLoading = false;
        });
        return;
      }

      // Fetch data from the URL
      final data = await _qrCodeService.fetchQRCodeData(scannedCode);

      setState(() {
        _qrCodeData = data;
        _isLoading = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully fetched order data'), backgroundColor: ThemeColors.themeBlue),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }
}

/// QR Code Scanner Page
class _QRCodeScannerPage extends StatefulWidget {
  const _QRCodeScannerPage({super.key});

  @override
  State<_QRCodeScannerPage> createState() => __QRCodeScannerPageState();
}

class __QRCodeScannerPageState extends State<_QRCodeScannerPage> {
  bool _isScanning = true;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context); // Close scanner without returning a result
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            //allowDuplicates: false,
            onDetect: (capture) async {
              if (!_isScanning) return;
              _isScanning = false;

              final barcode = capture.barcodes.first;
              final String? code = barcode.rawValue;
              if (code != null) {
                // Show loading state
                setState(() {
                  _isProcessing = true;
                });

                // Simulate processing time to show loading
                await Future.delayed(const Duration(milliseconds: 1500));

                if (mounted) {
                  Navigator.of(context).pop(code);
                }
              } else {
                // Optional: handle error case
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to scan QR code')));
              }
            },
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Point the camera at a QR code',
                style: TextStyle(color: Colors.white, fontSize: 16, backgroundColor: Colors.black54),
              ),
            ),
          ),
          // Loading overlay
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                    const SizedBox(height: 16),
                    Text('Processing QR Code...', style: ThemeFonts.text16Bold(textColor: Colors.white)),
                    const SizedBox(height: 8),
                    Text(
                      'Please wait while we process your scan',
                      style: ThemeFonts.text14(textColor: Colors.white.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
