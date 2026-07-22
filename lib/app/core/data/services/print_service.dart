import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pharmacy_system/app/modules/admin/models/settings_model.dart';
import 'package:pharmacy_system/app/modules/admin/services/settings_service.dart';
import 'package:printing/printing.dart';

import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/quote_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';

class PrintService {
  PrintService._();

  static InvoiceLayoutSettings _layout() => SettingsService.to.settings.invoiceLayout;

  static PdfPageFormat _pageFormat() {
    final layout = _layout();
    switch (layout.paperSize) {
      case 'A4':
        return PdfPageFormat.a4;
      case '58mm':
        // ذكاء مهندسة: نحدد ارتفاع كبير جداً بدل Infinity لتجنب أخطاء Assertions
        return const PdfPageFormat(58 * PdfPageFormat.mm, 2000 * PdfPageFormat.mm, marginAll: 5 * PdfPageFormat.mm);
      default:
        // الافتراضي 80mm
        return const PdfPageFormat(80 * PdfPageFormat.mm, 2000 * PdfPageFormat.mm, marginAll: 5 * PdfPageFormat.mm);
    }
  }

  static double _fontScale() => switch (_layout().fontSize) {
        'small' => 0.85,
        'large' => 1.2,
        _ => 1.0,
      };

  static double _fs(double base) => base * _fontScale();

  // ─── Purchase Invoice ──────────────────────────────────────────

  static Future<void> printPurchaseInvoice(PurchaseModel purchase) async {
    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      pageFormat: _pageFormat(),
      margin: const pw.EdgeInsets.all(8),
      build: (ctx) => _buildAdvancedPurchaseInvoice(purchase),
    ));
    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'purchase_${purchase.receiptNumber ?? purchase.id.substring(0, 8)}.pdf',
    );
  }

  static List<pw.Widget> _buildAdvancedPurchaseInvoice(PurchaseModel purchase) {
    final layout = _layout();
    return [
      if (layout.showLogo)
        pw.Header(
          level: 0,
          child: pw.Text(AppStrings.printPurchaseInvoice, style: pw.TextStyle(fontSize: _fs(16), fontWeight: pw.FontWeight.bold)),
        ),
      if (purchase.receiptNumber != null)
        pw.Text('${AppStrings.printReceiptNumber}${purchase.receiptNumber}', textAlign: pw.TextAlign.center),
      pw.SizedBox(height: 4),
      pw.Text('${AppStrings.printInvoiceNumber}${purchase.id.substring(0, 8)}'),
      pw.Text('${AppStrings.printDate}${purchase.createdAt.year}/${purchase.createdAt.month.toString().padLeft(2, '0')}/${purchase.createdAt.day.toString().padLeft(2, '0')}'),
      pw.SizedBox(height: 2),
      pw.Divider(),
      pw.SizedBox(height: 2),
      pw.Header(level: 1, child: pw.Text(AppStrings.printSupplier, style: pw.TextStyle(fontSize: _fs(12), fontWeight: pw.FontWeight.bold))),
      pw.Text('${AppStrings.printName}${purchase.supplierName}'),
      if (purchase.supplierPhone != null) pw.Text('${AppStrings.printPhone}${purchase.supplierPhone}'),
      if (purchase.supplierPartyType != null) pw.Text('${AppStrings.printType}${purchase.supplierPartyType}'),
      pw.SizedBox(height: 4),
      pw.Divider(),
      pw.SizedBox(height: 4),
      pw.Header(level: 1, child: pw.Text(AppStrings.printItems, style: pw.TextStyle(fontSize: _fs(12), fontWeight: pw.FontWeight.bold))),
      pw.TableHelper.fromTextArray(
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: _fs(8)),
        cellStyle: pw.TextStyle(fontSize: _fs(7)),
        headerAlignment: pw.Alignment.center,
        cellAlignment: pw.Alignment.center,
        headers: [
          AppStrings.printColumnNumber,
          AppStrings.printColumnItem,
          AppStrings.printColumnUnit,
          AppStrings.printColumnQuantity,
          if (layout.showPrice) AppStrings.printColumnPrice,
          if (layout.showDiscount) AppStrings.printColumnDiscount,
          if (layout.showTax) AppStrings.printColumnTax,
          AppStrings.printColumnTotal,
          AppStrings.printColumnExpiry,
          AppStrings.printColumnBatch
        ],
        data: List.generate(purchase.items.length, (i) {
          final item = purchase.items[i];
          return [
            '${i + 1}',
            item.medicineName,
            item.unitName ?? '-',
            '${item.quantity}',
            if (layout.showPrice) item.unitPrice.toStringAsFixed(2),
            if (layout.showDiscount) item.discount != null && item.discount! > 0 ? item.discount!.toStringAsFixed(2) : '-',
            if (layout.showTax) item.taxAmount != null && item.taxAmount! > 0 ? item.taxAmount!.toStringAsFixed(2) : '-',
            item.totalPrice.toStringAsFixed(2),
            item.expiryDate != null
                ? '${item.expiryDate!.year}/${item.expiryDate!.month.toString().padLeft(2, '0')}'
                : '-',
            item.batchNumber ?? '-',
          ];
        }),
      ),
      pw.SizedBox(height: 4),
      pw.Divider(),
      pw.SizedBox(height: 4),
      _buildFinanceRow(AppStrings.printSubtotal, purchase.totalAmount.toStringAsFixed(2)),
      if (layout.showDiscount && purchase.invoiceDiscountAmount != null && purchase.invoiceDiscountAmount! > 0)
        _buildFinanceRow(
          AppStrings.printInvoiceDiscount,
          '-${purchase.invoiceDiscountAmount!.toStringAsFixed(2)}',
          color: PdfColors.red,
        ),
      if (layout.showTax && purchase.invoiceTaxAmount != null && purchase.invoiceTaxAmount! > 0)
        _buildFinanceRow(
          AppStrings.printInvoiceTax,
          purchase.invoiceTaxAmount!.toStringAsFixed(2),
          color: PdfColors.blue,
        ),
      if ((purchase.shippingAmount ?? 0) > 0)
        _buildFinanceRow(AppStrings.printShipping, purchase.shippingAmount!.toStringAsFixed(2)),
      if ((purchase.deliveryAmount ?? 0) > 0)
        _buildFinanceRow(AppStrings.printDelivery, purchase.deliveryAmount!.toStringAsFixed(2)),
      pw.SizedBox(height: 2),
      _buildFinanceRow(
        AppStrings.printFinalTotal,
        '${purchase.finalAmount.toStringAsFixed(2)} ${AppStrings.currency}',
        bold: true,
        fontSize: _fs(12),
      ),
      pw.SizedBox(height: 2),
      if (purchase.paidAmount != null)
        _buildFinanceRow(AppStrings.printPaid, '${purchase.paidAmount!.toStringAsFixed(2)} ${AppStrings.currency}'),
      if (purchase.remainingAmount > 0)
        _buildFinanceRow(
          AppStrings.printRemaining,
          '${purchase.remainingAmount.toStringAsFixed(2)} ${AppStrings.currency}',
          color: PdfColors.red,
        ),
      pw.SizedBox(height: 2),
      pw.Divider(),
      pw.SizedBox(height: 2),
      pw.Text('${AppStrings.printPaymentMethod}${_paymentLabel(purchase.paymentMethod)}'),
      if (purchase.paymentAccountName != null)
        pw.Text('${AppStrings.printPaymentAccount}${purchase.paymentAccountName}'),
      if (purchase.notes != null && purchase.notes!.isNotEmpty) ...[
        pw.SizedBox(height: 4),
        pw.Text('${AppStrings.printNotes}${purchase.notes}', style: pw.TextStyle(fontSize: _fs(8))),
      ],
      if (layout.footerText != null && layout.footerText!.isNotEmpty) ...[
        pw.SizedBox(height: 8),
        pw.Text(layout.footerText!, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: _fs(8), color: PdfColors.grey)),
      ],
      pw.SizedBox(height: 8),
      pw.Text(AppStrings.printThankYou, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: _fs(8), color: PdfColors.grey)),
    ];
  }

  static pw.Widget _buildFinanceRow(String label, String value, {bool bold = false, double fontSize = 10, PdfColor? color}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: fontSize, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Text(value, style: pw.TextStyle(fontSize: fontSize, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal, color: color)),
      ],
    );
  }

  static String _paymentLabel(String method) => switch (method) {
    'cash' => AppStrings.enumCustomerCash,
    'credit' => AppStrings.enumCustomerRegular,
    'card' => AppStrings.paymentMethodCardPurchase,
    _ => method,
  };

  // ─── Sales Invoice ─────────────────────────────────────────────

  static Future<void> printSalesInvoice(SaleModel sale) async {
    final regularData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final boldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final regular = pw.Font.ttf(regularData);
    final bold = pw.Font.ttf(boldData);
    final theme = pw.ThemeData.withFont(base: regular, bold: bold);

    final layout = _layout();
    final doc = pw.Document();
    
    doc.addPage(pw.MultiPage(
      pageFormat: _pageFormat(),
      theme: theme,
      margin: const pw.EdgeInsets.all(8),
      build: (ctx) => [
        pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              if (layout.showLogo)
                pw.Header(level: 0, child: pw.Text(AppStrings.printSalesInvoice, style: pw.TextStyle(font: bold, fontSize: _fs(16)))),
              pw.SizedBox(height: 4),
              pw.Text('${AppStrings.invoice}: ${sale.receiptNumber ?? '#${sale.id.substring(0, 8)}'}'),
              pw.Text('${AppStrings.printDate}${sale.createdAt.day}/${sale.createdAt.month}/${sale.createdAt.year}'),
              if (layout.showCustomerInfo && sale.customerName != null) pw.Text('${AppStrings.customer}: ${sale.customerName}'),
              pw.SizedBox(height: 8),
              pw.Divider(),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(font: bold, fontSize: _fs(9)),
                cellStyle: pw.TextStyle(fontSize: _fs(8)),
                headerAlignment: pw.Alignment.centerRight,
                cellAlignment: pw.Alignment.centerRight,
                headers: [
                  AppStrings.printColumnItem,
                  AppStrings.printColumnQuantity,
                  if (layout.showPrice) AppStrings.printColumnPrice,
                  AppStrings.printColumnTotal,
                ],
                data: sale.items.map((item) => [
                  item.medicineName,
                  '${item.quantity}',
                  if (layout.showPrice) item.unitPrice.toStringAsFixed(2),
                  '${item.totalPrice.toStringAsFixed(2)} ${AppStrings.currency}',
                ]).toList(),
              ),
              pw.Divider(),
              pw.Text('${AppStrings.total}: ${sale.finalAmount.toStringAsFixed(2)} ${AppStrings.currency}',
                textAlign: pw.TextAlign.left,
                style: pw.TextStyle(font: bold, fontSize: _fs(12)),
              ),
              if (layout.footerText != null && layout.footerText!.isNotEmpty) ...[
                pw.SizedBox(height: 8),
                pw.Text(layout.footerText!, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: _fs(8), color: PdfColors.grey)),
              ],
              pw.SizedBox(height: 8),
              pw.Text(AppStrings.printThankYou, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: _fs(8), color: PdfColors.grey)),
            ],
          ),
        ),
      ],
    ));
    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'sale_${sale.receiptNumber ?? sale.id.substring(0, 8)}.pdf',
    );
  }

  // ─── Return Invoice (Purchase Return) ──────────────────────────

  static Future<void> printPurchaseReturn(ReturnModel returnModel) async {
    final layout = _layout();
    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      pageFormat: _pageFormat(),
      margin: const pw.EdgeInsets.all(8),
      build: (ctx) => [
        if (layout.showLogo)
          pw.Header(level: 0, child: pw.Text(AppStrings.printPurchaseReturn, style: pw.TextStyle(fontSize: _fs(16), fontWeight: pw.FontWeight.bold))),
        pw.SizedBox(height: 4),
        if (returnModel.purchaseId != null) pw.Text('${AppStrings.printReturnedInvoice}${returnModel.purchaseId!.substring(0, 8)}'),
        pw.Text('${AppStrings.printDate}${returnModel.createdAt.day}/${returnModel.createdAt.month}/${returnModel.createdAt.year}'),
        pw.Text('${AppStrings.printReason}${returnModel.reason.name}'),
        if (returnModel.notes != null) pw.Text('${AppStrings.printNotes}${returnModel.notes}'),
        pw.SizedBox(height: 8),
        pw.Divider(),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: _fs(9)),
          cellStyle: pw.TextStyle(fontSize: _fs(8)),
          headers: [
            AppStrings.printColumnItem,
            AppStrings.printColumnQuantity,
            if (layout.showPrice) AppStrings.printColumnPrice,
            AppStrings.printColumnTotal,
          ],
          data: returnModel.items.map((item) => [
            item.medicineName,
            '${item.quantity}',
            if (layout.showPrice) item.unitPrice.toStringAsFixed(2),
            '${item.totalPrice.toStringAsFixed(2)} ${AppStrings.currency}',
          ]).toList(),
        ),
        pw.Divider(),
        pw.Text('${AppStrings.total}: ${returnModel.totalAmount.toStringAsFixed(2)} ${AppStrings.currency}',
          textAlign: pw.TextAlign.left,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: _fs(12)),
        ),
        if (layout.footerText != null && layout.footerText!.isNotEmpty) ...[
          pw.SizedBox(height: 8),
          pw.Text(layout.footerText!, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: _fs(8), color: PdfColors.grey)),
        ],
        pw.SizedBox(height: 8),
        pw.Text(AppStrings.printThankYou, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: _fs(8), color: PdfColors.grey)),
      ],
    ));
    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'return_${returnModel.id.substring(0, 8)}.pdf',
    );
  }

  // ─── Quote / Quotation ─────────────────────────────────────────

  static Future<Uint8List> buildQuotePdf(
    QuoteModel quote, {
    String pharmacyName = '',
    String branchName = '',
  }) async {
    final regularData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final boldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final regular = pw.Font.ttf(regularData);
    final bold = pw.Font.ttf(boldData);
    final theme = pw.ThemeData.withFont(base: regular, bold: bold);
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.all(28),
        build: (_) => [
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          pharmacyName.trim().isEmpty ? AppStrings.printPharmacyName : pharmacyName,
                          style: pw.TextStyle(font: bold, fontSize: 18),
                        ),
                        if (branchName.trim().isNotEmpty)
                          pw.Text(branchName, style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.Text(AppStrings.printQuote, style: pw.TextStyle(font: bold, fontSize: 24)),
                  ],
                ),
                pw.SizedBox(height: 18),
                _quoteInfoRow(AppStrings.printQuoteNumber, '#${quote.number}', bold),
                _quoteInfoRow(AppStrings.printDate, DateFormat('yyyy-MM-dd').format(quote.createdAt.toLocal()), bold),
                _quoteInfoRow(AppStrings.printQuoteCustomer, quote.customerName, bold),
                pw.SizedBox(height: 16),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  child: pw.Row(children: [
                    _quoteCell(AppStrings.printColumnNumber, 25, bold: bold),
                    _quoteCell(AppStrings.printColumnItem, 0, flex: 3, bold: bold),
                    _quoteCell(AppStrings.printColumnQuantity, 60, bold: bold),
                    _quoteCell(AppStrings.printColumnPrice, 70, bold: bold),
                    _quoteCell(AppStrings.printColumnTotal, 80, bold: bold),
                  ]),
                ),
                ...quote.items.asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;
                  return pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300)),
                    ),
                    child: pw.Row(children: [
                      _quoteCell('${i + 1}', 25),
                      _quoteCell('${item['name'] ?? ''}', 0, flex: 3),
                      _quoteCell('${item['qty'] ?? 0}', 60),
                      _quoteCell(double.tryParse('${item['unit_price'] ?? 0}')?.toStringAsFixed(2) ?? '0', 70),
                      _quoteCell(double.tryParse('${item['total'] ?? 0}')?.toStringAsFixed(2) ?? '0', 80, bold: bold),
                    ]),
                  );
                }),
                pw.SizedBox(height: 16),
                pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.SizedBox(
                    width: 240,
                    child: pw.Column(children: [
                      _quoteTotalRow(AppStrings.printSubtotal, quote.subtotal, bold),
                      if (quote.discount > 0) _quoteTotalRow(AppStrings.discount, -quote.discount, bold),
                      pw.Divider(),
                      _quoteTotalRow(AppStrings.total, quote.total, bold, emphasized: true),
                    ]),
                  ),
                ),
                if (quote.notes?.trim().isNotEmpty == true) ...[
                  pw.SizedBox(height: 18),
                  pw.Text(AppStrings.printNotesTitle, style: pw.TextStyle(font: bold)),
                  pw.Text(quote.notes!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
    return doc.save();
  }

  static Future<void> printQuote(QuoteModel quote) async {
    final bytes = await buildQuotePdf(quote);
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'quote_${quote.number}.pdf',
    );
  }

  static pw.Widget _quoteInfoRow(String label, String value, pw.Font bold) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(children: [
      pw.SizedBox(width: 90, child: pw.Text(label, style: pw.TextStyle(font: bold))),
      pw.Expanded(child: pw.Text(value)),
    ]),
  );

  static pw.Widget _quoteCell(String text, double width, {int flex = 0, pw.Font? bold}) {
    final child = pw.Text(text, style: pw.TextStyle(font: bold, fontSize: 9));
    return flex > 0 ? pw.Expanded(flex: flex, child: child) : pw.SizedBox(width: width, child: child);
  }

  static pw.Widget _quoteTotalRow(String label, double value, pw.Font bold, {bool emphasized = false}) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 3),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(font: bold, fontSize: emphasized ? 13 : 10)),
        pw.Text('${value.toStringAsFixed(2)} ${AppStrings.currency}', style: pw.TextStyle(font: bold, fontSize: emphasized ? 13 : 10)),
      ],
    ),
  );

  // ─── Shift Report ─────────────────────────────────────────────

  static Future<void> printShiftReport({
    required DateTime openedAt,
    required DateTime? closedAt,
    required double totalSales,
    required double totalReturns,
    required double netSales,
    required int salesCount,
    required double expectedCash,
    required double actualCash,
    required double difference,
    String? notes,
  }) async {
    final layout = _layout();
    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      pageFormat: _pageFormat(),
      margin: const pw.EdgeInsets.all(8),
      build: (ctx) => [
        if (layout.showLogo)
          pw.Header(level: 0, child: pw.Text(AppStrings.printShiftReport, style: pw.TextStyle(fontSize: _fs(16), fontWeight: pw.FontWeight.bold))),
        pw.SizedBox(height: 4),
        pw.Text('${AppStrings.printOpenedAt}${DateFormat('yyyy-MM-dd HH:mm').format(openedAt)}'),
        if (closedAt != null) pw.Text('${AppStrings.printClosedAt}${DateFormat('yyyy-MM-dd HH:mm').format(closedAt)}'),
        pw.Divider(),
        _buildFinanceRow(AppStrings.printSalesCount, '$salesCount'),
        _buildFinanceRow(AppStrings.printTotalSales, '${totalSales.toStringAsFixed(2)} ${AppStrings.currency}'),
        _buildFinanceRow(AppStrings.printTotalReturns, '-${totalReturns.toStringAsFixed(2)} ${AppStrings.currency}'),
        _buildFinanceRow(AppStrings.printNetSales, '${netSales.toStringAsFixed(2)} ${AppStrings.currency}', bold: true),
        pw.SizedBox(height: 8),
        pw.Text(AppStrings.printCashDetails, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        _buildFinanceRow(AppStrings.printExpectedCash, '${expectedCash.toStringAsFixed(2)} ${AppStrings.currency}'),
        _buildFinanceRow(AppStrings.printActualCash, '${actualCash.toStringAsFixed(2)} ${AppStrings.currency}'),
        _buildFinanceRow(AppStrings.printDifference, '${difference.toStringAsFixed(2)} ${AppStrings.currency}', 
          color: difference < 0 ? PdfColors.red : (difference > 0 ? PdfColors.green : null),
          bold: true),
        if (notes != null && notes.isNotEmpty) ...[
          pw.SizedBox(height: 8),
          pw.Text(AppStrings.printNotes, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: _fs(8))),
          pw.Text(notes, style: pw.TextStyle(fontSize: _fs(8))),
        ],
        if (layout.footerText != null && layout.footerText!.isNotEmpty) ...[
          pw.SizedBox(height: 8),
          pw.Text(layout.footerText!, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: _fs(8), color: PdfColors.grey)),
        ],
        pw.SizedBox(height: 12),
        pw.Text(AppStrings.printAt + DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()), style: pw.TextStyle(fontSize: _fs(7))),
      ],
    ));
    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'shift_report_${openedAt.millisecondsSinceEpoch}.pdf',
    );
  }
}

