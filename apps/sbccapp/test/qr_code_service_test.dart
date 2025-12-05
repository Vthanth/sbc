import 'package:flutter_test/flutter_test.dart';
import 'package:sbccapp/services/qr_code_service.dart';

void main() {
  group('QRCodeService Tests', () {
    late QRCodeService qrCodeService;

    setUp(() {
      qrCodeService = QRCodeService();
    });

    test('should validate valid SBCC URLs', () {
      const validUrl = 'https://erp.sbccindia.com/order/details/950bf0e4-f93b-49e5-9aa9-1c801cc1a3a';
      expect(qrCodeService.isValidSBCCUrl(validUrl), isTrue);
    });

    test('should reject invalid URLs', () {
      const invalidUrl = 'https://example.com/order/details/123';
      expect(qrCodeService.isValidSBCCUrl(invalidUrl), isFalse);
    });

    test('should extract order ID from valid URL', () {
      const url = 'https://erp.sbccindia.com/order/details/950bf0e4-f93b-49e5-9aa9-1c801cc1a3a';
      final orderId = qrCodeService.extractOrderId(url);
      expect(orderId, equals('950bf0e4-f93b-49e5-9aa9-1c801cc1a3a'));
    });

    test('should return null for invalid URL format', () {
      const url = 'https://erp.sbccindia.com/invalid/path';
      final orderId = qrCodeService.extractOrderId(url);
      expect(orderId, isNull);
    });

    test('should handle URLs with query parameters', () {
      const url = 'https://erp.sbccindia.com/order/details/950bf0e4-f93b-49e5-9aa9-1c801cc1a3a?param=value';
      expect(qrCodeService.isValidSBCCUrl(url), isTrue);
      final orderId = qrCodeService.extractOrderId(url);
      expect(orderId, equals('950bf0e4-f93b-49e5-9aa9-1c801cc1a3a'));
    });
  });
}
