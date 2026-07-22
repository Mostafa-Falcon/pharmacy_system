// app_strings.dart — نقطة وصول مركزية لكل نصوص المنظومة.
//
// الثوابت مُوزّعة على أقسام في مجلد [strings/] مع إتاحة الوصول المباشر
// عبر كلاسات الموديولات أو من خلال [AppStrings] للتوافق العكسي الكامل.

import 'strings/accounting_strings.dart';
import 'strings/activity_log_strings.dart';
import 'strings/admin_strings.dart';
import 'strings/archive_strings.dart';
import 'strings/auth_strings.dart';
import 'strings/crm_strings.dart';
import 'strings/customers_strings.dart';
import 'strings/export_strings.dart';
import 'strings/general_strings.dart';
import 'strings/home_strings.dart';
import 'strings/hr_strings.dart';
import 'strings/inventory_strings.dart';
import 'strings/notifications_strings.dart';
import 'strings/purchases_strings.dart';
import 'strings/reports_strings.dart';
import 'strings/sales_strings.dart';
import 'strings/stocktaking_strings.dart';
import 'strings/suppliers_strings.dart';
import 'strings/sync_strings.dart';
import 'strings/tasks_strings.dart';
import 'strings/void_operations_strings.dart';
import 'strings/widget_strings.dart';

export 'strings/accounting_strings.dart';
export 'strings/activity_log_strings.dart';
export 'strings/admin_strings.dart';
export 'strings/archive_strings.dart';
export 'strings/auth_strings.dart';
export 'strings/crm_strings.dart';
export 'strings/customers_strings.dart';
export 'strings/excel_strings.dart';
export 'strings/export_strings.dart';
export 'strings/general_strings.dart';
export 'strings/home_strings.dart';
export 'strings/hr_strings.dart';
export 'strings/inventory_strings.dart';
export 'strings/notifications_strings.dart';
export 'strings/purchases_strings.dart';
export 'strings/reports_strings.dart';
export 'strings/sales_strings.dart';
export 'strings/stocktaking_strings.dart';
export 'strings/suppliers_strings.dart';
export 'strings/sync_strings.dart';
export 'strings/tasks_strings.dart';
export 'strings/void_operations_strings.dart';
export 'strings/widget_strings.dart';

/// كلاس تجمعي رئيسي لكافة نصوص التطبيق (AppStrings)
abstract class AppStrings {
  AppStrings._();
  static const String salesTitle = SalesStrings.salesTitle;
  static const String allSales = SalesStrings.allSales;
  static const String allPurchases = PurchasesStrings.allPurchases;
  static const String allReturns = SalesStrings.allReturns;
  static const String salesSubtitle = SalesStrings.salesSubtitle;
  static const String shippingStatus = SalesStrings.shippingStatus;
  static const String paymentStatus = SalesStrings.paymentStatus;
  static const String shippingPending = SalesStrings.shippingPending;
  static const String paymentPaid = SalesStrings.paymentPaid;
  static const String paymentPartial = SalesStrings.paymentPartial;
  static const String addedBy = SalesStrings.addedBy;
  static const String contactNumber = SalesStrings.contactNumber;
  static const String paidAmount = SalesStrings.paidAmount;
  static const String dueAmount = SalesStrings.dueAmount;
  static const String viewColumns = SalesStrings.viewColumns;
  static const String inspect = SalesStrings.inspect;
  static const String invoicePayments = SalesStrings.invoicePayments;
  static const String invoiceViewLink = SalesStrings.invoiceViewLink;
  static const String createReturn = SalesStrings.createReturn;
  static const String editShipping = SalesStrings.editShipping;
  static const String deliveryNote = SalesStrings.deliveryNote;
  static const String convertToCredit = SalesStrings.convertToCredit;
  static const String newSale = SalesStrings.newSale;
  static const String posTitle = SalesStrings.posTitle;
  static const String invoiceNumberLabel = SalesStrings.invoiceNumberLabel;
  static const String customerNameLabel = SalesStrings.customerNameLabel;
  static const String paymentMethodLabel = SalesStrings.paymentMethodLabel;
  static const String finalTotal = SalesStrings.finalTotal;
  static const String totalInvoices = SalesStrings.totalInvoices;
  static const String todaySales = SalesStrings.todaySales;
  static const String thisMonthSales = SalesStrings.thisMonthSales;
  static const String creditSales = SalesStrings.creditSales;
  static const String quickFilter = SalesStrings.quickFilter;
  static const String emptySalesTitle = SalesStrings.emptySalesTitle;
  static const String emptySalesSubtitle = SalesStrings.emptySalesSubtitle;
  static const String noMatchingResults = SalesStrings.noMatchingResults;
  static const String cashCustomer = SalesStrings.cashCustomer;
  static const String totalValue = SalesStrings.totalValue;
  static const String dateTime = SalesStrings.dateTime;
  static const String viewDetails = SalesStrings.viewDetails;
  static const String voidInvoice = SalesStrings.voidInvoice;
  static const String voidInvoiceTitle = SalesStrings.voidInvoiceTitle;
  static const String voidInvoiceConfirmPrefix =
      SalesStrings.voidInvoiceConfirmPrefix;
  static const String voidInvoiceWarning = SalesStrings.voidInvoiceWarning;
  static const String yesVoidNow = SalesStrings.yesVoidNow;
  static const String posAddExpenses = SalesStrings.posAddExpenses;
  static const String posItemInquiry = SalesStrings.posItemInquiry;
  static const String posQuickItems = SalesStrings.posQuickItems;
  static const String posSuspendedSales = SalesStrings.posSuspendedSales;
  static const String posRecentTransactions =
      SalesStrings.posRecentTransactions;
  static const String posCustomerPayment = SalesStrings.posCustomerPayment;
  static const String posLoadFromCustomer = SalesStrings.posLoadFromCustomer;
  static const String posSupplierPayment = SalesStrings.posSupplierPayment;
  static const String posSalesReturn = SalesStrings.posSalesReturn;
  static const String posCalculator = SalesStrings.posCalculator;
  static const String posHideProducts = SalesStrings.posHideProducts;
  static const String posShowProducts = SalesStrings.posShowProducts;
  static const String posExitFullScreen = SalesStrings.posExitFullScreen;
  static const String posFullScreen = SalesStrings.posFullScreen;
  static const String posSessionDetails = SalesStrings.posSessionDetails;
  static const String posCloseShift = SalesStrings.posCloseShift;
  static const String promotionsTitle = SalesStrings.promotionsTitle;
  static const String createPromotion = SalesStrings.createPromotion;
  static const String promotionNameLabel = SalesStrings.promotionNameLabel;
  static const String promotionTypeLabel = SalesStrings.promotionTypeLabel;
  static const String promotionValueLabel = SalesStrings.promotionValueLabel;
  static const String promotionStartDate = SalesStrings.promotionStartDate;
  static const String promotionEndDate = SalesStrings.promotionEndDate;
  static const String promotionActiveLabel = SalesStrings.promotionActiveLabel;
  static const String damagedStockTitle = SalesStrings.damagedStockTitle;
  static const String openingStockTitle = SalesStrings.openingStockTitle;
  static const String noPromotions = SalesStrings.noPromotions;
  static const String noDamagedStock = SalesStrings.noDamagedStock;
  static const String noOpeningStock = SalesStrings.noOpeningStock;
  static const String cartTitle = SalesStrings.cartTitle;
  static const String cartProduct = SalesStrings.cartProduct;
  static const String cartQuantity = SalesStrings.cartQuantity;
  static const String cartPrice = SalesStrings.cartPrice;
  static const String cartTotal = SalesStrings.cartTotal;
  static const String cartDiscount = SalesStrings.cartDiscount;
  static const String cartItemsCount = SalesStrings.cartItemsCount;
  static const String cartPaymentCash = SalesStrings.cartPaymentCash;
  static const String cartPaymentCard = SalesStrings.cartPaymentCard;
  static const String cartPaymentCredit = SalesStrings.cartPaymentCredit;
  static const String cartPaymentMixed = SalesStrings.cartPaymentMixed;
  static const String cartSuspend = SalesStrings.cartSuspend;
  static const String cartPurchaseOrder = SalesStrings.cartPurchaseOrder;
  static const String cartSalesOrder = SalesStrings.cartSalesOrder;
  static const String cartPay = SalesStrings.cartPay;
  static const String cartVoid = SalesStrings.cartVoid;
  static const String cartEditItem = SalesStrings.cartEditItem;
  static const String cartDiscountPercent = SalesStrings.cartDiscountPercent;
  static const String cartDiscountFixed = SalesStrings.cartDiscountFixed;
  static const String cartSearchProduct = SalesStrings.cartSearchProduct;
  static const String cartAddCustomer = SalesStrings.cartAddCustomer;
  static const String shiftReportTitle = SalesStrings.shiftReportTitle;
  static const String shiftCashSales = SalesStrings.shiftCashSales;
  static const String shiftCardSales = SalesStrings.shiftCardSales;
  static const String shiftTotalSales = SalesStrings.shiftTotalSales;
  static const String shiftExpenses = SalesStrings.shiftExpenses;
  static const String shiftExpectedCash = SalesStrings.shiftExpectedCash;
  static const String shiftCountedCash = SalesStrings.shiftCountedCash;
  static const String shiftDifference = SalesStrings.shiftDifference;
  static const String shiftClosed = SalesStrings.shiftClosed;
  static const String shiftOpened = SalesStrings.shiftOpened;
  static const String shiftNoOpen = SalesStrings.shiftNoOpen;
  static const String shiftOpenTitle = SalesStrings.shiftOpenTitle;
  static const String shiftViewDetails = SalesStrings.shiftViewDetails;
  static const String searchSalesInvoicesHint = SalesStrings.searchSalesInvoicesHint;
  static const String printEnabled = SalesStrings.printEnabled;
  static const String printDisabled = SalesStrings.printDisabled;
  static const String itemsLabelSales = SalesStrings.itemsLabelSales;
  static const String invoiceLabelSales = SalesStrings.invoiceLabelSales;
  static const String options = SalesStrings.options;
  static const String resetFilters = SalesStrings.resetFilters;
  static const String showEntries = SalesStrings.showEntries;
  static const String exportCsv = SalesStrings.exportCsv;
  static const String exportExcel = SalesStrings.exportExcel;
  static const String shippingDelivered = SalesStrings.shippingDelivered;
  static const String backActionSales = SalesStrings.back;
  static const String saleInvoiceDetails = SalesStrings.saleInvoiceDetails;
  static const String errorInvalidInvoice = SalesStrings.errorInvalidInvoice;
  static const String paymentUnpaid = SalesStrings.paymentUnpaid;
  static String saleSuccessFormat(String amount) => SalesStrings.saleSuccessFormat(amount);
  static const String cashierShiftsSubtitle = SalesStrings.cashierShiftsSubtitle;
  static const String openShiftsLabel = SalesStrings.openShiftsLabel;
  static const String closedShiftsLabel = SalesStrings.closedShiftsLabel;
  static const String totalRecordsLabel = SalesStrings.totalRecordsLabel;
  static const String noShiftsMessage = SalesStrings.noShiftsMessage;
  static const String startFirstShift = SalesStrings.startFirstShift;
  static const String openedAtLabel = SalesStrings.openedAtLabel;
  static const String shiftLabel = SalesStrings.shiftLabel;
  static const String cartTableProduct = SalesStrings.cartTableProduct;
  static const String cartTableUnit = SalesStrings.cartTableUnit;
  static const String cartEmptyTitle = SalesStrings.cartEmptyTitle;
  static const String cartEmptyHint = SalesStrings.cartEmptyHint;
  static const String discountOnInvoice = SalesStrings.discountOnInvoice;
  static const String quickValuesLabel = SalesStrings.quickValuesLabel;
  static const String taxOnInvoice = SalesStrings.taxOnInvoice;
  static const String paymentMethodLabelCart = SalesStrings.paymentMethodLabelCart;
  static const String editUnitPrice = SalesStrings.editUnitPrice;
  static const String noMatchingSearchResults = SalesStrings.noMatchingSearchResults;
  static const String addToCart = SalesStrings.addToCart;
  static const String addExpensesFromCashier = SalesStrings.addExpensesFromCashier;
  static const String recordExpense = SalesStrings.recordExpense;
  static const String invalidExpenseInput = SalesStrings.invalidExpenseInput;
  static const String topRequestedItems = SalesStrings.topRequestedItems;
  static const String noItemsAvailable = SalesStrings.noItemsAvailable;
  static const String noPendingSales = SalesStrings.noPendingSales;
  static const String resumeSale = SalesStrings.resumeSale;
  static const String selectCustomerFirst = SalesStrings.selectCustomerFirst;
  static const String selectSupplierFirst = SalesStrings.selectSupplierFirst;
  static const String customerPaymentTitle = SalesStrings.customerPaymentTitle;
  static const String supplierPaymentTitle = SalesStrings.supplierPaymentTitle;
  static const String recordPayment = SalesStrings.recordPayment;
  static const String additionalDiscount = SalesStrings.additionalDiscount;
  static const String cashDiscountValue = SalesStrings.cashDiscountValue;
  static const String cancelDiscount = SalesStrings.cancelDiscount;
  static const String applyDiscount = SalesStrings.applyDiscount;
  static const String recentOperations = SalesStrings.recentOperations;
  static const String salesInvoices = SalesStrings.salesInvoices;
  static const String priceQuotes = SalesStrings.priceQuotes;
  static const String drafts = SalesStrings.drafts;
  static const String noSalesInvoices = SalesStrings.noSalesInvoices;
  static const String cashCustomerLabel = SalesStrings.cashCustomerLabel;
  static const String noPriceQuotes = SalesStrings.noPriceQuotes;
  static const String confirmDeleteQuote = SalesStrings.confirmDeleteQuote;
  static const String noDraftsPending = SalesStrings.noDraftsPending;
  static const String untitledDraft = SalesStrings.untitledDraft;
  static const String confirmDelete = SalesStrings.confirmDelete;
  static const String permanentDelete = SalesStrings.permanentDelete;
  static const String appName = GeneralStrings.appName;
  static const String pharmacyManagement = GeneralStrings.pharmacyManagement;
  static const String currency = GeneralStrings.currency;
  static const String searchHint = GeneralStrings.searchHint;
  static const String loading = GeneralStrings.loading;
  static const String success = GeneralStrings.success;
  static const String error = GeneralStrings.error;
  static const String confirm = GeneralStrings.confirm;
  static const String cancel = GeneralStrings.cancel;
  static const String delete = GeneralStrings.delete;
  static const String edit = GeneralStrings.edit;
  static const String save = GeneralStrings.save;
  static const String add = GeneralStrings.add;
  static const String all = GeneralStrings.all;
  static const String refresh = GeneralStrings.refresh;
  static const String noData = GeneralStrings.noData;
  static const String exit = GeneralStrings.exit;
  static const String close = GeneralStrings.close;
  static const String continueText = GeneralStrings.continueText;
  static const String date = GeneralStrings.date;
  static const String status = GeneralStrings.status;
  static const String export = GeneralStrings.export;
  static const String today = GeneralStrings.today;
  static const String thisMonth = GeneralStrings.thisMonth;
  static const String unit = GeneralStrings.unit;
  static const String done = GeneralStrings.done;
  static const String warning = GeneralStrings.warning;
  static const String information = GeneralStrings.information;
  static const String name = GeneralStrings.name;
  static const String phone = GeneralStrings.phone;
  static const String company = GeneralStrings.company;
  static const String balance = GeneralStrings.balance;
  static const String amount = GeneralStrings.amount;
  static const String type = GeneralStrings.type;
  static const String notes = GeneralStrings.notes;
  static const String description = GeneralStrings.description;
  static const String total = GeneralStrings.total;
  static const String subtotal = GeneralStrings.subtotal;
  static const String discount = GeneralStrings.discount;
  static const String tax = GeneralStrings.tax;
  static const String active = GeneralStrings.active;
  static const String inactive = GeneralStrings.inactive;
  static const String print = GeneralStrings.print;
  static const String share = GeneralStrings.share;
  static const String filter = GeneralStrings.filter;
  static const String startDate = GeneralStrings.startDate;
  static const String endDate = GeneralStrings.endDate;
  static const String ok = GeneralStrings.ok;
  static const String back = GeneralStrings.back;
  static const String submit = GeneralStrings.submit;
  static const String update = GeneralStrings.update;
  static const String create = GeneralStrings.create;
  static const String search = GeneralStrings.search;
  static const String reset = GeneralStrings.reset;
  static const String apply = GeneralStrings.apply;
  static const String optional = GeneralStrings.optional;
  static const String required = GeneralStrings.required;
  static const String select = GeneralStrings.select;
  static const String upload = GeneralStrings.upload;
  static const String download = GeneralStrings.download;
  static const String send = GeneralStrings.send;
  static const String receive = GeneralStrings.receive;
  static const String view = GeneralStrings.view;
  static const String hide = GeneralStrings.hide;
  static const String show = GeneralStrings.show;
  static const String open = GeneralStrings.open;
  static const String main = GeneralStrings.main;
  static const String settings = GeneralStrings.settings;
  static const String archive = GeneralStrings.archive;
  static const String deactivateLabel = GeneralStrings.deactivateLabel;
  static const String restoreLabel = GeneralStrings.restoreLabel;
  static const String voidAndDelete = GeneralStrings.voidAndDelete;
  static const String sunday = GeneralStrings.sunday;
  static const String monday = GeneralStrings.monday;
  static const String tuesday = GeneralStrings.tuesday;
  static const String wednesday = GeneralStrings.wednesday;
  static const String thursday = GeneralStrings.thursday;
  static const String friday = GeneralStrings.friday;
  static const String saturday = GeneralStrings.saturday;
  static const String january = GeneralStrings.january;
  static const String february = GeneralStrings.february;
  static const String march = GeneralStrings.march;
  static const String april = GeneralStrings.april;
  static const String may = GeneralStrings.may;
  static const String june = GeneralStrings.june;
  static const String july = GeneralStrings.july;
  static const String august = GeneralStrings.august;
  static const String september = GeneralStrings.september;
  static const String october = GeneralStrings.october;
  static const String november = GeneralStrings.november;
  static const String december = GeneralStrings.december;
  static const String enumCustomerRegular = GeneralStrings.enumCustomerRegular;
  static const String enumCustomerCash = GeneralStrings.enumCustomerCash;
  static const String enumSupplierTypeSupplier =
      GeneralStrings.enumSupplierTypeSupplier;
  static const String enumSupplierTypeBoth =
      GeneralStrings.enumSupplierTypeBoth;
  static const String enumPartyTypeCompany =
      GeneralStrings.enumPartyTypeCompany;
  static const String enumPartyTypeIndividual =
      GeneralStrings.enumPartyTypeIndividual;
  static const String lookupItemTypeMedicine =
      GeneralStrings.lookupItemTypeMedicine;
  static const String lookupItemTypeCosmetics =
      GeneralStrings.lookupItemTypeCosmetics;
  static const String lookupItemTypeMedicalTools =
      GeneralStrings.lookupItemTypeMedicalTools;
  static const String lookupGroupPainkillers =
      GeneralStrings.lookupGroupPainkillers;
  static const String lookupGroupVitamins = GeneralStrings.lookupGroupVitamins;
  static const String lookupGroupAntibiotics =
      GeneralStrings.lookupGroupAntibiotics;
  static const String defaultCashCustomer = GeneralStrings.defaultCashCustomer;
  static const String defaultPharmacy = GeneralStrings.defaultPharmacy;
  static const String defaultUnitPiece = GeneralStrings.defaultUnitPiece;
  static const String defaultCurrency = GeneralStrings.defaultCurrency;
  static const String groupGeneral = GeneralStrings.groupGeneral;
  static const String groupSilver = GeneralStrings.groupSilver;
  static const String groupGold = GeneralStrings.groupGold;
  static const String groupPlatinum = GeneralStrings.groupPlatinum;
  static const String finSummaryTitle = GeneralStrings.finSummaryTitle;
  static const String finCustomers = GeneralStrings.finCustomers;
  static const String finSuppliers = GeneralStrings.finSuppliers;
  static const String finCustomerDebts = GeneralStrings.finCustomerDebts;
  static const String finSupplierDue = GeneralStrings.finSupplierDue;
  static const String techSupportTitle = GeneralStrings.techSupportTitle;
  static const String supportContactPrefix =
      GeneralStrings.supportContactPrefix;
  static const String copyNumber = GeneralStrings.copyNumber;
  static const String openWhatsapp = GeneralStrings.openWhatsapp;
  static const String currentBranchLabel = GeneralStrings.currentBranchLabel;
  static const String switchBranchTooltip = GeneralStrings.switchBranchTooltip;
  static const String mainBranchLabel = GeneralStrings.mainBranchLabel;
  static const String syncInProgress = GeneralStrings.syncInProgress;
  static const String online = GeneralStrings.online;
  static const String offline = GeneralStrings.offline;
  static const String calculator = GeneralStrings.calculator;
  static const String cashier = GeneralStrings.cashier;
  static const String techSupport = GeneralStrings.techSupport;
  static const String lightMode = GeneralStrings.lightMode;
  static const String darkMode = GeneralStrings.darkMode;
  static const String syncErrorLabel = GeneralStrings.syncError;
  static const String synced = GeneralStrings.synced;
  static const String offlineDetailed = GeneralStrings.offlineDetailed;
  static const String syncingShort = GeneralStrings.syncingShort;
  static const String profile = GeneralStrings.profile;
  static const String menu = GeneralStrings.menu;
  static const String openMenu = GeneralStrings.openMenu;
  static const String closeMenu = GeneralStrings.closeMenu;
  static const String previous = GeneralStrings.previous;
  static const String nextLabel = GeneralStrings.nextLabel;
  static const String pageLabel = GeneralStrings.pageLabel;
  static const String copyText = GeneralStrings.copyText;
  static const String unexpectedError = GeneralStrings.unexpectedError;
  static const String permissionDenied = GeneralStrings.permissionDenied;
  static const String inProgressLabel = GeneralStrings.inProgress;
  static const String loadFailed = GeneralStrings.loadFailed;
  static const String noItems = GeneralStrings.noItems;
  static const String saveData = GeneralStrings.saveData;
  static const String saveAndAddAnother = GeneralStrings.saveAndAddAnother;
  static const String processingLabel = GeneralStrings.processing;
  static const String addNew = GeneralStrings.addNew;
  static const String yesDelete = GeneralStrings.yesDelete;
  static const String cancelUndo = GeneralStrings.cancelUndo;
  static const String searchNoResults = GeneralStrings.searchNoResults;
  static const String noRecords = GeneralStrings.noRecords;
  static const String noDataAvailableShort = GeneralStrings.noDataAvailableShort;

  // ─── Widget Strings ───
  static const String correctionHistory = WidgetStrings.correctionHistory;
  static const String correctionMore = WidgetStrings.correctionMore;
  static const String correctionCreated = WidgetStrings.correctionCreated;
  static const String correctionModified = WidgetStrings.correctionModified;
  static const String correctionVoided = WidgetStrings.correctionVoided;
  static const String correctionReturned = WidgetStrings.correctionReturned;
  static const String correctionPaymentUpdated = WidgetStrings.correctionPaymentUpdated;

  // ─── Activity Log Strings ───
  static const String activityNow = ActivityLogStrings.activityNow;
  static const String activityMinutesAgo = ActivityLogStrings.activityMinutesAgo;
  static const String activityHoursAgo = ActivityLogStrings.activityHoursAgo;

  static const String barcodeScannerTitle = WidgetStrings.barcodeScannerTitle;
  static const String barcodeScannerHint = WidgetStrings.barcodeScannerHint;
  static const String barcodeCameraDenied = WidgetStrings.barcodeCameraDenied;
  static const String barcodeCameraError = WidgetStrings.barcodeCameraError;
  static const String paymentAmountLabel = WidgetStrings.paymentAmountLabel;
  static const String paymentAmountRequired = WidgetStrings.paymentAmountRequired;
  static const String paymentValidNumber = WidgetStrings.paymentValidNumber;
  static const String paymentNotesLabel = WidgetStrings.paymentNotesLabel;
  static const String paymentNotesHint = WidgetStrings.paymentNotesHint;
  static const String paymentRecordButton = WidgetStrings.paymentRecordButton;
  static const String saleResponsibleEmployee = WidgetStrings.saleResponsibleEmployee;
  static const String saleShipping = WidgetStrings.saleShipping;
  static const String salePayments = WidgetStrings.salePayments;
  static const String saleRemaining = WidgetStrings.saleRemaining;
  static const String saleCurrentStore = WidgetStrings.saleCurrentStore;
  static const String saleActions = WidgetStrings.saleActions;
  static const String saleNoRecords = WidgetStrings.saleNoRecords;
  static const String stateViewError = WidgetStrings.stateViewError;
  static const String stateViewPermissionDenied = WidgetStrings.stateViewPermissionDenied;
  static const String progressInProgress = WidgetStrings.progressInProgress;
  static const String medicineSearchHint = WidgetStrings.medicineSearchHint;
  static const String medicineSearchPlaceholder = WidgetStrings.medicineSearchPlaceholder;
  static const String medicineSearchStock = WidgetStrings.medicineSearchStock;
  static const String medicineSearchBuyPrice = WidgetStrings.medicineSearchBuyPrice;
  static const String paginationItemLabel = WidgetStrings.paginationItemLabel;
  static const String paginationPageSize = WidgetStrings.paginationPageSize;
  static const String paginationPageFormat = WidgetStrings.paginationPageFormat;
  static const String paginationLoadedAll = WidgetStrings.paginationLoadedAll;
  static const String paginationFooterFormat = WidgetStrings.paginationFooterFormat;
  static const String paginationSelectedFormat = WidgetStrings.paginationSelectedFormat;
  static const String paginationDeselect = WidgetStrings.paginationDeselect;
  static const String paginationNoData = WidgetStrings.paginationNoData;
  static const String tableError = WidgetStrings.tableError;
  static const String tableLoadError = WidgetStrings.tableLoadError;
  static const String calculatorTitle = WidgetStrings.calculatorTitle;
  static const String calculatorResultCopied = WidgetStrings.calculatorResultCopied;
  static const String calculatorCopy = WidgetStrings.calculatorCopy;
  static const String filterClearFormat = WidgetStrings.filterClearFormat;
  static const String filterViewTable = WidgetStrings.filterViewTable;
  static const String filterViewGrid = WidgetStrings.filterViewGrid;
  static const String formSaveData = WidgetStrings.formSaveData;
  static const String formSaveAndAddAnother = WidgetStrings.formSaveAndAddAnother;
  static const String confirmDeleteYes = WidgetStrings.confirmDeleteYes;
  static const String confirmCancelUndo = WidgetStrings.confirmCancelUndo;
  static const String buttonAddNew = WidgetStrings.buttonAddNew;
  static const String listNoDataShort = WidgetStrings.listNoData;
  static const String listLoadingLabel = WidgetStrings.listLoading;
  static const String moduleProcessingLabel = WidgetStrings.moduleProcessing;

  static const String importMedicinesTitle =
      InventoryStrings.importMedicinesTitle;
  static const String importMedicinesDesc =
      InventoryStrings.importMedicinesDesc;
  static const String importMedicinesNoFile =
      InventoryStrings.importMedicinesNoFile;
  static const String importProgress = InventoryStrings.importProgress;
  static const String importButton = InventoryStrings.importButton;
  static const String importButtonLoading =
      InventoryStrings.importButtonLoading;
  static const String importSuccessPrefix =
      InventoryStrings.importSuccessPrefix;
  static const String importSuccessSuffix =
      InventoryStrings.importSuccessSuffix;
  static const String importNoData = InventoryStrings.importNoData;
  static const String importFailPrefix = InventoryStrings.importFailPrefix;
  static const String importSnackbarTitleSuccess =
      InventoryStrings.importSnackbarTitleSuccess;
  static const String importSnackbarTitleWarning =
      InventoryStrings.importSnackbarTitleWarning;
  static const String importSnackbarSuccessPrefix =
      InventoryStrings.importSnackbarSuccessPrefix;
  static const String importSnackbarSuccessSuffix =
      InventoryStrings.importSnackbarSuccessSuffix;
  static const String importSnackbarNoData =
      InventoryStrings.importSnackbarNoData;
  static const String importSnackbarTitleError =
      InventoryStrings.importSnackbarTitleError;
  static const String importSnackbarErrorPrefix =
      InventoryStrings.importSnackbarErrorPrefix;
  static const String importBranchMissing =
      InventoryStrings.importBranchMissing;
  static const String importFileMissing = InventoryStrings.importFileMissing;
  static const String importFileEmpty = InventoryStrings.importFileEmpty;
  static const String importFileNoData = InventoryStrings.importFileNoData;
  static const String importStepReading = InventoryStrings.importStepReading;
  static const String importStepParsing = InventoryStrings.importStepParsing;
  static const String importStepSaving = InventoryStrings.importStepSaving;
  static const String importStepDone = InventoryStrings.importStepDone;
  static const String importStatsFound = InventoryStrings.importStatsFound;
  static const String importStatsNew = InventoryStrings.importStatsNew;
  static const String importStatsUpdated = InventoryStrings.importStatsUpdated;
  static const String importStatsSkipped = InventoryStrings.importStatsSkipped;
  static const String importStatsSaved = InventoryStrings.importStatsSaved;
  static const String importStatsTotal = InventoryStrings.importStatsTotal;
  static const String importNewImport = InventoryStrings.importNewImport;
  static const String inventoryTitle = InventoryStrings.inventoryTitle;
  static const String inventorySubtitle = InventoryStrings.inventorySubtitle;
  static const String addMedicine = InventoryStrings.addMedicine;
  static const String editMedicine = InventoryStrings.editMedicine;
  static const String medicineNotFound = InventoryStrings.medicineNotFound;
  static const String editMedicineFor = InventoryStrings.editMedicineFor;
  static const String basicInfo = InventoryStrings.basicInfo;
  static const String itemVisualImage = InventoryStrings.itemVisualImage;
  static const String itemVisualImageOptional =
      InventoryStrings.itemVisualImageOptional;
  static const String imageNotSelected = InventoryStrings.imageNotSelected;
  static const String imageUrlHint = InventoryStrings.imageUrlHint;
  static const String imageUploadHint = InventoryStrings.imageUploadHint;
  static const String imageUrlTitle = InventoryStrings.imageUrlTitle;
  static const String imageUrlLabel = InventoryStrings.imageUrlLabel;
  static const String extraOptionsToggle = InventoryStrings.extraOptionsToggle;
  static const String strength = InventoryStrings.strength;
  static const String packageSize = InventoryStrings.packageSize;
  static const String dosageFormHint = InventoryStrings.dosageFormHint;
  static const String dosageFormLabel = InventoryStrings.dosageFormLabel;
  static const String containerShapeHint = InventoryStrings.containerShapeHint;
  static const String containerShapeLabel =
      InventoryStrings.containerShapeLabel;
  static const String storageLocation = InventoryStrings.storageLocation;
  static const String classificationAndBarcode =
      InventoryStrings.classificationAndBarcode;
  static const String itemTypeLabel = InventoryStrings.itemTypeLabel;
  static const String groupLabel = InventoryStrings.groupLabel;
  static const String generateBarcode = InventoryStrings.generateBarcode;
  static const String generateBarcodeTooltip =
      InventoryStrings.generateBarcodeTooltip;
  static const String barcodeGeneratedSuccess =
      InventoryStrings.barcodeGeneratedSuccess;
  static const String linkExtraBarcode = InventoryStrings.linkExtraBarcode;
  static const String mainBarcode = InventoryStrings.mainBarcode;
  static const String barcodeLabel = InventoryStrings.barcodeLabel;
  static const String barcodeMainLabel = InventoryStrings.barcodeMainLabel;
  static const String extraBarcodePrefix = InventoryStrings.extraBarcodePrefix;
  static const String addExtraBarcodePrefix =
      InventoryStrings.addExtraBarcodePrefix;
  static const String supplierLabel = InventoryStrings.supplierLabel;
  static const String supplierHint = InventoryStrings.supplierHint;
  static const String pricingAndUnits = InventoryStrings.pricingAndUnits;
  static const String pricingAndUnitsAdd = InventoryStrings.pricingAndUnitsAdd;
  static const String dualPricingToggle = InventoryStrings.dualPricingToggle;
  static const String addSubUnit = InventoryStrings.addSubUnit;
  static const String addSubUnitSimple = InventoryStrings.addSubUnitSimple;
  static const String addSubSubUnit = InventoryStrings.addSubSubUnit;
  static const String profitMarginPrefix = InventoryStrings.profitMarginPrefix;
  static const String profitMarginSimplePrefix =
      InventoryStrings.profitMarginSimplePrefix;
  static const String taxAndAdvanced = InventoryStrings.taxAndAdvanced;
  static const String taxAndAdvancedSimple =
      InventoryStrings.taxAndAdvancedSimple;
  static const String isTaxable = InventoryStrings.isTaxable;
  static const String isTaxableSimple = InventoryStrings.isTaxableSimple;
  static const String allowNegativeStock = InventoryStrings.allowNegativeStock;
  static const String allowNegativeStockSimple =
      InventoryStrings.allowNegativeStockSimple;
  static const String taxType = InventoryStrings.taxType;
  static const String taxPercentage = InventoryStrings.taxPercentage;
  static const String fixedTax = InventoryStrings.fixedTax;
  static const String pricesIncludeTax = InventoryStrings.pricesIncludeTax;
  static const String pricesIncludeTaxSimple =
      InventoryStrings.pricesIncludeTaxSimple;
  static const String isActiveItem = InventoryStrings.isActiveItem;
  static const String isActiveSimple = InventoryStrings.isActiveSimple;
  static const String isActiveLabel = InventoryStrings.isActiveLabel;
  static const String datePickerHint = InventoryStrings.datePickerHint;
  static const String inventorySecurity = InventoryStrings.inventorySecurity;
  static const String inventorySecurityAdd =
      InventoryStrings.inventorySecurityAdd;
  static const String lowStockAlert = InventoryStrings.lowStockAlert;
  static const String lowStockAlertOptional =
      InventoryStrings.lowStockAlertOptional;
  static const String minStockLimit = InventoryStrings.minStockLimit;
  static const String minStockLimitSimple =
      InventoryStrings.minStockLimitSimple;
  static const String expiryTracking = InventoryStrings.expiryTracking;
  static const String expiryTrackingOptional =
      InventoryStrings.expiryTrackingOptional;
  static const String currentExpiryDate = InventoryStrings.currentExpiryDate;
  static const String currentExpiryDateAdd =
      InventoryStrings.currentExpiryDateAdd;
  static const String notesAndFormulas = InventoryStrings.notesAndFormulas;
  static const String notesAndFormulasAdd =
      InventoryStrings.notesAndFormulasAdd;
  static const String cancelEdit = InventoryStrings.cancelEdit;
  static const String confirmCancelEdit = InventoryStrings.confirmCancelEdit;
  static const String unsavedChangesMessage =
      InventoryStrings.unsavedChangesMessage;
  static const String unsavedChangesSimple =
      InventoryStrings.unsavedChangesSimple;
  static const String continueEditing = InventoryStrings.continueEditing;
  static const String exitWithoutSave = InventoryStrings.exitWithoutSave;
  static const String saveAllChanges = InventoryStrings.saveAllChanges;
  static const String submittingChanges = InventoryStrings.submittingChanges;
  static const String saveMedicineFull = InventoryStrings.saveMedicineFull;
  static const String submittingMedicine = InventoryStrings.submittingMedicine;
  static const String importExcel = InventoryStrings.importExcel;
  static const String importExcelProducts = InventoryStrings.importExcelProducts;
  static const String deleteAllMedicines = InventoryStrings.deleteAllMedicines;
  static const String confirmDeleteAllTitle = InventoryStrings.confirmDeleteAllTitle;
  static const String confirmDeleteAllMessage = InventoryStrings.confirmDeleteAllMessage;
  static const String confirmDeleteSelectedTitle = InventoryStrings.confirmDeleteSelectedTitle;
  static const String confirmDeleteSelectedMessage = InventoryStrings.confirmDeleteSelectedMessage;
  static const String confirmDeleteItemTitle = InventoryStrings.confirmDeleteItemTitle;
  static const String confirmDeleteItemMessage = InventoryStrings.confirmDeleteItemMessage;
  static const String editPrice = InventoryStrings.editPrice;
  static const String totalItems = InventoryStrings.totalItems;
  static const String lowStock = InventoryStrings.lowStock;
  static const String outOfStock = InventoryStrings.outOfStock;
  static const String expired = InventoryStrings.expired;
  static const String expiringSoon = InventoryStrings.expiringSoon;
  static const String searchInventoryHint =
      InventoryStrings.searchInventoryHint;
  static const String displayCategory = InventoryStrings.displayCategory;
  static const String itemLabel = InventoryStrings.itemLabel;
  static const String emptyInventoryTitle =
      InventoryStrings.emptyInventoryTitle;
  static const String emptyInventorySubtitle =
      InventoryStrings.emptyInventorySubtitle;
  static const String importingData = InventoryStrings.importingData;
  static const String doNotClosePage = InventoryStrings.doNotClosePage;
  static const String medicineNameAr = InventoryStrings.medicineNameAr;
  static const String medicineNameEn = InventoryStrings.medicineNameEn;
  static const String inventoryHealthTitle =
      InventoryStrings.inventoryHealthTitle;
  static const String expiredItems = InventoryStrings.expiredItems;
  static const String expires30Days = InventoryStrings.expires30Days;
  static const String expires90Days = InventoryStrings.expires90Days;
  static const String lowStockItems = InventoryStrings.lowStockItems;
  static const String outOfStockItems = InventoryStrings.outOfStockItems;
  static const String expiredItemsDetailed =
      InventoryStrings.expiredItemsDetailed;
  static const String expires30DaysDetailed =
      InventoryStrings.expires30DaysDetailed;
  static const String expires90DaysDetailed =
      InventoryStrings.expires90DaysDetailed;
  static const String lowStockItemsDetailed =
      InventoryStrings.lowStockItemsDetailed;
  static const String outOfStockItemsDetailed =
      InventoryStrings.outOfStockItemsDetailed;
  static const String cleanSectionMessage =
      InventoryStrings.cleanSectionMessage;
  static const String stockBalanceLabel = InventoryStrings.stockBalanceLabel;
  static const String safetyLimitLabel = InventoryStrings.safetyLimitLabel;
  static const String expiryLabel = InventoryStrings.expiryLabel;
  static const String quickPurchaseRequest =
      InventoryStrings.quickPurchaseRequest;
  static const String mainUnitTitle = InventoryStrings.mainUnitTitle;
  static const String mainUnitTitleSimple =
      InventoryStrings.mainUnitTitleSimple;
  static const String subUnitTitle = InventoryStrings.subUnitTitle;
  static const String subUnitTitleSimple = InventoryStrings.subUnitTitleSimple;
  static const String conversionFactorInfoPrefix =
      InventoryStrings.conversionFactorInfoPrefix;
  static const String conversionFactorInfoSimplePrefix =
      InventoryStrings.conversionFactorInfoSimplePrefix;
  static const String mainUnitNameLabel = InventoryStrings.mainUnitNameLabel;
  static const String mainUnitNameLabelSimple =
      InventoryStrings.mainUnitNameLabelSimple;
  static const String subUnitNameLabel = InventoryStrings.subUnitNameLabel;
  static const String subUnitNameLabelSimple =
      InventoryStrings.subUnitNameLabelSimple;
  static const String factorLabel = InventoryStrings.factorLabel;
  static const String factorLabelSimple = InventoryStrings.factorLabelSimple;
  static const String buyPriceLabel = InventoryStrings.buyPriceLabel;
  static const String buyPriceLabelSimple =
      InventoryStrings.buyPriceLabelSimple;
  static const String sellPriceLabel = InventoryStrings.sellPriceLabel;
  static const String sellPriceLabelSimple =
      InventoryStrings.sellPriceLabelSimple;
  static const String oldSellPriceLabel = InventoryStrings.oldSellPriceLabel;
  static const String oldSellPriceLabelSimple =
      InventoryStrings.oldSellPriceLabelSimple;
  static const String currentStockLabel = InventoryStrings.currentStockLabel;
  static const String currentStockLabelSimple =
      InventoryStrings.currentStockLabelSimple;
  static const String discountLabel = InventoryStrings.discountLabel;
  static const String discountLabelSimple =
      InventoryStrings.discountLabelSimple;
  static const String allowSaleLabel = InventoryStrings.allowSaleLabel;
  static const String blockSaleLabel = InventoryStrings.blockSaleLabel;
  static const String blockSaleLabelSimple =
      InventoryStrings.blockSaleLabelSimple;
  static const String stockAdjustmentTitle = InventoryStrings.stockAdjustmentTitle;
  static const String stockAdjustmentSubtitle =
      InventoryStrings.stockAdjustmentSubtitle;
  static const String currentSystemStock = InventoryStrings.currentSystemStock;
  static const String approveNewQuantity = InventoryStrings.approveNewQuantity;
  static const String invalidStockQuantity = InventoryStrings.invalidStockQuantity;
  static const String suppliersTitle = SuppliersStrings.suppliersTitle;
  static const String addSupplier = SuppliersStrings.addSupplier;
  static const String totalSuppliers = SuppliersStrings.totalSuppliers;
  static const String activeSuppliers = SuppliersStrings.activeSuppliers;
  static const String totalBalances = SuppliersStrings.totalBalances;
  static const String searchSupplierHint = SuppliersStrings.searchSupplierHint;
  static const String supplierLabelTable = SuppliersStrings.supplierLabelTable;
  static const String phoneLabel = SuppliersStrings.phoneLabel;
  static const String companyLabel = SuppliersStrings.companyLabel;
  static const String balanceLabel = SuppliersStrings.balanceLabel;
  static const String creditLimitLabel = SuppliersStrings.creditLimitLabel;
  static const String discountLabelTable = SuppliersStrings.discountLabelTable;
  static const String typeLabel = SuppliersStrings.typeLabel;
  static const String statusLabel = SuppliersStrings.statusLabel;
  static const String noSuppliersTitle = SuppliersStrings.noSuppliersTitle;
  static const String noSuppliersSubtitle =
      SuppliersStrings.noSuppliersSubtitle;
  static const String accountStatement = SuppliersStrings.accountStatement;
  static const String currentBalanceLabel =
      SuppliersStrings.currentBalanceLabel;
  static const String amountLabel = SuppliersStrings.amountLabel;
  static const String notesLabel = SuppliersStrings.notesLabel;
  static const String cashPayment = SuppliersStrings.cashPayment;
  static const String additionNotice = SuppliersStrings.additionNotice;
  static const String discountNotice = SuppliersStrings.discountNotice;
  static const String checkPayment = SuppliersStrings.checkPayment;
  static const String checkReceipt = SuppliersStrings.checkReceipt;
  static const String recentLedgerEntries =
      SuppliersStrings.recentLedgerEntries;
  static const String noLedgerEntries = SuppliersStrings.noLedgerEntries;
  static const String exportTitleLedger = ExportStrings.exportTitleLedger;
  static const String exportCustomerLedger = ExportStrings.exportCustomerLedger;
  static const String exportSupplierLedger = ExportStrings.exportSupplierLedger;
  static const String exportColumnDate = ExportStrings.exportColumnDate;
  static const String exportColumnDescription =
      ExportStrings.exportColumnDescription;
  static const String exportColumnDebit = ExportStrings.exportColumnDebit;
  static const String exportColumnCredit = ExportStrings.exportColumnCredit;
  static const String exportColumnBalance = ExportStrings.exportColumnBalance;
  static const String exportColumnName = ExportStrings.exportColumnName;
  static const String exportColumnType = ExportStrings.exportColumnType;
  static const String exportColumnPartyType =
      ExportStrings.exportColumnPartyType;
  static const String exportColumnPhone = ExportStrings.exportColumnPhone;
  static const String exportColumnCompany = ExportStrings.exportColumnCompany;
  static const String exportColumnEmail = ExportStrings.exportColumnEmail;
  static const String exportColumnTaxId = ExportStrings.exportColumnTaxId;
  static const String exportColumnAddress = ExportStrings.exportColumnAddress;
  static const String exportColumnCreditLimit =
      ExportStrings.exportColumnCreditLimit;
  static const String exportColumnDiscountPercent =
      ExportStrings.exportColumnDiscountPercent;
  static const String exportColumnPaymentTerm =
      ExportStrings.exportColumnPaymentTerm;
  static const String exportColumnStatus = ExportStrings.exportColumnStatus;
  static const String exportFileError = ExportStrings.exportFileError;
  static const String exportCustomerList = ExportStrings.exportCustomerList;
  static const String exportSupplierList = ExportStrings.exportSupplierList;
  static const String exportDatePrefix = ExportStrings.exportDatePrefix;
  static const String exportStatusActive = ExportStrings.exportStatusActive;
  static const String exportStatusInactive = ExportStrings.exportStatusInactive;
  static const String entryTypeOpeningBalance =
      ExportStrings.entryTypeOpeningBalance;
  static const String entryTypeSaleInvoice = ExportStrings.entryTypeSaleInvoice;
  static const String entryTypeSaleReturn = ExportStrings.entryTypeSaleReturn;
  static const String entryTypePayment = ExportStrings.entryTypePayment;
  static const String entryTypeVoidInvoice = ExportStrings.entryTypeVoidInvoice;
  static const String entryTypeManualAdjustment =
      ExportStrings.entryTypeManualAdjustment;
  static const String entryTypeAddition = ExportStrings.entryTypeAddition;
  static const String entryTypeDiscount = ExportStrings.entryTypeDiscount;
  static const String entryTypeCheckReceipt =
      ExportStrings.entryTypeCheckReceipt;
  static const String entryTypeCheckPayment =
      ExportStrings.entryTypeCheckPayment;
  static const String entryTypePurchaseInvoice =
      ExportStrings.entryTypePurchaseInvoice;
  static const String printPurchaseInvoice = ExportStrings.printPurchaseInvoice;
  static const String printSalesInvoice = ExportStrings.printSalesInvoice;
  static const String printReceiptNumber = ExportStrings.printReceiptNumber;
  static const String printInvoiceNumber = ExportStrings.printInvoiceNumber;
  static const String printDate = ExportStrings.printDate;
  static const String printSupplier = ExportStrings.printSupplier;
  static const String printName = ExportStrings.printName;
  static const String printPhone = ExportStrings.printPhone;
  static const String printType = ExportStrings.printType;
  static const String printItems = ExportStrings.printItems;
  static const String printColumnNumber = ExportStrings.printColumnNumber;
  static const String printColumnItem = ExportStrings.printColumnItem;
  static const String printColumnUnit = ExportStrings.printColumnUnit;
  static const String printColumnQuantity = ExportStrings.printColumnQuantity;
  static const String printColumnPrice = ExportStrings.printColumnPrice;
  static const String printColumnDiscount = ExportStrings.printColumnDiscount;
  static const String printColumnTax = ExportStrings.printColumnTax;
  static const String printColumnTotal = ExportStrings.printColumnTotal;
  static const String printColumnExpiry = ExportStrings.printColumnExpiry;
  static const String printColumnBatch = ExportStrings.printColumnBatch;
  static const String printSubtotal = ExportStrings.printSubtotal;
  static const String printInvoiceDiscount = ExportStrings.printInvoiceDiscount;
  static const String printInvoiceTax = ExportStrings.printInvoiceTax;
  static const String printShipping = ExportStrings.printShipping;
  static const String printDelivery = ExportStrings.printDelivery;
  static const String printFinalTotal = ExportStrings.printFinalTotal;
  static const String printPaid = ExportStrings.printPaid;
  static const String printRemaining = ExportStrings.printRemaining;
  static const String printPaymentMethod = ExportStrings.printPaymentMethod;
  static const String printPaymentAccount = ExportStrings.printPaymentAccount;
  static const String printNotes = ExportStrings.printNotes;
  static const String printThankYou = ExportStrings.printThankYou;
  static const String printPurchaseReturn = ExportStrings.printPurchaseReturn;
  static const String printReturnedInvoice = ExportStrings.printReturnedInvoice;
  static const String printReason = ExportStrings.printReason;
  static const String printQuote = ExportStrings.printQuote;
  static const String printQuoteNumber = ExportStrings.printQuoteNumber;
  static const String printQuoteCustomer = ExportStrings.printQuoteCustomer;
  static const String printPharmacyName = ExportStrings.printPharmacyName;
  static const String printNotesTitle = ExportStrings.printNotesTitle;
  static const String printShiftReport = ExportStrings.printShiftReport;
  static const String printOpenedAt = ExportStrings.printOpenedAt;
  static const String printClosedAt = ExportStrings.printClosedAt;
  static const String printSalesCount = ExportStrings.printSalesCount;
  static const String printTotalSales = ExportStrings.printTotalSales;
  static const String printTotalReturns = ExportStrings.printTotalReturns;
  static const String printNetSales = ExportStrings.printNetSales;
  static const String printCashDetails = ExportStrings.printCashDetails;
  static const String printExpectedCash = ExportStrings.printExpectedCash;
  static const String printActualCash = ExportStrings.printActualCash;
  static const String printDifference = ExportStrings.printDifference;
  static const String printAt = ExportStrings.printAt;
  static const String reportsTitle = ReportsStrings.reportsTitle;
  static const String reportsExtra = ReportsStrings.reportsExtra;
  static const String reportsSales = ReportsStrings.reportsSales;
  static const String reportsPurchases = ReportsStrings.reportsPurchases;
  static const String reportsProfit = ReportsStrings.reportsProfit;
  static const String reportsInventory = ReportsStrings.reportsInventory;
  static const String reportsStocktake = ReportsStrings.reportsStocktake;
  static const String reportsPopularItems = ReportsStrings.reportsPopularItems;
  static const String reportsItemMovement = ReportsStrings.reportsItemMovement;
  static const String reportsTaxSummary = ReportsStrings.reportsTaxSummary;
  static const String reportsEmployeeActivity =
      ReportsStrings.reportsEmployeeActivity;
  static const String reportsCustomRange = ReportsStrings.reportsCustomRange;
  static const String reportsThisWeek = ReportsStrings.reportsThisWeek;
  static const String reportsThisMonth = ReportsStrings.reportsThisMonth;
  static const String reportsThisYear = ReportsStrings.reportsThisYear;
  static const String reportsCustom = ReportsStrings.reportsCustom;
  static const String reportsOperationalExpenses =
      ReportsStrings.reportsOperationalExpenses;
  static const String reportsJournalIntegrity =
      ReportsStrings.reportsJournalIntegrity;
  static const String reportsDailyBalance = ReportsStrings.reportsDailyBalance;
  static const String reportsInventoryValue =
      ReportsStrings.reportsInventoryValue;
  static const String reportsInventoryMovement =
      ReportsStrings.reportsInventoryMovement;
  static const String reportsBestSelling = ReportsStrings.reportsBestSelling;
  static const String reportsItemTransactionMovements =
      ReportsStrings.reportsItemTransactionMovements;
  static const String reportsTaxDetails = ReportsStrings.reportsTaxDetails;
  static const String reportsEmployeeActivityLog =
      ReportsStrings.reportsEmployeeActivityLog;
  static const String taxSummaryEmpty = ReportsStrings.taxSummaryEmpty;
  static const String taxSummarySalesTax = ReportsStrings.taxSummarySalesTax;
  static const String taxSummaryPurchaseTax =
      ReportsStrings.taxSummaryPurchaseTax;
  static const String taxSummaryExpenseTax =
      ReportsStrings.taxSummaryExpenseTax;
  static const String taxSummaryNet = ReportsStrings.taxSummaryNet;
  static const String taxColumnDate = ReportsStrings.taxColumnDate;
  static const String taxColumnType = ReportsStrings.taxColumnType;
  static const String taxColumnRef = ReportsStrings.taxColumnRef;
  static const String taxColumnParty = ReportsStrings.taxColumnParty;
  static const String taxColumnMethod = ReportsStrings.taxColumnMethod;
  static const String taxColumnBase = ReportsStrings.taxColumnBase;
  static const String activityEmpty = ReportsStrings.activityEmpty;
  static const String activityCount = ReportsStrings.activityCount;
  static const String activityShifts = ReportsStrings.activityShifts;
  static const String activityUsers = ReportsStrings.activityUsers;
  static const String activityEmployee = ReportsStrings.activityEmployee;
  static const String invReportEmpty = ReportsStrings.invReportEmpty;
  static const String invReportPotentialProfit =
      ReportsStrings.invReportPotentialProfit;
  static const String invReportTotalUnits = ReportsStrings.invReportTotalUnits;
  static const String invReportBuyPrice = ReportsStrings.invReportBuyPrice;
  static const String invReportSellPrice = ReportsStrings.invReportSellPrice;
  static const String invReportBuyValue = ReportsStrings.invReportBuyValue;
  static const String invReportSellValue = ReportsStrings.invReportSellValue;
  static const String invReportProfit = ReportsStrings.invReportProfit;
  static const String invReportBuyLabel = ReportsStrings.invReportBuyLabel;
  static const String invReportSellLabel = ReportsStrings.invReportSellLabel;
  static const String contactReportTitle = ReportsStrings.contactReportTitle;
  static const String contactFilterAll = ReportsStrings.contactFilterAll;
  static const String contactFilterCustomers =
      ReportsStrings.contactFilterCustomers;
  static const String contactFilterSuppliers =
      ReportsStrings.contactFilterSuppliers;
  static const String contactFilterDebtors =
      ReportsStrings.contactFilterDebtors;
  static const String adminDashboard = AdminStrings.adminDashboard;
  static const String adminSettings = AdminStrings.adminSettings;
  static const String adminSettingsSubtitle =
      AdminStrings.adminSettingsSubtitle;
  static const String adminSearchSettings = AdminStrings.adminSearchSettings;
  static const String adminQuickControl = AdminStrings.adminQuickControl;
  static const String adminEnableSounds = AdminStrings.adminEnableSounds;
  static const String adminAutoPrint = AdminStrings.adminAutoPrint;

  static const String branchesManagementTitle = AdminStrings.branchesManagementTitle;
  static const String branchesManagementSubtitle = AdminStrings.branchesManagementSubtitle;
  static const String activeBranchesListLabel = AdminStrings.activeBranchesListLabel;
  static const String addBranchAction = AdminStrings.addBranchAction;
  static const String noBranchesFound = AdminStrings.noBranchesFound;
  static const String noAddressDefined = AdminStrings.noAddressDefined;
  static const String editBranchTooltip = AdminStrings.editBranchTooltip;
  static const String deleteBranchTooltip = AdminStrings.deleteBranchTooltip;
  static const String addBranchDialogTitle = AdminStrings.addBranchDialogTitle;
  static const String branchFullNameLabel = AdminStrings.branchFullNameLabel;
  static const String branchNameExampleHint = AdminStrings.branchNameExampleHint;
  static const String branchDetailedAddressLabel = AdminStrings.branchDetailedAddressLabel;
  static const String branchAddressExampleHint = AdminStrings.branchAddressExampleHint;
  static const String branchPhoneLabel = AdminStrings.branchPhoneLabel;
  static const String branchPhoneExampleHint = AdminStrings.branchPhoneExampleHint;
  static const String cancelAddBranchAction = AdminStrings.cancelAddBranchAction;
  static const String confirmAddBranchAction = AdminStrings.confirmAddBranchAction;
  static const String enterBranchNameWarning = AdminStrings.enterBranchNameWarning;
  static const String importantWarningTitle = AdminStrings.importantWarningTitle;
  static const String editBranchDialogTitle = AdminStrings.editBranchDialogTitle;
  static const String cancelEditBranchAction = AdminStrings.cancelEditBranchAction;
  static const String saveBranchChangesAction = AdminStrings.saveBranchChangesAction;
  static const String cannotClearBranchNameWarning = AdminStrings.cannotClearBranchNameWarning;
  static const String importantSecurityWarningTitle = AdminStrings.importantSecurityWarningTitle;
  static const String deleteBranchConfirmFormat = AdminStrings.deleteBranchConfirmFormat;
  static const String confirmDeleteBranchAction = AdminStrings.confirmDeleteBranchAction;

  static const String permissionsTitle = AdminStrings.permissionsTitle;
  static const String permissionsSubtitle = AdminStrings.permissionsSubtitle;
  static const String permissionsSelectEmployee =
      AdminStrings.permissionsSelectEmployee;
  static const String permissionsEmployeeHint =
      AdminStrings.permissionsEmployeeHint;
  static const String permissionsEmpty = AdminStrings.permissionsEmpty;
  static const String permissionsBoardPrefix =
      AdminStrings.permissionsBoardPrefix;
  static const String permissionsGrantAll = AdminStrings.permissionsGrantAll;
  static const String permissionsRevokeAll = AdminStrings.permissionsRevokeAll;
  static const String docControlTitle = AdminStrings.docControlTitle;
  static const String docControlSubtitle = AdminStrings.docControlSubtitle;
  static const String docControlHeader = AdminStrings.docControlHeader;
  static const String docControlHeaderSubtitle =
      AdminStrings.docControlHeaderSubtitle;
  static const String docControlEmpty = AdminStrings.docControlEmpty;
  static const String docActionCreated = AdminStrings.docActionCreated;
  static const String docActionModified = AdminStrings.docActionModified;
  static const String docActionCancelled = AdminStrings.docActionCancelled;
  static const String docActionRestored = AdminStrings.docActionRestored;
  static const String docActionPaymentModified = AdminStrings.docActionPaymentModified;
  static const String empManagementTitle = AdminStrings.empManagement;
  static const String empManagementSubtitle = AdminStrings.empManagementSubtitle;
  static const String empAddAction = AdminStrings.empAdd;
  static const String empTotalFormat = AdminStrings.empTotalFormat;
  static const String empNoAccounts = AdminStrings.empNoAccounts;
  static const String empAddStartHint = AdminStrings.empAddStartHint;
  static const String empAddDialogTitle = AdminStrings.empAddDialog;
  static const String empNameLabel = AdminStrings.empFullName;
  static const String empEmailLabel = AdminStrings.empEmailLabel;
  static const String empDefaultPasswordLabel = AdminStrings.empDefaultPassword;
  static const String empRoleTasksLabel = AdminStrings.empRole;
  static const String empSelectRoleHint = AdminStrings.empRoleHint;
  static const String empRolePharmacistLabel = AdminStrings.empRolePharmacist;
  static const String empRoleCashierLabel = AdminStrings.empRoleCashier;
  static const String empRoleInventoryLabel = AdminStrings.empRoleInventoryManager;
  static const String empRoleGeneralLabel = AdminStrings.empRoleGeneral;
  static const String empBranchLabel = AdminStrings.empBranch;
  static const String empSelectBranchHint = AdminStrings.empBranchHint;
  static const String empNoBranchAssigned = AdminStrings.empNoBranch;
  static const String empUnknownBranch = AdminStrings.empUnknownBranch;
  static const String empCancelAction = AdminStrings.empCancel;
  static const String empConfirmAction = AdminStrings.empConfirm;
  static const String empFieldsRequiredError = AdminStrings.empFieldsRequired;
  static const String empSecurityAlertTitle = AdminStrings.empSecurityAlert;
  static const String empEditDialogTitle = AdminStrings.empEdit;
  static const String empEditNameLabel = AdminStrings.empEditName;
  static const String empEditEmailLabel = AdminStrings.empEditEmail;
  static const String empEditRoleLabel = AdminStrings.empEditRole;
  static const String empEditRoleHint = AdminStrings.empEditRoleHint;
  static const String empEditBranchHint = AdminStrings.empEditBranchHint;
  static const String empSaveChangesAction = AdminStrings.empSaveChanges;
  static const String empRequiredFieldsError = AdminStrings.empFieldsError;
  static const String empDeleteConfirmTitle = AdminStrings.empDeactivateTitle;
  static const String empDeleteConfirmMessageFormat = AdminStrings.empDeactivateConfirmFormat;
  static const String empDeleteActionLabel = AdminStrings.empDeactivateYes;
  static const String empActivatedSuccessFormat = AdminStrings.empActivatedFormat;
  static const String empDeactivatedWarningFormat = AdminStrings.empDeactivatedFormat;
  static const String empStatusUpdateTitle = AdminStrings.empStatusUpdate;
  static const String empBadgeOwnerLabel = AdminStrings.empBadgeOwner;
  static const String empBadgeActiveLabel = AdminStrings.empBadgeActive;
  static const String empBadgeFrozenLabel = AdminStrings.empBadgeFrozen;
  static const String empFreezeAction = AdminStrings.empFreeze;
  static const String empActivateAction = AdminStrings.empActivate;
  static const String editData = AdminStrings.editData;
  static const String deleteEmployee = AdminStrings.deleteEmployee;
  static const String roleOwner = AdminStrings.roleOwner;
  static const String roleManager = AdminStrings.roleManager;
  static const String rolePharmacist = AdminStrings.rolePharmacist;
  static const String roleAccountant = AdminStrings.roleAccountant;
  static const String roleCashier = AdminStrings.roleCashier;
  static const String roleSupervisor = AdminStrings.roleSupervisor;
  static const String roleShiftPharmacist = AdminStrings.roleShiftPharmacist;
  static const String profileTitle = AdminStrings.profileTitle;
  static const String profileSubtitle = AdminStrings.profileSubtitle;
  static const String profilePersonalInfo = AdminStrings.profilePersonalInfo;
  static const String profileFullName = AdminStrings.profileFullName;
  static const String profileEmail = AdminStrings.profileEmail;
  static const String profileRole = AdminStrings.profileRole;
  static const String profileBranch = AdminStrings.profileBranch;
  static const String profileDefaultBranch = AdminStrings.profileDefaultBranch;
  static const String profileSecurity = AdminStrings.profileSecurity;
  static const String profileDeviceManagement = AdminStrings.profileDeviceManagement;
  static const String profileEditData = AdminStrings.profileEditData;
  static const String profileChangePassword =
      AdminStrings.profileChangePassword;
  static const String profileEditDialog = AdminStrings.profileEditDialog;
  static const String profileEditName = AdminStrings.profileEditName;
  static const String profileSaveEdit = AdminStrings.profileSaveEdit;
  static const String profileNameRequired = AdminStrings.profileNameRequired;
  static const String profileEditSuccess = AdminStrings.profileEditSuccess;
  static const String profileChangePasswordDialog =
      AdminStrings.profileChangePasswordDialog;
  static const String profileCurrentPassword =
      AdminStrings.profileCurrentPassword;
  static const String profileNewPassword = AdminStrings.profileNewPassword;
  static const String profileConfirmPassword = AdminStrings.profileConfirmPassword;
  static const String profileSecurityAlert = AdminStrings.profileSecurityAlert;
  static const String deviceAccountOpen = AdminStrings.deviceAccountOpen;
  static const String multiDeviceInfo = AdminStrings.multiDeviceInfo;
  static const String profileUpdateAccount = AdminStrings.profileUpdateAccount;
  static const String profilePasswordFieldsRequired =
      AdminStrings.profilePasswordFieldsRequired;
  static const String profilePasswordChanged =
      AdminStrings.profilePasswordChanged;
  static const String permDashboard = AdminStrings.permDashboard;
  static const String permPos = AdminStrings.permPos;
  static const String permInventory = AdminStrings.permInventory;
  static const String permAddEditItems = AdminStrings.permAddEditItems;
  static const String permCategories = AdminStrings.permCategories;
  static const String permStocktake = AdminStrings.permStocktake;
  static const String permCustomers = AdminStrings.permCustomers;
  static const String permSuppliers = AdminStrings.permSuppliers;
  static const String permReports = AdminStrings.permReports;
  static const String permSettings = AdminStrings.permSettings;
  static const String permAdminPanel = AdminStrings.permAdminPanel;
  static const String permEmployeeData = AdminStrings.permEmployeeData;
  static const String permManageBranches = AdminStrings.permManageBranches;
  static const String permManagePermissions =
      AdminStrings.permManagePermissions;
  static const String permCreateInvoices = AdminStrings.permCreateInvoices;
  static const String permVoidInvoices = AdminStrings.permVoidInvoices;
  static const String permSalesReturns = AdminStrings.permSalesReturns;
  static const String permAdjustStock = AdminStrings.permAdjustStock;
  static const String permDeleteItem = AdminStrings.permDeleteItem;
  static const String permManageTeam = AdminStrings.permManageTeam;
  static const String permManageBranchesFull =
      AdminStrings.permManageBranchesFull;
  static const String permProfitReports = AdminStrings.permProfitReports;
  static const String permExportInventory = AdminStrings.permExportInventory;
  static const String permManageRoles = AdminStrings.permManageRoles;
  static const String settingsTabProject = AdminStrings.settingsTabProject;
  static const String settingsTabTax = AdminStrings.settingsTabTax;
  static const String settingsTabItem = AdminStrings.settingsTabItem;
  static const String settingsTabSale = AdminStrings.settingsTabSale;
  static const String settingsTabSystem = AdminStrings.settingsTabSystem;
  static const String settingsTabEmail = AdminStrings.settingsTabEmail;
  static const String settingsTabSms = AdminStrings.settingsTabSms;
  static const String settingsTabRewards = AdminStrings.settingsTabRewards;
  static const String settingsTabShortcuts = AdminStrings.settingsTabShortcuts;
  static const String settingsTabExtraUnits =
      AdminStrings.settingsTabExtraUnits;
  static const String settingsTabInvoiceLayout =
      AdminStrings.settingsTabInvoiceLayout;
  static const String invoiceLayoutTitle = AdminStrings.invoiceLayoutTitle;
  static const String invoiceLayoutDescription =
      AdminStrings.invoiceLayoutDescription;
  static const String invoiceLayoutShowLogo =
      AdminStrings.invoiceLayoutShowLogo;
  static const String invoiceLayoutShowCustomer =
      AdminStrings.invoiceLayoutShowCustomer;
  static const String invoiceLayoutShowTax =
      AdminStrings.invoiceLayoutShowTax;
  static const String invoiceLayoutShowDiscount =
      AdminStrings.invoiceLayoutShowDiscount;
  static const String invoiceLayoutShowBarcode =
      AdminStrings.invoiceLayoutShowBarcode;
  static const String invoiceLayoutShowPrice =
      AdminStrings.invoiceLayoutShowPrice;
  static const String invoiceLayoutPaperSize =
      AdminStrings.invoiceLayoutPaperSize;
  static const String invoiceLayoutFontSize =
      AdminStrings.invoiceLayoutFontSize;
  static const String invoiceLayoutFooterText =
      AdminStrings.invoiceLayoutFooterText;
  static const String accountingTitle = AccountingStrings.accountingTitle;
  static const String accountingIndicators =
      AccountingStrings.accountingIndicators;
  static const String accountingExpenses = AccountingStrings.accountingExpenses;
  static const String accountingJournal = AccountingStrings.accountingJournal;
  static const String accountingPayments = AccountingStrings.accountingPayments;
  static const String accountingError = AccountingStrings.accountingError;
  static const String accountingTotalRevenue =
      AccountingStrings.accountingTotalRevenue;
  static const String accountingTotalExpenses =
      AccountingStrings.accountingTotalExpenses;
  static const String accountingNetProfit =
      AccountingStrings.accountingNetProfit;
  static const String accountingRecentJournals =
      AccountingStrings.accountingRecentJournals;
  static const String accountingNoJournals =
      AccountingStrings.accountingNoJournals;
  static const String accountingNoJournalsSubtitle =
      AccountingStrings.accountingNoJournalsSubtitle;
  static const String accountingJournalPrefix =
      AccountingStrings.accountingJournalPrefix;
  static const String accountingBalanced = AccountingStrings.accountingBalanced;
  static const String accountingEntrySale =
      AccountingStrings.accountingEntrySale;
  static const String accountingEntryPurchase =
      AccountingStrings.accountingEntryPurchase;
  static const String accountingEntryExpense =
      AccountingStrings.accountingEntryExpense;
  static const String accountingEntryPayment =
      AccountingStrings.accountingEntryPayment;
  static const String accountingEntryReceipt =
      AccountingStrings.accountingEntryReceipt;
  static const String accountingNoExpenses =
      AccountingStrings.accountingNoExpenses;
  static const String accountingNoExpensesSubtitle =
      AccountingStrings.accountingNoExpensesSubtitle;
  static const String accountingExpensePrefix =
      AccountingStrings.accountingExpensePrefix;
  static const String accountingExpenseCategoryRent =
      AccountingStrings.accountingExpenseCategoryRent;
  static const String accountingExpenseCategorySalaries =
      AccountingStrings.accountingExpenseCategorySalaries;
  static const String accountingExpenseCategoryBills =
      AccountingStrings.accountingExpenseCategoryBills;
  static const String accountingExpenseCategoryMaintenance =
      AccountingStrings.accountingExpenseCategoryMaintenance;
  static const String accountingExpenseCategoryMarketing =
      AccountingStrings.accountingExpenseCategoryMarketing;
  static const String accountingExpenseCategoryShipping =
      AccountingStrings.accountingExpenseCategoryShipping;
  static const String accountingExpenseCategoryOther =
      AccountingStrings.accountingExpenseCategoryOther;
  static const String accountingAddExpense =
      AccountingStrings.accountingAddExpense;
  static const String accountingExpenseCategory =
      AccountingStrings.accountingExpenseCategory;
  static const String accountingExpenseCategoryHint =
      AccountingStrings.accountingExpenseCategoryHint;
  static const String accountingExpenseDescription =
      AccountingStrings.accountingExpenseDescription;
  static const String accountingExpenseAmount =
      AccountingStrings.accountingExpenseAmount;
  static const String accountingExpensePaymentMethod =
      AccountingStrings.accountingExpensePaymentMethod;
  static const String accountingExpensePaymentHint =
      AccountingStrings.accountingExpensePaymentHint;
  static const String accountingSaveEntry =
      AccountingStrings.accountingSaveEntry;
  static const String accountingValidAmount =
      AccountingStrings.accountingValidAmount;
  static const String accountingJournalNoEntries =
      AccountingStrings.accountingJournalNoEntries;
  static const String accountingJournalNoEntriesSubtitle =
      AccountingStrings.accountingJournalNoEntriesSubtitle;
  static const String accountingJournalEntryPrefix =
      AccountingStrings.accountingJournalEntryPrefix;
  static const String accountingJournalBalancedLabel =
      AccountingStrings.accountingJournalBalancedLabel;
  static const String accountingJournalDescription =
      AccountingStrings.accountingJournalDescription;
  static const String partyPaymentsReceipts =
      AccountingStrings.partyPaymentsReceipts;
  static const String partyPaymentsPayments =
      AccountingStrings.partyPaymentsPayments;
  static const String partyPaymentsNew = AccountingStrings.partyPaymentsNew;
  static const String partyPaymentsType = AccountingStrings.partyPaymentsType;
  static const String partyPaymentsTypeHint =
      AccountingStrings.partyPaymentsTypeHint;
  static const String partyPaymentsCustomerReceipt =
      AccountingStrings.partyPaymentsCustomerReceipt;
  static const String partyPaymentsSupplierPayment =
      AccountingStrings.partyPaymentsSupplierPayment;
  static const String partyPaymentsCustomerTarget =
      AccountingStrings.partyPaymentsCustomerTarget;
  static const String partyPaymentsSupplierTarget =
      AccountingStrings.partyPaymentsSupplierTarget;
  static const String partyPaymentsAccountHint =
      AccountingStrings.partyPaymentsAccountHint;
  static const String partyPaymentsUnknownAccount =
      AccountingStrings.partyPaymentsUnknownAccount;
  static const String partyPaymentsAmount =
      AccountingStrings.partyPaymentsAmount;
  static const String partyPaymentsChannel =
      AccountingStrings.partyPaymentsChannel;
  static const String partyPaymentsChannelHint =
      AccountingStrings.partyPaymentsChannelHint;
  static const String partyPaymentsCashMethod =
      AccountingStrings.partyPaymentsCashMethod;
  static const String partyPaymentsCardMethod =
      AccountingStrings.partyPaymentsCardMethod;
  static const String partyPaymentsBankMethod =
      AccountingStrings.partyPaymentsBankMethod;
  static const String partyPaymentsWalletMethod =
      AccountingStrings.partyPaymentsWalletMethod;
  static const String partyPaymentsNotes = AccountingStrings.partyPaymentsNotes;
  static const String partyPaymentsConfirm =
      AccountingStrings.partyPaymentsConfirm;
  static const String partyPaymentsEmpty = AccountingStrings.partyPaymentsEmpty;
  static const String partyPaymentsEmptySubtitle =
      AccountingStrings.partyPaymentsEmptySubtitle;
  static const String partyPaymentsNumberPrefix =
      AccountingStrings.partyPaymentsNumberPrefix;
  static const String msgExpenseSaved = AccountingStrings.msgExpenseSaved;
  static const String msgExpenseFailed = AccountingStrings.msgExpenseFailed;
  static const String msgExpenseDeleted = AccountingStrings.msgExpenseDeleted;
  static const String msgJournalDeleted = AccountingStrings.msgJournalDeleted;
  static const String msgDeleteFailed = AccountingStrings.msgDeleteFailed;
  static const String msgReceiptSaved = AccountingStrings.msgReceiptSaved;
  static const String msgPaymentSaved = AccountingStrings.msgPaymentSaved;
  static const String msgBondDeleted = AccountingStrings.msgBondDeleted;
  static const String accountCash = AccountingStrings.accountCash;
  static const String accountBank = AccountingStrings.accountBank;
  static const String accountCardClearing =
      AccountingStrings.accountCardClearing;
  static const String accountMobileWallet =
      AccountingStrings.accountMobileWallet;
  static const String accountReceivables = AccountingStrings.accountReceivables;
  static const String accountPayables = AccountingStrings.accountPayables;
  static const String accountInventory = AccountingStrings.accountInventory;
  static const String accountSalesRevenue =
      AccountingStrings.accountSalesRevenue;
  static const String accountTaxPayable = AccountingStrings.accountTaxPayable;
  static const String accountCostOfGoodsSold =
      AccountingStrings.accountCostOfGoodsSold;
  static const String accountInventoryGain =
      AccountingStrings.accountInventoryGain;
  static const String accountInventoryLoss =
      AccountingStrings.accountInventoryLoss;
  static const String accountSupplierAdjustments =
      AccountingStrings.accountSupplierAdjustments;
  static const String accountPurchaseDiscounts =
      AccountingStrings.accountPurchaseDiscounts;
  static const String accountOpeningEquity =
      AccountingStrings.accountOpeningEquity;
  static const String entryDefaultJournal =
      AccountingStrings.entryDefaultJournal;
  static const String entrySalesRevenue = AccountingStrings.entrySalesRevenue;
  static const String entryCostOfGoodsSold =
      AccountingStrings.entryCostOfGoodsSold;
  static const String entryInventoryReduction =
      AccountingStrings.entryInventoryReduction;
  static const String entryInventoryIn = AccountingStrings.entryInventoryIn;
  static const String entrySupplierPayment =
      AccountingStrings.entrySupplierPayment;
  static const String entrySupplierDue = AccountingStrings.entrySupplierDue;
  static const String entrySalesReturn = AccountingStrings.entrySalesReturn;
  static const String entryInventoryReturn =
      AccountingStrings.entryInventoryReturn;
  static const String entryRevenueReversal =
      AccountingStrings.entryRevenueReversal;
  static const String entryCostReversal = AccountingStrings.entryCostReversal;
  static const String entrySupplierDueReduction =
      AccountingStrings.entrySupplierDueReduction;
  static const String entryInventoryReturnToSupplier =
      AccountingStrings.entryInventoryReturnToSupplier;
  static const String entryInventoryGain = AccountingStrings.entryInventoryGain;
  static const String entryInventoryLoss = AccountingStrings.entryInventoryLoss;
  static const String entryInventoryAdjustment =
      AccountingStrings.entryInventoryAdjustment;
  static const String entrySalesInvoice = AccountingStrings.entrySalesInvoice;
  static const String entryPurchaseInvoice =
      AccountingStrings.entryPurchaseInvoice;
  static const String entrySalesReturnInvoice =
      AccountingStrings.entrySalesReturnInvoice;
  static const String entryPurchaseReturnInvoice =
      AccountingStrings.entryPurchaseReturnInvoice;
  static const String entryBalanceError = AccountingStrings.entryBalanceError;
  static const String entryPaymentCash = AccountingStrings.entryPaymentCash;
  static const String entryPaymentCard = AccountingStrings.entryPaymentCard;
  static const String entryPaymentBank = AccountingStrings.entryPaymentBank;
  static const String entryPaymentWallet = AccountingStrings.entryPaymentWallet;
  static const String kindCustomerReceipt =
      AccountingStrings.kindCustomerReceipt;
  static const String kindSupplierPayment =
      AccountingStrings.kindSupplierPayment;
  static const String kindSupplierReceipt =
      AccountingStrings.kindSupplierReceipt;
  static const String kindSupplierOpeningBalance =
      AccountingStrings.kindSupplierOpeningBalance;
  static const String kindSupplierAddition =
      AccountingStrings.kindSupplierAddition;
  static const String kindSupplierDiscount =
      AccountingStrings.kindSupplierDiscount;
  static const String loginTitle = AuthStrings.loginTitle;
  static const String welcomeBack = AuthStrings.welcomeBack;
  static const String loginSubtitle = AuthStrings.loginSubtitle;
  static const String emailLabel = AuthStrings.emailLabel;
  static const String emailHint = AuthStrings.emailHint;
  static const String passwordLabel = AuthStrings.passwordLabel;
  static const String forgotPassword = AuthStrings.forgotPassword;
  static const String loginButton = AuthStrings.loginButton;
  static const String noAccount = AuthStrings.noAccount;
  static const String signupLink = AuthStrings.signupLink;
  static const String logout = AuthStrings.logout;
  static const String logoutTitle = AuthStrings.logoutTitle;
  static const String logoutConfirm = AuthStrings.logoutConfirm;
  static const String yesLogout = AuthStrings.yesLogout;
  static const String cancelAndBack = AuthStrings.cancelAndBack;
  static const String activeAccount = AuthStrings.activeAccount;
  static const String emailRequired = AuthStrings.emailRequired;
  static const String emailInvalid = AuthStrings.emailInvalid;
  static const String passwordRequired = AuthStrings.passwordRequired;
  static const String passwordMinLength = AuthStrings.passwordMinLength;
  static const String passwordsNotMatch = AuthStrings.passwordsNotMatch;
  static const String nameRequired = AuthStrings.nameRequired;
  static const String nameHint = AuthStrings.nameHint;
  static const String emailHintGeneric = AuthStrings.emailHintGeneric;
  static const String errorLoadingAccount = AuthStrings.errorLoadingAccount;
  static const String errorServerConnection = AuthStrings.errorServerConnection;
  static const String errorRegister = AuthStrings.errorRegister;
  static const String errorServer = AuthStrings.errorServer;
  static const String errorGeneral = AuthStrings.errorGeneral;
  static const String signupTitle = AuthStrings.signupTitle;
  static const String signupSubtitle = AuthStrings.signupSubtitle;
  static const String fullNameLabel = AuthStrings.fullNameLabel;
  static const String confirmPasswordLabel = AuthStrings.confirmPasswordLabel;
  static const String signupButton = AuthStrings.signupButton;
  static const String alreadyHaveAccount = AuthStrings.alreadyHaveAccount;
  static const String loginNow = AuthStrings.loginNow;
  static const String backToLogin = AuthStrings.backToLogin;
  static const String resendLink = AuthStrings.resendLink;
  static const String resetSentTitle = AuthStrings.resetSentTitle;
  static const String resetSentSubtitle = AuthStrings.resetSentSubtitle;
  static const String resetPasswordTitle = AuthStrings.resetPasswordTitle;
  static const String resetPasswordSubtitle = AuthStrings.resetPasswordSubtitle;
  static const String resetPasswordButton = AuthStrings.resetPasswordButton;
  static const String forgotPasswordMessage = AuthStrings.forgotPasswordMessage;
  static const String validEmailRequired = AuthStrings.validEmailRequired;
  static const String pharmacySystem = AuthStrings.pharmacySystem;
  static const String pharmacySystemDesc = AuthStrings.pharmacySystemDesc;
  static const String loginRequiresInternet = AuthStrings.loginRequiresInternet;
  static const String loginInvalidCredentials =
      AuthStrings.loginInvalidCredentials;
  static const String tooManyAttempts = AuthStrings.tooManyAttempts;
  static const String emailNotConfirmed = AuthStrings.emailNotConfirmed;
  static const String serverUnavailable = AuthStrings.serverUnavailable;
  static const String accountActiveOnOtherDevice =
      AuthStrings.accountActiveOnOtherDevice;
  static const String serverNotAvailable = AuthStrings.serverNotAvailable;
  static const String loginFailed = AuthStrings.loginFailed;
  static const String registerRequiresInternet =
      AuthStrings.registerRequiresInternet;
  static const String emailAlreadyRegistered =
      AuthStrings.emailAlreadyRegistered;
  static const String registerLocalSuccess = AuthStrings.registerLocalSuccess;
  static const String registerLocalProviderDisabled =
      AuthStrings.registerLocalProviderDisabled;
  static const String registerDisabled = AuthStrings.registerDisabled;
  static const String weakPassword = AuthStrings.weakPassword;
  static const String changePasswordRequiresInternet = AuthStrings.changePasswordRequiresInternet;
  static const String mustLoginFirst = AuthStrings.mustLoginFirst;
  static const String emailNotAvailable = AuthStrings.emailNotAvailable;
  static const String noDataSaved = AuthStrings.noDataSaved;
  static const String currentPasswordIncorrect = AuthStrings.currentPasswordIncorrect;
  static const String passwordChangedSuccess = AuthStrings.passwordChangedSuccess;
  static const String resendConfirmRequiresInternet = AuthStrings.resendConfirmRequiresInternet;
  static const String resendConfirmFailed = AuthStrings.resendConfirmFailed;
  static const String forceLogoutInternetRequired = AuthStrings.forceLogoutInternetRequired;
  static const String remoteLogoutSuccess = AuthStrings.remoteLogoutSuccess;
  static const String remoteLogoutFailed = AuthStrings.remoteLogoutFailed;
  static const String emailConfirmationSent = AuthStrings.emailConfirmationSent;
  static const String emailConfirmationCheck = AuthStrings.emailConfirmationCheck;
  static const String emailConfirmationDesc = AuthStrings.emailConfirmationDesc;
  static const String emailConfirmationResend = AuthStrings.emailConfirmationResend;
  static const String emailConfirmationResendSent = AuthStrings.emailConfirmationResendSent;
  static const String emailConfirmationDidntReceive = AuthStrings.emailConfirmationDidntReceive;
  static const String appNameSplash = AuthStrings.appNameSplash;
  static const String appDescSplash = AuthStrings.appDescSplash;
  static const String mainPageTitle = HomeStrings.mainPageTitle;
  static const String mainPageWelcomePrefix = HomeStrings.mainPageWelcomePrefix;
  static const String mainPageWelcomeUser = HomeStrings.mainPageWelcomeUser;
  static const String mainPageSubtitleLong = HomeStrings.mainPageSubtitleLong;
  static const String mainPageActiveUser = HomeStrings.mainPageActiveUser;
  static const String mainPageBranchPrefix = HomeStrings.mainPageBranchPrefix;
  static const String mainPageDefaultUser = HomeStrings.mainPageDefaultUser;
  static const String mainPageDefaultBranch = HomeStrings.mainPageDefaultBranch;
  static const String sectionSales = HomeStrings.sectionSales;
  static const String sectionPurchases = HomeStrings.sectionPurchases;
  static const String sectionInventory = HomeStrings.sectionInventory;
  static const String sectionAdminFinance = HomeStrings.sectionAdminFinance;
  static const String actionCashier = HomeStrings.actionCashier;
  static const String actionCashierSubtitle = HomeStrings.actionCashierSubtitle;
  static const String actionSalesReport = HomeStrings.actionSalesReport;
  static const String actionSalesReturn = HomeStrings.actionSalesReturn;
  static const String actionPriceQuotes = HomeStrings.actionPriceQuotes;
  static const String actionCustomers = HomeStrings.actionCustomers;
  static const String actionAddPurchase = HomeStrings.actionAddPurchase;
  static const String actionAddPurchaseSubtitle =
      HomeStrings.actionAddPurchaseSubtitle;
  static const String actionPurchaseReturn = HomeStrings.actionPurchaseReturn;
  static const String actionSuppliers = HomeStrings.actionSuppliers;
  static const String actionExpenses = HomeStrings.actionExpenses;
  static const String actionItems = HomeStrings.actionItems;
  static const String actionItemsSubtitle = HomeStrings.actionItemsSubtitle;
  static const String actionAddItem = HomeStrings.actionAddItem;
  static const String actionInventoryHealth = HomeStrings.actionInventoryHealth;
  static const String actionBarcodeLabel = HomeStrings.actionBarcodeLabel;
  static const String actionStockTransfer = HomeStrings.actionStockTransfer;
  static const String actionSettings = HomeStrings.actionSettings;
  static const String actionSettingsSubtitle =
      HomeStrings.actionSettingsSubtitle;
  static const String actionUsers = HomeStrings.actionUsers;
  static const String actionActivityLog = HomeStrings.actionActivityLog;
  static const String actionProfitLoss = HomeStrings.actionProfitLoss;
  static const String sidebarMain = HomeStrings.sidebarMain;
  static const String sidebarDashboard = HomeStrings.sidebarDashboard;
  static const String sidebarSales = HomeStrings.sidebarSales;
  static const String sidebarPos = HomeStrings.sidebarPos;
  static const String sidebarCashierShifts = HomeStrings.sidebarCashierShifts;
  static const String sidebarSalesInvoices = HomeStrings.sidebarSalesInvoices;
  static const String sidebarSalesReturns = HomeStrings.sidebarSalesReturns;
  static const String sidebarPriceQuotes = HomeStrings.sidebarPriceQuotes;
  static const String sidebarPurchases = HomeStrings.sidebarPurchases;
  static const String sidebarNewPurchase = HomeStrings.sidebarNewPurchase;
  static const String sidebarPurchaseInvoices =
      HomeStrings.sidebarPurchaseInvoices;
  static const String sidebarPurchaseReturns =
      HomeStrings.sidebarPurchaseReturns;
  static const String sidebarItems = HomeStrings.sidebarItems;
  static const String sidebarItemsList = HomeStrings.sidebarItemsList;
  static const String sidebarAddItem = HomeStrings.sidebarAddItem;
  static const String sidebarInventoryHealth =
      HomeStrings.sidebarInventoryHealth;
  static const String sidebarBarcodeLabel = HomeStrings.sidebarBarcodeLabel;
  static const String sidebarBarcodeSettings =
      HomeStrings.sidebarBarcodeSettings;
  static const String sidebarContacts = HomeStrings.sidebarContacts;
  static const String sidebarCustomers = HomeStrings.sidebarCustomers;
  static const String sidebarSuppliers = HomeStrings.sidebarSuppliers;
  static const String sidebarSupplierCustomers =
      HomeStrings.sidebarSupplierCustomers;
  static const String sidebarCustomerGroups = HomeStrings.sidebarCustomerGroups;
  static const String sidebarCrm = HomeStrings.sidebarCrm;
  static const String sidebarReports = HomeStrings.sidebarReports;
  static const String sidebarSalesReport = HomeStrings.sidebarSalesReport;
  static const String sidebarContactsReport = HomeStrings.sidebarContactsReport;
  static const String sidebarPurchaseReport = HomeStrings.sidebarPurchaseReport;
  static const String sidebarProfitReport = HomeStrings.sidebarProfitReport;
  static const String sidebarSettings = HomeStrings.sidebarSettings;
  static const String sidebarProfile = HomeStrings.sidebarProfile;
  static const String sidebarEmployees = HomeStrings.sidebarEmployees;
  static const String sidebarBranches = HomeStrings.sidebarBranches;
  static const String sidebarPermissions = HomeStrings.sidebarPermissions;
  static const String sidebarActivityLog = HomeStrings.sidebarActivityLog;
  static const String sidebarDocumentControl =
      HomeStrings.sidebarDocumentControl;
  static const String sidebarArchive = HomeStrings.sidebarArchive;
  static const String dashboardTitle = HomeStrings.dashboardTitle;
  static const String welcomeUserPrefix = HomeStrings.welcomeUserPrefix;
  static const String dashboardSubtitle = HomeStrings.dashboardSubtitle;
  static const String totalSales = HomeStrings.totalSales;
  static const String netIncome = HomeStrings.netIncome;
  static const String salesDue = HomeStrings.salesDue;
  static const String salesReturns = HomeStrings.salesReturns;
  static const String totalPurchases = HomeStrings.totalPurchases;
  static const String purchasesDue = HomeStrings.purchasesDue;
  static const String purchaseReturns = HomeStrings.purchaseReturns;
  static const String totalExpenses = HomeStrings.totalExpenses;
  static const String salesMovement30Days = HomeStrings.salesMovement30Days;
  static const String annualPerformance = HomeStrings.annualPerformance;
  static const String customerDebts = HomeStrings.customerDebts;
  static const String supplierDebts = HomeStrings.supplierDebts;
  static const String lowStockAlertTitle = HomeStrings.lowStockAlertTitle;
  static const String recentOrdersTitle = HomeStrings.recentOrdersTitle;
  static const String pendingShipmentsTitle = HomeStrings.pendingShipmentsTitle;
  static const String item = HomeStrings.item;
  static const String currentStock = HomeStrings.currentStock;
  static const String minStock = HomeStrings.minStock;
  static const String orderNumber = HomeStrings.orderNumber;
  static const String customer = HomeStrings.customer;
  static const String supplier = HomeStrings.supplier;
  static const String invoice = HomeStrings.invoice;
  static const String totalSalesLabel = HomeStrings.totalSalesLabel;
  static const String todaySalesLabel = HomeStrings.todaySalesLabel;
  static const String monthSalesLabel = HomeStrings.monthSalesLabel;
  static const String totalPurchasesLabel = HomeStrings.totalPurchasesLabel;
  static const String monthPurchasesLabel = HomeStrings.monthPurchasesLabel;
  static const String totalRevenue = HomeStrings.totalRevenue;
  static const String netProfit = HomeStrings.netProfit;
  static const String grossProfit = HomeStrings.grossProfit;
  static const String operatingExpenses = HomeStrings.operatingExpenses;
  static const String netSales = HomeStrings.netSales;
  static const String costOfGoodsSold = HomeStrings.costOfGoodsSold;
  static const String totalDebit = HomeStrings.totalDebit;
  static const String totalCredit = HomeStrings.totalCredit;
  static const String employeeDashboardTitle = HomeStrings.employeeDashboardTitle;
  static const String employeeIndicators = HomeStrings.employeeIndicators;
  static const String employeeQuickActions = HomeStrings.employeeQuickActions;
  static const String employeeOpenPos = HomeStrings.employeeOpenPos;
  static const String crmTitle = CrmStrings.crmTitle;
  static const String crmSubtitle = CrmStrings.crmSubtitle;
  static const String crmError = CrmStrings.crmError;
  static const String crmTotal = CrmStrings.crmTotal;
  static const String crmNew = CrmStrings.crmNew;
  static const String crmContacted = CrmStrings.crmContacted;
  static const String crmInterested = CrmStrings.crmInterested;
  static const String crmConverted = CrmStrings.crmConverted;
  static const String crmNotInterested = CrmStrings.crmNotInterested;
  static const String crmAddLead = CrmStrings.crmAddLead;
  static const String crmEmpty = CrmStrings.crmEmpty;
  static const String crmEdit = CrmStrings.crmEdit;
  static const String crmAddFollowUp = CrmStrings.crmAddFollowUp;
  static const String crmEditDialog = CrmStrings.crmEditDialog;
  static const String crmAddDialog = CrmStrings.crmAddDialog;
  static const String crmNameHint = CrmStrings.crmNameHint;
  static const String crmPhone = CrmStrings.crmPhone;
  static const String crmPhoneHint = CrmStrings.crmPhoneHint;
  static const String crmSource = CrmStrings.crmSource;
  static const String crmSaveEdit = CrmStrings.crmSaveEdit;
  static const String crmAddNow = CrmStrings.crmAddNow;
  static const String crmNameRequired = CrmStrings.crmNameRequired;
  static const String crmFollowUpDate = CrmStrings.crmFollowUpDate;
  static const String crmFollowUpNotes = CrmStrings.crmFollowUpNotes;
  static const String crmSaveFollowUp = CrmStrings.crmSaveFollowUp;
  static const String crmFollowUpRequired = CrmStrings.crmFollowUpRequired;
  static const String crmMsgLeadAdded = CrmStrings.crmMsgLeadAdded;
  static const String crmMsgUpdated = CrmStrings.crmMsgUpdated;
  static const String crmMsgFollowUpAdded = CrmStrings.crmMsgFollowUpAdded;
  static const String tasksTitle = TasksStrings.tasksTitle;
  static const String tasksTotal = TasksStrings.tasksTotal;
  static const String tasksPending = TasksStrings.tasksPending;
  static const String tasksInProgress = TasksStrings.tasksInProgress;
  static const String tasksCompleted = TasksStrings.tasksCompleted;
  static const String tasksOverdue = TasksStrings.tasksOverdue;
  static const String tasksCancelled = TasksStrings.tasksCancelled;
  static const String tasksNew = TasksStrings.tasksNew;
  static const String tasksAllStatuses = TasksStrings.tasksAllStatuses;
  static const String tasksAllPriorities = TasksStrings.tasksAllPriorities;
  static const String tasksPriorityLow = TasksStrings.tasksPriorityLow;
  static const String tasksPriorityMedium = TasksStrings.tasksPriorityMedium;
  static const String tasksPriorityHigh = TasksStrings.tasksPriorityHigh;
  static const String tasksPriorityUrgent = TasksStrings.tasksPriorityUrgent;
  static const String tasksRefresh = TasksStrings.tasksRefresh;
  static const String tasksEmpty = TasksStrings.tasksEmpty;
  static const String tasksCreate = TasksStrings.tasksCreate;
  static const String tasksPriorityHint = TasksStrings.tasksPriorityHint;
  static const String tasksPriorityLowLabel =
      TasksStrings.tasksPriorityLowLabel;
  static const String tasksPriorityMediumLabel =
      TasksStrings.tasksPriorityMediumLabel;
  static const String tasksPriorityHighLabel =
      TasksStrings.tasksPriorityHighLabel;
  static const String tasksPriorityUrgentLabel =
      TasksStrings.tasksPriorityUrgentLabel;
  static const String tasksDueDate = TasksStrings.tasksDueDate;
  static const String tasksSave = TasksStrings.tasksSave;
  static const String tasksDelete = TasksStrings.tasksDelete;
  static const String tasksDeleteConfirm = TasksStrings.tasksDeleteConfirm;
  static const String tasksComplete = TasksStrings.tasksComplete;
  static const String tasksReopen = TasksStrings.tasksReopen;
  static const String tasksDeletePermanent = TasksStrings.tasksDeletePermanent;
  static const String tasksStatusPending = TasksStrings.tasksStatusPending;
  static const String tasksStatusInProgress =
      TasksStrings.tasksStatusInProgress;
  static const String tasksStatusCompleted = TasksStrings.tasksStatusCompleted;
  static const String remindersAdd = TasksStrings.remindersAdd;
  static const String remindersRefresh = TasksStrings.remindersRefresh;
  static const String remindersEmpty = TasksStrings.remindersEmpty;
  static const String remindersDialog = TasksStrings.remindersDialog;
  static const String remindersTitle = TasksStrings.remindersTitle;
  static const String remindersMessage = TasksStrings.remindersMessage;
  static const String remindersRepeat = TasksStrings.remindersRepeat;
  static const String remindersNoRepeat = TasksStrings.remindersNoRepeat;
  static const String remindersDaily = TasksStrings.remindersDaily;
  static const String remindersWeekly = TasksStrings.remindersWeekly;
  static const String remindersMonthly = TasksStrings.remindersMonthly;
  static const String remindersAddButton = TasksStrings.remindersAddButton;
  static const String remindersDismiss = TasksStrings.remindersDismiss;
  static const String notesAdd = TasksStrings.notesAdd;
  static const String notesEmpty = TasksStrings.notesEmpty;
  static const String notesContent = TasksStrings.notesContent;
  static const String notesUnpin = TasksStrings.notesUnpin;
  static const String notesPin = TasksStrings.notesPin;
  static const String messagesSend = TasksStrings.messagesSend;
  static const String messagesEmpty = TasksStrings.messagesEmpty;
  static const String messagesDialog = TasksStrings.messagesDialog;
  static const String messagesSubject = TasksStrings.messagesSubject;
  static const String messagesBody = TasksStrings.messagesBody;
  static const String messagesSendButton = TasksStrings.messagesSendButton;
  static const String messagesFrom = TasksStrings.messagesFrom;
  static const String stocktakingTitle = StocktakingStrings.stocktakingTitle;
  static const String stocktakingAll = StocktakingStrings.stocktakingAll;
  static const String stocktakingOpen = StocktakingStrings.stocktakingOpen;
  static const String stocktakingInProgress =
      StocktakingStrings.stocktakingInProgress;
  static const String stocktakingClosed = StocktakingStrings.stocktakingClosed;
  static const String stocktakingDone = StocktakingStrings.stocktakingDone;
  static const String stocktakingCancel = StocktakingStrings.stocktakingCancel;
  static const String stocktakingDefaultUnit =
      StocktakingStrings.stocktakingDefaultUnit;
  static const String stocktakingDetail = StocktakingStrings.stocktakingDetail;
  static const String voidOpsTitle = StocktakingStrings.voidOpsTitle;
  static const String voidOpsInputError = StocktakingStrings.voidOpsInputError;
  static const String voidOpsReason = StocktakingStrings.voidOpsReason;
  static const String hrTitle = HrStrings.hrTitle;
  static const String hrEmployees = HrStrings.hrEmployees;
  static const String hrAttendance = HrStrings.hrAttendance;
  static const String hrLeave = HrStrings.hrLeave;
  static const String hrPayroll = HrStrings.hrPayroll;
  static const String hrDepartments = HrStrings.hrDepartments;
  static const String hrTodayAttendance = HrStrings.hrTodayAttendance;
  static const String hrPresent = HrStrings.hrPresent;
  static const String hrDeparted = HrStrings.hrDeparted;
  static const String hrTotal = HrStrings.hrTotal;
  static const String hrCheckOut = HrStrings.hrCheckOut;
  static const String hrCheckIn = HrStrings.hrCheckIn;
  static const String hrNoEmployees = HrStrings.hrNoEmployees;
  static const String hrAttendanceLog = HrStrings.hrAttendanceLog;
  static const String hrNewPayroll = HrStrings.hrNewPayroll;
  static const String hrYear = HrStrings.hrYear;
  static const String hrCreatePayroll = HrStrings.hrCreatePayroll;
  static const String hrPayrollSummary = HrStrings.hrPayrollSummary;
  static const String hrDraft = HrStrings.hrDraft;
  static const String hrProcessing = HrStrings.hrProcessing;
  static const String hrApproved = HrStrings.hrApproved;
  static const String hrPaid = HrStrings.hrPaid;
  static const String hrPreviousPayrolls = HrStrings.hrPreviousPayrolls;
  static const String hrStartProcessing = HrStrings.hrStartProcessing;
  static const String hrApprovePayroll = HrStrings.hrApprovePayroll;
  static const String hrViewDetails = HrStrings.hrViewDetails;
  static const String hrEmpEmpty = HrStrings.hrEmpEmpty;
  static const String hrEmpEmptySubtitle = HrStrings.hrEmpEmptySubtitle;
  static const String hrEmpAdd = HrStrings.hrEmpAdd;
  static const String hrEmpFullName = HrStrings.hrEmpFullName;
  static const String hrEmpPhone = HrStrings.hrEmpPhone;
  static const String hrEmpMobileHint = HrStrings.hrEmpMobileHint;
  static const String hrEmpJobTitle = HrStrings.hrEmpJobTitle;
  static const String hrEmpDepartment = HrStrings.hrEmpDepartment;
  static const String hrEmpDepartmentHint = HrStrings.hrEmpDepartmentHint;
  static const String hrEmpNotes = HrStrings.hrEmpNotes;
  static const String hrEmpNotesHint = HrStrings.hrEmpNotesHint;
  static const String hrEmpAddButton = HrStrings.hrEmpAddButton;
  static const String hrEmpStatusActive = HrStrings.hrEmpStatusActive;
  static const String hrEmpStatusInactive = HrStrings.hrEmpStatusInactive;
  static const String hrEmpStatusLeft = HrStrings.hrEmpStatusLeft;
  static const String hrEmpDelete = HrStrings.hrEmpDelete;
  static const String hrEmpDeleteConfirm = HrStrings.hrEmpDeleteConfirm;
  static const String hrEmpEdit = HrStrings.hrEmpEdit;
  static const String hrEmpEditDialog = HrStrings.hrEmpEditDialog;
  static const String hrEmpName = HrStrings.hrEmpName;
  static const String hrEmpBaseSalary = HrStrings.hrEmpBaseSalary;
  static const String hrEmpStatus = HrStrings.hrEmpStatus;
  static const String hrEmpStatusHint = HrStrings.hrEmpStatusHint;
  static const String hrDeptEmpty = HrStrings.hrDeptEmpty;
  static const String hrDeptEmptySubtitle = HrStrings.hrDeptEmptySubtitle;
  static const String hrDeptAdd = HrStrings.hrDeptAdd;
  static const String hrDeptName = HrStrings.hrDeptName;
  static const String hrDeptDescription = HrStrings.hrDeptDescription;
  static const String hrDeptDescriptionHint = HrStrings.hrDeptDescriptionHint;
  static const String hrDeptManager = HrStrings.hrDeptManager;
  static const String hrDeptManagerHint = HrStrings.hrDeptManagerHint;
  static const String hrLeaveNew = HrStrings.hrLeaveNew;
  static const String hrLeaveEmployee = HrStrings.hrLeaveEmployee;
  static const String hrLeaveEmployeeHint = HrStrings.hrLeaveEmployeeHint;
  static const String hrLeaveType = HrStrings.hrLeaveType;
  static const String hrLeaveTypeHint = HrStrings.hrLeaveTypeHint;
  static const String hrLeaveSick = HrStrings.hrLeaveSick;
  static const String hrLeaveAnnual = HrStrings.hrLeaveAnnual;
  static const String hrLeaveEmergency = HrStrings.hrLeaveEmergency;
  static const String hrLeaveMission = HrStrings.hrLeaveMission;
  static const String hrLeaveUnpaid = HrStrings.hrLeaveUnpaid;
  static const String hrLeaveStartDate = HrStrings.hrLeaveStartDate;
  static const String hrLeaveEndDate = HrStrings.hrLeaveEndDate;
  static const String hrMsgEmployeeAdded = HrStrings.hrMsgEmployeeAdded;
  static const String hrMsgEmployeeUpdated = HrStrings.hrMsgEmployeeUpdated;
  static const String hrMsgEmployeeDeleted = HrStrings.hrMsgEmployeeDeleted;
  static const String hrMsgAttendanceIn = HrStrings.hrMsgAttendanceIn;
  static const String hrMsgAttendanceOut = HrStrings.hrMsgAttendanceOut;
  static const String hrMsgLeaveRequested = HrStrings.hrMsgLeaveRequested;
  static const String hrMsgLeaveApproved = HrStrings.hrMsgLeaveApproved;
  static const String hrMsgLeaveRejected = HrStrings.hrMsgLeaveRejected;
  static const String hrMsgPayrollCreated = HrStrings.hrMsgPayrollCreated;
  static const String hrMsgPayrollProcessed = HrStrings.hrMsgPayrollProcessed;
  static const String hrMsgPayrollApproved = HrStrings.hrMsgPayrollApproved;
  static const String hrMsgDepartmentAdded = HrStrings.hrMsgDepartmentAdded;
  static const String hrMsgDepartmentUpdated = HrStrings.hrMsgDepartmentUpdated;
  static const String hrMsgDepartmentDeleted = HrStrings.hrMsgDepartmentDeleted;
  static const String customersTitle = CustomersStrings.customersTitle;
  static const String customerTitle = CustomersStrings.customerTitle;
  static const String addCustomer = CustomersStrings.addCustomer;
  static const String totalCustomers = CustomersStrings.totalCustomers;
  static const String totalDebt = CustomersStrings.totalDebt;
  static const String customerItemLabel = CustomersStrings.customerItemLabel;
  static const String customerNameHint = CustomersStrings.customerNameHint;
  static const String deleteCustomer = CustomersStrings.deleteCustomer;
  static const String editCustomer = CustomersStrings.editCustomer;
  static const String paymentTerm = CustomersStrings.paymentTerm;
  static const String creditLimit = CustomersStrings.creditLimit;
  static const String inactiveLabel = CustomersStrings.inactiveLabel;
  static const String deactivate = CustomersStrings.deactivate;
  static const String activate = CustomersStrings.activate;
  static const String address = CustomersStrings.address;
  static const String taxIdLabel = CustomersStrings.taxIdLabel;
  static const String selectType = CustomersStrings.selectType;
  static const String ledgerTitle = CustomersStrings.ledgerTitle;
  static const String cashReceipt = CustomersStrings.cashReceipt;
  static const String exportSuccess = CustomersStrings.exportSuccess;
  static const String noFinancialMovements = CustomersStrings.noFinancialMovements;
  static const String invalidAmount = CustomersStrings.invalidAmount;
  static const String checkNumber = CustomersStrings.checkNumber;
  static const String bankName = CustomersStrings.bankName;
  static const String dueDate = CustomersStrings.dueDate;
  static const String saleInvoice = CustomersStrings.saleInvoice;
  static const String saleReturn = CustomersStrings.saleReturn;
  static const String customerPayment = CustomersStrings.customerPayment;
  static const String saleVoid = CustomersStrings.saleVoid;
  static const String openingBalance = CustomersStrings.openingBalance;
  static const String manualAdjustment = CustomersStrings.manualAdjustment;

  // ─── Add Customer ───
  static const String addNewCustomerTitle = CustomersStrings.addNewCustomerTitle;
  static const String addNewCustomerSubtitle = CustomersStrings.addNewCustomerSubtitle;
  static const String fullNameRequired = CustomersStrings.fullNameRequired;
  static const String customerNameExampleHint = CustomersStrings.customerNameExampleHint;
  static const String nameIsRequired = CustomersStrings.nameIsRequired;
  static const String interactionType = CustomersStrings.interactionType;
  static const String selectInteractionType = CustomersStrings.selectInteractionType;
  static const String regularInteraction = CustomersStrings.regularInteraction;
  static const String cashInteraction = CustomersStrings.cashInteraction;
  static const String companyOrInstitution = CustomersStrings.companyOrInstitution;
  static const String detailedAddress = CustomersStrings.detailedAddress;
  static const String financialSettings = CustomersStrings.financialSettings;
  static const String discountPercentLabel = CustomersStrings.discountPercentLabel;
  static const String paymentTermDaysLabel = CustomersStrings.paymentTermDaysLabel;
  static const String openingBalanceLabel = CustomersStrings.openingBalanceLabel;
  static const String balanceStatusLabel = CustomersStrings.balanceStatusLabel;
  static const String debitLabel = CustomersStrings.debitLabel;
  static const String creditLabel = CustomersStrings.creditLabel;
  static const String additionalNotes = CustomersStrings.additionalNotes;
  static const String saveCustomerData = CustomersStrings.saveCustomerData;
  static const String searchCustomerHintInput = CustomersStrings.searchCustomerHintInput;
  static const String deleteCustomerConfirmMessageFormat = CustomersStrings.deleteCustomerConfirmMessageFormat;
  static const String exportLedgerFailedFormat = CustomersStrings.exportLedgerFailedFormat;
  static const String daySuffix = CustomersStrings.daySuffix;

  // ─── Add Supplier ───
  static const String addNewSupplierTitle = SuppliersStrings.addNewSupplierTitle;
  static const String nameLabelRequired = SuppliersStrings.nameLabelRequired;
  static const String supplierNameHint = SuppliersStrings.supplierNameHint;
  static const String supplierNameRequired = SuppliersStrings.nameRequired;
  static const String typeLabelDropdown = SuppliersStrings.typeLabelDropdown;
  static const String selectTypeHint = SuppliersStrings.selectTypeHint;
  static const String supplierType = SuppliersStrings.supplierType;
  static const String supplierCustomerType = SuppliersStrings.supplierCustomerType;
  static const String phoneLabelInput = SuppliersStrings.phoneLabelInput;
  static const String companyLabelInput = SuppliersStrings.companyLabelInput;
  static const String emailLabelInput = SuppliersStrings.emailLabelInput;
  static const String taxIdLabelInput = SuppliersStrings.taxIdLabelInput;
  static const String addressLabelInput = SuppliersStrings.addressLabelInput;
  static const String partyTypeLabel = SuppliersStrings.partyTypeLabel;
  static const String selectPartyTypeHint = SuppliersStrings.selectPartyTypeHint;
  static const String creditLimitLabelInput = SuppliersStrings.creditLimitLabelInput;
  static const String discountPercentLabelInput = SuppliersStrings.discountPercentLabelInput;
  static const String paymentTermDaysLabelInput = SuppliersStrings.paymentTermDaysLabelInput;
  static const String openingBalanceLabelInput = SuppliersStrings.openingBalanceLabelInput;
  static const String balanceDirectionLabel = SuppliersStrings.balanceDirectionLabel;
  static const String debitDirection = SuppliersStrings.debitDirection;
  static const String creditDirection = SuppliersStrings.creditDirection;
  static const String notesLabelInput = SuppliersStrings.notesLabelInput;

  // ─── Add Party (Customer/Supplier) ───
  static const String addNewPartyTitle = CrmStrings.addNewPartyTitle;
  static const String personalAndBasicInfo = CrmStrings.personalAndBasicInfo;
  static const String businessAndActivityDetails = CrmStrings.businessAndActivityDetails;
  static const String financialAndCreditPolicies = CrmStrings.financialAndCreditPolicies;
  static const String openingBalanceAtStart = CrmStrings.openingBalanceAtStart;
  static const String partyFullNameLabel = CrmStrings.partyFullNameLabel;
  static const String partyNameRequiredWarning = CrmStrings.partyNameRequiredWarning;
  static const String detailedAddressLabel = CrmStrings.detailedAddressLabel;
  static const String companyNameOptional = CrmStrings.companyNameOptional;
  static const String legalEntityType = CrmStrings.legalEntityType;
  static const String selectEntityTypeHint = CrmStrings.selectEntityTypeHint;
  static const String companyOrInstitutionLabel = CrmStrings.companyOrInstitutionLabel;
  static const String individualOrMerchantLabel = CrmStrings.individualOrMerchantLabel;
  static const String defaultInteractionMethod = CrmStrings.defaultInteractionMethod;
  static const String selectInteractionMethodHint = CrmStrings.selectInteractionMethodHint;
  static const String regularCreditLabel = CrmStrings.regularCreditLabel;
  static const String cashOnlyLabel = CrmStrings.cashOnlyLabel;
  static const String agreedDiscountPercent = CrmStrings.agreedDiscountPercent;
  static const String maximumCreditLimit = CrmStrings.maximumCreditLimit;
  static const String grantedPaymentTermDays = CrmStrings.grantedPaymentTermDays;
  static const String balanceValue = CrmStrings.balanceValue;
  static const String balanceStatusHint = CrmStrings.balanceStatusHint;
  static const String debitOurDues = CrmStrings.debitOurDues;
  static const String creditTheirDues = CrmStrings.creditTheirDues;
  static const String savePartyData = CrmStrings.savePartyData;
  static const String supplierCustomersTitle = CrmStrings.supplierCustomersTitle;
  static const String supplierCustomersSubtitle = CrmStrings.supplierCustomersSubtitle;
  static const String addAction = CrmStrings.addAction;
  static const String totalParties = CrmStrings.totalParties;
  static const String activeParties = CrmStrings.activeParties;
  static const String totalBalancesParties = CrmStrings.totalBalancesParties;
  static const String noPartiesFound = CrmStrings.noPartiesFound;
  static const String selectPartyToViewLedger = CrmStrings.selectPartyToViewLedger;
  static const String partyCreditLimitLabel = CrmStrings.creditLimitLabel;
  static const String transactionSummary = CrmStrings.transactionSummary;
  static const String totalSalesLabelStat = CrmStrings.totalSalesLabel;
  static const String totalSalesReturnsLabelStat = CrmStrings.totalSalesReturnsLabel;
  static const String totalPurchasesLabelStat = CrmStrings.totalPurchasesLabel;
  static const String totalPurchaseReturnsLabelStat = CrmStrings.totalPurchaseReturnsLabel;
  static const String totalReceiptsLabelStat = CrmStrings.totalReceiptsLabel;
  static const String totalPaymentsLabelStat = CrmStrings.totalPaymentsLabel;
  static const String totalAdditionsLabelStat = CrmStrings.totalAdditionsLabel;
  static const String totalDiscountsLabelStat = CrmStrings.totalDiscountsLabel;
  static const String totalCheckReceiptsLabelStat = CrmStrings.totalCheckReceiptsLabel;
  static const String totalCheckPaymentsLabelStat = CrmStrings.totalCheckPaymentsLabel;
  static const String cashReceiptTitleFormat = CrmStrings.cashReceiptTitle;
  static const String cashPaymentTitleFormat = CrmStrings.cashPaymentTitle;
  static const String additionNoticeTitleFormat = CrmStrings.additionNoticeTitle;
  static const String discountNoticeTitleFormat = CrmStrings.discountNoticeTitle;
  static const String checkReceiptTitleFormat = CrmStrings.checkReceiptTitle;
  static const String checkPaymentTitleFormat = CrmStrings.checkPaymentTitle;
  static const String exportCsvAction = CrmStrings.exportCsv;
  static const String exportXlsxAction = CrmStrings.exportXlsx;
  static const String exportHtmlAction = CrmStrings.exportHtml;
  static const String exportXmlAction = CrmStrings.exportXml;
  static const String dateColumn = CrmStrings.dateColumn;
  static const String statementColumn = CrmStrings.statementColumn;
  static const String debitColumn = CrmStrings.debitColumn;
  static const String creditColumn = CrmStrings.creditColumn;
  static const String balanceColumn = CrmStrings.balanceColumn;
  static const String transactionPrefix = CrmStrings.transactionPrefix;
  static const String editPartyTitle = CrmStrings.editPartyTitle;
  static const String addNewPartyAction = CrmStrings.addNewPartyAction;
  static const String partyNameLabel = CrmStrings.partyNameLabel;
  static const String customerTypeLabel = CrmStrings.customerTypeLabel;
  static const String selectCustomerTypeHint = CrmStrings.selectCustomerTypeHint;
  static const String creditLimitLabelInputParty = CrmStrings.creditLimitLabelInput;
  static const String entityTypeLabel = CrmStrings.entityTypeLabel;
  static const String entityTypeCompany = CrmStrings.entityTypeCompany;
  static const String entityTypeIndividual = CrmStrings.entityTypeIndividual;
  static const String deleteConfirmMessageFormat = CrmStrings.deleteConfirmMessageFormat;
  static const String amountRequired = CrmStrings.amountRequired;
  static const String enterCorrectNumber = CrmStrings.enterCorrectNumber;
  static const String processDetailsHint = CrmStrings.processDetailsHint;
  static const String recordAdditionAction = CrmStrings.recordAdditionAction;
  static const String recordDiscountAction = CrmStrings.recordDiscountAction;
  static const String checkValueLabel = CrmStrings.checkValueLabel;
  static const String checkValueRequired = CrmStrings.checkValueRequired;
  static const String enterCheckNumberHint = CrmStrings.enterCheckNumberHint;
  static const String checkNumberLabel = CrmStrings.checkNumberLabel;
  static const String bankLabel = CrmStrings.bankLabel;
  static const String bankNameHint = CrmStrings.bankNameHint;
  static const String dueDateHint = CrmStrings.dueDateHint;
  static const String recordReceiptAction = CrmStrings.recordReceiptAction;
  static const String recordPaymentAction = CrmStrings.recordPaymentAction;

  static const String msgPartyAdded = CrmStrings.msgPartyAdded;
  static const String msgAddFailed = CrmStrings.msgAddFailed;
  static const String msgUpdatedSuccess = CrmStrings.msgUpdatedSuccess;
  static const String msgUpdateFailed = CrmStrings.msgUpdateFailed;
  static const String msgDeletedSuccess = CrmStrings.msgDeletedSuccess;
  static const String msgDeleteFailedCrm = CrmStrings.msgDeleteFailed;
  static const String msgReceiptRecorded = CrmStrings.msgReceiptRecorded;
  static const String msgReceiptFailed = CrmStrings.msgReceiptFailed;
  static const String msgPaymentRecorded = CrmStrings.msgPaymentRecorded;
  static const String msgPaymentFailedCrm = CrmStrings.msgPaymentFailed;
  static const String msgAdditionRecorded = CrmStrings.msgAdditionRecorded;
  static const String msgAdditionFailed = CrmStrings.msgAdditionFailed;
  static const String msgDiscountRecorded = CrmStrings.msgDiscountRecorded;
  static const String msgDiscountFailed = CrmStrings.msgDiscountFailed;
  static const String msgCheckReceiptRecorded = CrmStrings.msgCheckReceiptRecorded;
  static const String msgCheckReceiptFailed = CrmStrings.msgCheckReceiptFailed;
  static const String msgCheckPaymentRecorded = CrmStrings.msgCheckPaymentRecorded;
  static const String msgCheckPaymentFailed = CrmStrings.msgCheckPaymentFailed;
  static const String msgExportUnsupported = CrmStrings.msgExportUnsupported;
  static const String msgExportSuccessCrm = CrmStrings.msgExportSuccess;
  static const String msgExportFailedCrm = CrmStrings.msgExportFailed;

  static const String confirmExitTitle = GeneralStrings.confirmExitTitle;
  static const String unsavedChangesConfirm = GeneralStrings.unsavedChangesConfirm;
  static const String stayButton = GeneralStrings.stayButton;
  static const String exitAndIgnoreButton = GeneralStrings.exitAndIgnoreButton;
  static const String errorLoadingCustomers = CustomersStrings.errorLoadingCustomers;

  // ─── Accounting Validation ───
  static const String errorPaymentMustBePositive = AccountingStrings.errorPaymentMustBePositive;
  static const String errorAdditionMustBePositive = AccountingStrings.errorAdditionMustBePositive;
  static const String errorDiscountMustBePositive = AccountingStrings.errorDiscountMustBePositive;
  static const String errorCheckMustBePositive = AccountingStrings.errorCheckMustBePositive;
  static const String errorOpeningMustBePositive = AccountingStrings.errorOpeningMustBePositive;

  // ─── Archive ───
  static const String archiveDashboard = ArchiveStrings.archiveDashboard;
  static const String sidebarAdvancedArchive = ArchiveStrings.sidebarAdvancedArchive;
  static const String archiveSubtitle = ArchiveStrings.archiveSubtitle;
  static const String medicinesArchive = ArchiveStrings.medicinesArchive;
  static const String archiveEmpty = ArchiveStrings.archiveEmpty;
  static const String archiveEmptySubtitle = ArchiveStrings.archiveEmptySubtitle;
  static const String restore = ArchiveStrings.restore;
  static const String restoreItem = ArchiveStrings.restoreItem;
  static const String restoreSelected = ArchiveStrings.restoreSelected;
  static const String archivePermanentDelete = ArchiveStrings.archivePermanentDelete;
  static const String permanentDeleteItem = ArchiveStrings.permanentDeleteItem;
  static const String editBeforeRestore = ArchiveStrings.editBeforeRestore;
  static const String viewArchiveDetails = ArchiveStrings.viewArchiveDetails;
  static const String restoreConfirmTitle = ArchiveStrings.restoreConfirmTitle;
  static const String restoreConfirmMessage = ArchiveStrings.restoreConfirmMessage;
  static const String permanentDeleteConfirmTitle = ArchiveStrings.permanentDeleteConfirmTitle;
  static const String permanentDeleteConfirmMessage = ArchiveStrings.permanentDeleteConfirmMessage;
  static const String editBeforeRestoreTitle = ArchiveStrings.editBeforeRestoreTitle;
  static const String colEntityType = ArchiveStrings.colEntityType;
  static const String colEntityName = ArchiveStrings.colEntityName;
  static const String colDeletedBy = ArchiveStrings.colDeletedBy;
  static const String colDeletedAt = ArchiveStrings.colDeletedAt;
  static const String colStatus = ArchiveStrings.colStatus;
  static const String colActions = ArchiveStrings.colActions;
  static const String statusActive = ArchiveStrings.statusActive;
  static const String statusRestored = ArchiveStrings.statusRestored;
  static const String statusPermanentlyDeleted = ArchiveStrings.statusPermanentlyDeleted;
  static const String restoredSuccess = ArchiveStrings.restoredSuccess;
  static const String permanentDeleteSuccess = ArchiveStrings.permanentDeleteSuccess;
  static const String archiveSearchHint = ArchiveStrings.archiveSearchHint;
  static const String filterByType = ArchiveStrings.filterByType;
  static const String allTypes = ArchiveStrings.allTypes;
  static const String showingRecords = ArchiveStrings.showingRecords;
  static const String ofRecords = ArchiveStrings.ofRecords;

  // ─── Purchases ───
  static const String newPurchaseTitle = PurchasesStrings.newPurchaseTitle;
  static const String editPurchaseTitle = PurchasesStrings.editPurchaseTitle;
  static const String emptyPurchaseError = PurchasesStrings.emptyPurchaseError;
  static const String selectSupplierError = PurchasesStrings.selectSupplierError;
  static const String confirmExitMessage = PurchasesStrings.confirmExitMessage;
  static const String supplierLabelPurchase = PurchasesStrings.supplierLabel;
  static const String referenceNumberLabel = PurchasesStrings.referenceNumberLabel;
  static const String purchaseDateLabel = PurchasesStrings.purchaseDateLabel;
  static const String purchaseStatusLabel = PurchasesStrings.purchaseStatusLabel;
  static const String selectStatusHint = PurchasesStrings.selectStatusHint;
  static const String statusReceived = PurchasesStrings.statusReceived;
  static const String statusPendingPurchase = PurchasesStrings.statusPending;
  static const String statusOrdered = PurchasesStrings.statusOrdered;
  static const String paymentTermLabel = PurchasesStrings.paymentTermLabel;
  static const String days = PurchasesStrings.days;
  static const String months = PurchasesStrings.months;
  static const String unitLabelShort = PurchasesStrings.unitLabelShort;
  static const String keyboardShortcuts = PurchasesStrings.keyboardShortcuts;
  static const String shortcutSearch = PurchasesStrings.shortcutSearch;
  static const String shortcutSave = PurchasesStrings.shortcutSave;
  static const String shortcutFocusSearch = PurchasesStrings.shortcutFocusSearch;
  static const String shortcutNavigateRows = PurchasesStrings.shortcutNavigateRows;
  static const String shortcutItemSearch = PurchasesStrings.shortcutItemSearch;
  static const String shortcutClearCancel = PurchasesStrings.shortcutClearCancel;
  static const String addItemToInvoiceTitle = PurchasesStrings.addItemToInvoiceTitle;
  static const String searchItemHint = PurchasesStrings.searchItemHint;
  static const String noMatchingResultsPurchase = PurchasesStrings.noMatchingResults;
  static const String barcodeLabelPrefix = PurchasesStrings.barcodeLabelPrefix;
  static const String stockLabelPrefix = PurchasesStrings.stockLabelPrefix;
  static const String currentStockLabelFormat = PurchasesStrings.currentStockLabelFormat;
  static const String incomingQuantity = PurchasesStrings.incomingQuantity;
  static const String buyUnitPrice = PurchasesStrings.buyUnitPrice;
  static const String batchNumberLabel = PurchasesStrings.batchNumberLabel;
  static const String expiryDateLabel = PurchasesStrings.expiryDateLabel;
  static const String selectDatePurchase = PurchasesStrings.selectDate;
  static const String supplyUnit = PurchasesStrings.supplyUnit;
  static const String selectUnitHintPurchase = PurchasesStrings.selectUnitHint;
  static const String itemDiscount = PurchasesStrings.itemDiscount;
  static const String percentSymbol = PurchasesStrings.percentSymbol;
  static const String fixedValue = PurchasesStrings.fixedValue;
  static const String itemTaxValue = PurchasesStrings.itemTaxValue;
  static const String lastPurchasePriceInfo = PurchasesStrings.lastPurchasePriceInfo;
  static const String addToInvoiceAction = PurchasesStrings.addToInvoiceAction;
  static const String newMedicineAction = PurchasesStrings.newMedicineAction;
  static const String columnHash = PurchasesStrings.columnHash;
  static const String columnItemName = PurchasesStrings.columnItemName;
  static const String columnStock = PurchasesStrings.columnStock;
  static const String columnUnit = PurchasesStrings.columnUnit;
  static const String columnQuantity = PurchasesStrings.columnQuantity;
  static const String columnBuyPrice = PurchasesStrings.columnBuyPrice;
  static const String columnDiscountPercent = PurchasesStrings.columnDiscountPercent;
  static const String columnTotal = PurchasesStrings.columnTotal;
  static const String columnSellPrice = PurchasesStrings.columnSellPrice;
  static const String columnBatch = PurchasesStrings.columnBatch;
  static const String columnExpiry = PurchasesStrings.columnExpiry;
  static const String noItemsYet = PurchasesStrings.noItemsYet;
  static const String totalQuantityLabel = PurchasesStrings.totalQuantityLabel;
  static const String totalAmountLabel = PurchasesStrings.totalAmountLabel;
  static const String unitPiece = PurchasesStrings.unitPiece;
  static const String expiryDateFormatHint = PurchasesStrings.expiryDateFormatHint;
  static const String addPaymentTitle = PurchasesStrings.addPaymentTitle;
  static const String paidAmountLabel = PurchasesStrings.paidAmountLabel;
  static const String paidOnDateLabel = PurchasesStrings.paidOnDateLabel;
  static const String paymentMethodLabelPurchase = PurchasesStrings.paymentMethodLabel;
  static const String selectPaymentMethodHint = PurchasesStrings.selectPaymentMethodHint;
  static const String paymentMethodCashPurchase = PurchasesStrings.paymentMethodCash;
  static const String paymentMethodCardPurchase = PurchasesStrings.paymentMethodCard;
  static const String paymentMethodCreditPurchase = PurchasesStrings.paymentMethodCredit;
  static const String accountLabel = PurchasesStrings.accountLabel;
  static const String selectAccountHint = PurchasesStrings.selectAccountHint;
  static const String paymentNoteLabel = PurchasesStrings.paymentNoteLabel;
  static const String dueAmountLabel = PurchasesStrings.dueAmountLabel;

  // ─── Notifications ───
  static const String notificationsCenterTitle = NotificationsStrings.notificationsCenterTitle;
  static const String notificationsCenterSubtitle = NotificationsStrings.notificationsCenterSubtitle;
  static const String unreadNotificationsFormat = NotificationsStrings.unreadNotificationsFormat;
  static const String markAllAsRead = NotificationsStrings.markAllAsRead;
  static const String clearAllNotificationsCenter = NotificationsStrings.clearAll;
  static const String notificationAll = NotificationsStrings.all;
  static const String notificationExpiry = NotificationsStrings.expiry;
  static const String notificationStock = NotificationsStrings.stock;
  static const String notificationSystem = NotificationsStrings.system;
  static const String clearAllNotificationsConfirm = NotificationsStrings.clearAllConfirm;
  static const String noNotifications = NotificationsStrings.noNotifications;
  static const String noNotificationsSubtitle = NotificationsStrings.noNotificationsSubtitle;
  static const String viewNotificationDetails = NotificationsStrings.viewDetails;
  static const String deleteNotification = NotificationsStrings.deleteNotification;
  static const String notificationsTooltip = NotificationsStrings.notificationsTooltip;
  static const String newNotifications = NotificationsStrings.newNotifications;
  static const String noNotificationsCurrent = NotificationsStrings.noNotificationsCurrent;
  static const String viewAll = NotificationsStrings.viewAll;
  static const String agoMinutes = NotificationsStrings.agoMinutes;
  static const String agoHours = NotificationsStrings.agoHours;
  static const String expiryTitle = NotificationsStrings.expiryTitle;
  static const String nearExpiryTitle = NotificationsStrings.nearExpiryTitle;
  static const String lowStockTitle = NotificationsStrings.lowStockTitle;
  static const String expiryMessageFormat = NotificationsStrings.expiryMessageFormat;
  static const String nearExpiryMessageFormat = NotificationsStrings.nearExpiryMessageFormat;
  static const String lowStockMessageFormat = NotificationsStrings.lowStockMessageFormat;

  // ─── Sync ───
  static const String syncStatusTitle = SyncStrings.syncStatusTitle;
  static const String syncStatusSubtitle = SyncStrings.syncStatusSubtitle;
  static const String loadingSyncStatus = SyncStrings.loadingSyncStatus;
  static const String syncDataProgress = SyncStrings.syncDataProgress;
  static const String syncDataSubtitle = SyncStrings.syncDataSubtitle;
  static const String tablesStatus = SyncStrings.tablesStatus;
  static const String pendingQueueFormat = SyncStrings.pendingQueueFormat;
  static const String tablesStatusFormat = SyncStrings.tablesStatusFormat;
  static const String syncTablePrefix = SyncStrings.tablePrefix;
  static const String localRecordsFormat = SyncStrings.localRecordsFormat;
  static const String errorDetailsPrefix = SyncStrings.errorDetailsPrefix;
  static const String syncErrorPrefix = SyncStrings.syncErrorPrefix;
  static const String syncUnknownError = SyncStrings.unknownError;
  static const String syncErrorTip = SyncStrings.syncErrorTip;
  static const String syncStatusPending = SyncStrings.statusPending;
  static const String syncStatusSynced = SyncStrings.statusSynced;
  static const String syncStatusError = SyncStrings.statusError;
  static const String syncStatusIdle = SyncStrings.statusIdle;

  static const String tableMedicines = SyncStrings.tableMedicines;
  static const String tableSales = SyncStrings.tableSales;
  static const String tablePurchases = SyncStrings.tablePurchases;
  static const String tableShifts = SyncStrings.tableShifts;
  static const String tableQuotes = SyncStrings.tableQuotes;
  static const String tableInventory = SyncStrings.tableInventory;
  static const String tableReturns = SyncStrings.tableReturns;
  static const String tableBranches = SyncStrings.tableBranches;
  static const String tableUsers = SyncStrings.tableUsers;
  static const String tablePermissions = SyncStrings.tablePermissions;
  static const String tableCustomers = SyncStrings.tableCustomers;
  static const String tableSuppliers = SyncStrings.tableSuppliers;
  static const String tableSupplierCustomers = SyncStrings.tableSupplierCustomers;
  static const String tableCustomerLedgers = SyncStrings.tableCustomerLedgers;
  static const String tableSupplierLedgers = SyncStrings.tableSupplierLedgers;

  // ─── Barcode ───
  static const String barcodeSettingsTitle = InventoryStrings.barcodeSettingsTitle;
  static const String barcodeSettingsSubtitle = InventoryStrings.barcodeSettingsSubtitle;
  static const String saveBarcodeSettings = InventoryStrings.saveBarcodeSettings;
  static const String generationAlgorithm = InventoryStrings.generationAlgorithm;
  static const String barcodePrefixLabel = InventoryStrings.barcodePrefixLabel;
  static const String serialLengthLabel = InventoryStrings.serialLengthLabel;
  static const String encodingFormatLabel = InventoryStrings.encodingFormatLabel;
  static const String encodingFormatHint = InventoryStrings.encodingFormatHint;
  static const String code128Desc = InventoryStrings.code128Desc;
  static const String ean13Desc = InventoryStrings.ean13Desc;
  static const String pharmacySignatureTitle = InventoryStrings.pharmacySignatureTitle;
  static const String pharmacySignatureSubtitle = InventoryStrings.pharmacySignatureSubtitle;
  static const String pharmacyNameSignature = InventoryStrings.pharmacyNameSignature;
  static const String pharmacyNameSignatureHint = InventoryStrings.pharmacyNameSignatureHint;
  static const String visualLabelDesign = InventoryStrings.visualLabelDesign;
  static const String labelWidthMm = InventoryStrings.labelWidthMm;
  static const String labelHeightMm = InventoryStrings.labelHeightMm;
  static const String labelContents = InventoryStrings.labelContents;
  static const String showSellPrice = InventoryStrings.showSellPrice;
  static const String showItemName = InventoryStrings.showItemName;
  static const String showBarcodeCode = InventoryStrings.showBarcodeCode;
  static const String printLayoutTitle = InventoryStrings.printLayoutTitle;
  static const String pageLayoutLabel = InventoryStrings.pageLayoutLabel;
  static const String thermalPrinterDesc = InventoryStrings.thermalPrinterDesc;
  static const String a4PaperDesc = InventoryStrings.a4PaperDesc;
  static const String defaultCopiesPerItem = InventoryStrings.defaultCopiesPerItem;
  static const String barcodePreviewTitle = InventoryStrings.barcodePreviewTitle;
  static const String barcodePreviewNote = InventoryStrings.barcodePreviewNote;
  static const String barcodePrintTitle = InventoryStrings.barcodePrintTitle;
  static const String barcodePrintSubtitle = InventoryStrings.barcodePrintSubtitle;
  static const String labelSettingsAndSizes = InventoryStrings.labelSettingsAndSizes;
  static const String labelSizeCopiesFormat = InventoryStrings.labelSizeCopiesFormat;
  static const String copiesPerItemLabel = InventoryStrings.copiesPerItemLabel;
  static const String showNameLabel = InventoryStrings.showNameLabel;
  static const String showPriceLabel = InventoryStrings.showPriceLabel;
  static const String showUnitLabel = InventoryStrings.showUnitLabel;
  static const String showBarcodeLabel = InventoryStrings.showBarcodeLabel;
  static const String searchMedicineToPrintHint = InventoryStrings.searchMedicineToPrintHint;
  static const String noBarcode = InventoryStrings.noBarcode;
  static const String emptyPrintListTitle = InventoryStrings.emptyPrintListTitle;
  static const String emptyPrintListSubtitle = InventoryStrings.emptyPrintListSubtitle;
  static const String stockBalanceFormat = InventoryStrings.stockBalanceFormat;
  static const String startPrinting = InventoryStrings.startPrinting;
  static const String labelPreviewDialogTitle = InventoryStrings.labelPreviewDialogTitle;
  static const String closePreview = InventoryStrings.closePreview;
  static const String previewMagnifiedNote = InventoryStrings.previewMagnifiedNote;
  static const String medicineNameArRequired = InventoryStrings.medicineNameArRequired;
  static const String addNewItemType = InventoryStrings.addNewItemType;
  static const String addNewGroup = InventoryStrings.addNewGroup;
  static const String newNameLabel = InventoryStrings.newNameLabel;
  static const String confirmSave = InventoryStrings.confirmSave;
  static const String defaultUnitBox = InventoryStrings.defaultUnitBox;
  static const String defaultUnitStrip = InventoryStrings.defaultUnitStrip;
  static const String defaultUnitPill = InventoryStrings.defaultUnitPill;
  static const String unitLevelPrefix = InventoryStrings.unitLevelPrefix;
  static const String barcodeTakenError = InventoryStrings.barcodeTakenError;
  static const String selectAtLeastOneMedicine = InventoryStrings.selectAtLeastOneMedicine;
  static const String itemsRestoredSuccess = InventoryStrings.itemsRestoredSuccess;
  static const String itemsRestorePartial = InventoryStrings.itemsRestorePartial;
  static const String itemsDeletedPermanently = InventoryStrings.itemsDeletedPermanently;
  static const String itemsDeletePartial = InventoryStrings.itemsDeletePartial;
  static const String initialQuantityLabel = InventoryStrings.initialQuantityLabel;
  static const String saveChangesAction = InventoryStrings.saveChangesAction;
  static const String addMedicineAction = InventoryStrings.addMedicineAction;
  static const String editMedicineSuccess = InventoryStrings.editMedicineSuccess;
  static const String addMedicineSuccess = InventoryStrings.addMedicineSuccess;
  static const String addMedicineToInventoryTitle = InventoryStrings.addMedicineToInventoryTitle;
  static const String fromThisSubUnit = InventoryStrings.fromThisSubUnit;
  static const String inventorySystemSecurity = InventoryStrings.inventorySystemSecurity;
  static const String dosageFormTablets = InventoryStrings.dosageFormTablets;
  static const String dosageFormCapsules = InventoryStrings.dosageFormCapsules;
  static const String dosageFormSyrup = InventoryStrings.dosageFormSyrup;
  static const String dosageFormInjection = InventoryStrings.dosageFormInjection;
  static const String dosageFormCream = InventoryStrings.dosageFormCream;
  static const String dosageFormDrops = InventoryStrings.dosageFormDrops;
  static const String dosageFormPowder = InventoryStrings.dosageFormPowder;
  static const String dosageFormInhaler = InventoryStrings.dosageFormInhaler;
  static const String dosageFormPatch = InventoryStrings.dosageFormPatch;
  static const String dosageFormSuppository = InventoryStrings.dosageFormSuppository;
  static const String dosageFormOther = InventoryStrings.dosageFormOther;
  static const String containerShapeBox = InventoryStrings.containerShapeBox;
  static const String containerShapeStrip = InventoryStrings.containerShapeStrip;
  static const String containerShapeBottle = InventoryStrings.containerShapeBottle;
  static const String containerShapeTube = InventoryStrings.containerShapeTube;
  static const String containerShapePlastic = InventoryStrings.containerShapePlastic;
  static const String containerShapeAmpoule = InventoryStrings.containerShapeAmpoule;
  static const String containerShapeVial = InventoryStrings.containerShapeVial;
  static const String containerShapePreFilledSyringe = InventoryStrings.containerShapePreFilledSyringe;
  static const String containerShapeSachet = InventoryStrings.containerShapeSachet;
  static const String containerShapeSpray = InventoryStrings.containerShapeSpray;
  static const String containerShapeDropper = InventoryStrings.containerShapeDropper;
  static const String containerShapeMetalCan = InventoryStrings.containerShapeMetalCan;
  static const String containerShapeOther = InventoryStrings.containerShapeOther;

  static const String updateExpiryDateHelp = InventoryStrings.updateExpiryDateHelp;
  static const String selectNewExpiryDateHint = InventoryStrings.selectNewExpiryDateHint;
  static const String barcodeTakenElsewhereError = InventoryStrings.barcodeTakenElsewhereError;
  static const String internalConversionFactorLabel = InventoryStrings.internalConversionFactorLabel;
  static const String confirmDateAction = InventoryStrings.confirmDateAction;
  static const String openingShortageInvoicesFormat = InventoryStrings.openingShortageInvoicesFormat;
  static const String advancedPurchaseRequest = InventoryStrings.advancedPurchaseRequest;
  static const String executingOperation = InventoryStrings.executingOperation;
  static const String bulkPriceUpdateTitle = InventoryStrings.bulkPriceUpdateTitle;
  static const String bulkPriceUpdateDesc = InventoryStrings.bulkPriceUpdateDesc;
  static const String bulkPriceUpdateApplyTo = InventoryStrings.bulkPriceUpdateApplyTo;
  static const String bulkPriceUpdateAllItems = InventoryStrings.bulkPriceUpdateAllItems;
  static const String bulkPriceUpdateSelectedCategory = InventoryStrings.bulkPriceUpdateSelectedCategory;
  static const String bulkPriceUpdateCategory = InventoryStrings.bulkPriceUpdateCategory;
  static const String bulkPriceUpdateCategoryHint = InventoryStrings.bulkPriceUpdateCategoryHint;
  static const String bulkPriceUpdateField = InventoryStrings.bulkPriceUpdateField;
  static const String bulkPriceUpdateFieldHint = InventoryStrings.bulkPriceUpdateFieldHint;
  static const String bulkPriceUpdateOperation = InventoryStrings.bulkPriceUpdateOperation;
  static const String bulkPriceUpdateOperationHint = InventoryStrings.bulkPriceUpdateOperationHint;
  static const String bulkPriceUpdateValue = InventoryStrings.bulkPriceUpdateValue;
  static const String bulkPriceUpdateValueHint = InventoryStrings.bulkPriceUpdateValueHint;
  static const String bulkPriceUpdatePercentage = InventoryStrings.bulkPriceUpdatePercentage;
  static const String bulkPriceUpdateApply = InventoryStrings.bulkPriceUpdateApply;
  static const String bulkPriceUpdatePreview = InventoryStrings.bulkPriceUpdatePreview;
  static const String bulkPriceUpdateAffectedItems = InventoryStrings.bulkPriceUpdateAffectedItems;
  static const String bulkPriceUpdateNoItems = InventoryStrings.bulkPriceUpdateNoItems;
  static const String bulkPriceUpdateSuccess = InventoryStrings.bulkPriceUpdateSuccess;
  static const String bulkPriceUpdateConfirm = InventoryStrings.bulkPriceUpdateConfirm;
  static const String bulkPriceUpdateFieldBuyPrice = InventoryStrings.bulkPriceUpdateFieldBuyPrice;
  static const String bulkPriceUpdateFieldSellPrice = InventoryStrings.bulkPriceUpdateFieldSellPrice;
  static const String bulkPriceUpdateFieldBoth = InventoryStrings.bulkPriceUpdateFieldBoth;
  static const String bulkPriceUpdateOpSet = InventoryStrings.bulkPriceUpdateOpSet;
  static const String bulkPriceUpdateOpIncrease = InventoryStrings.bulkPriceUpdateOpIncrease;
  static const String bulkPriceUpdateOpDecrease = InventoryStrings.bulkPriceUpdateOpDecrease;
  static const String bulkPriceUpdateOpIncreasePercent = InventoryStrings.bulkPriceUpdateOpIncreasePercent;
  static const String bulkPriceUpdateOpDecreasePercent = InventoryStrings.bulkPriceUpdateOpDecreasePercent;

  static const String addNewApprovedSupplier = SuppliersStrings.addNewApprovedSupplier;
  static const String companyOrSupplierNameRequired = SuppliersStrings.companyOrSupplierNameRequired;
  static const String supplyType = SuppliersStrings.supplyType;
  static const String supplierOnly = SuppliersStrings.supplierOnly;
  static const String supplierCustomerJoint = SuppliersStrings.supplierCustomerJoint;
  static const String cancelAction = SuppliersStrings.cancelAction;
  static const String saveSupplier = SuppliersStrings.saveSupplier;
  static const String errorLoadingSuppliers = SuppliersStrings.errorLoadingSuppliers;
  static const String activeLabelSupplier = SuppliersStrings.activeLabel;
  static const String inactiveLabelSupplier = SuppliersStrings.inactiveLabel;
  static const String deleteSupplierConfirmTitle = SuppliersStrings.deleteSupplierConfirmTitle;
  static const String deleteSupplierPermanentMessage = SuppliersStrings.deleteSupplierPermanentMessage;
  static const String permanentDeleteActionSupplier = SuppliersStrings.permanentDeleteAction;
  static const String enterTransactionDetailsHint = SuppliersStrings.enterTransactionDetailsHint;
  static const String checkPaymentDataTitle = SuppliersStrings.checkPaymentDataTitle;
  static const String checkReceiptDataTitle = SuppliersStrings.checkReceiptDataTitle;
  static const String confirmOperationAction = SuppliersStrings.confirmOperationAction;
  static const String enterCorrectAmountFirstError = SuppliersStrings.enterCorrectAmountFirstError;

  // ─── Price Quotes ───
  static const String createQuoteTitle = SalesStrings.createQuoteTitle;
  static const String quoteCustomerLabel = SalesStrings.quoteCustomerLabel;
  static const String quoteCustomerHint = SalesStrings.quoteCustomerHint;
  static const String quoteNotesLabel = SalesStrings.quoteNotesLabel;
  static const String quoteNotesHint = SalesStrings.quoteNotesHint;
  static const String quoteItemsSection = SalesStrings.quoteItemsSection;
  static const String itemNameOrService = SalesStrings.itemNameOrService;
  static const String quantityLabel = SalesStrings.quantityLabel;
  static const String unitPriceLabel = SalesStrings.unitPriceLabel;
  static const String totalLabel = SalesStrings.totalLabel;
  static const String addNewItemLine = SalesStrings.addNewItemLine;
  static const String subtotalBeforeDiscount = SalesStrings.subtotalBeforeDiscount;
  static const String discountValueLabel = SalesStrings.discountValueLabel;
  static const String finalNetTotal = SalesStrings.finalNetTotal;
  static const String saveAndIssueQuote = SalesStrings.saveAndIssueQuote;
  static const String enterCustomerNameWarning = SalesStrings.enterCustomerNameWarning;
  static const String addAtLeastOneItemWarning = SalesStrings.addAtLeastOneItemWarning;
  static const String deleteLineTooltip = SalesStrings.deleteLineTooltip;
  static const String itemOrSearchHint = SalesStrings.itemOrSearchHint;
  static const String priceStockFormat = SalesStrings.priceStockFormat;
  static const String quoteStatusDraft = SalesStrings.statusDraft;
  static const String quoteStatusSent = SalesStrings.statusSent;
  static const String quoteStatusAccepted = SalesStrings.statusAccepted;
  static const String quoteStatusRejected = SalesStrings.statusRejected;
  static const String quotesTitle = SalesStrings.quotesTitle;
  static const String errorLoadingQuotes = SalesStrings.errorLoadingQuotes;
  static const String createQuoteAction = SalesStrings.createQuoteAction;
  static const String quoteNumberTitleFormat = SalesStrings.quoteNumberTitleFormat;
  static const String deleteQuoteTitle = SalesStrings.deleteQuoteTitle;
  static const String deleteQuoteConfirmFormat = SalesStrings.deleteQuoteConfirmFormat;
  static const String packing = SalesStrings.packing;
  static const String printInvoice = SalesStrings.printInvoice;
  static const String paymentInfo = SalesStrings.paymentInfo;
  static const String itemsTitle = SalesStrings.itemsTitle;
  static const String saleDetailsTitle = SalesStrings.saleDetailsTitle;
  static const String amountPaid = SalesStrings.amountPaid;
  static const String method = SalesStrings.method;

  static const String stockLimitExceeded = SalesStrings.stockLimitExceeded;
  static const String barcodeOrNameSearch = SalesStrings.barcodeOrNameSearch;
  static const String startTypingOrScan = SalesStrings.startTypingOrScan;
  static const String quickNavTooltip = SalesStrings.quickNavTooltip;
  static const String homeAction = SalesStrings.homeAction;
  static const String hideCatalog = SalesStrings.hideCatalog;
  static const String showCatalog = SalesStrings.showCatalog;
  static const String shiftInfoFormat = SalesStrings.shiftInfoFormat;
  static const String shiftIsClosed = SalesStrings.shiftIsClosed;
  static const String closeShiftTitle = SalesStrings.closeShiftTitle;
  static const String cashSalesLabel = SalesStrings.cashSalesLabel;
  static const String expectedCashLabel = SalesStrings.expectedCashLabel;
  static const String actualCashLabel = SalesStrings.actualCashLabel;
  static const String optionalNotesLabel = SalesStrings.optionalNotesLabel;
  static const String defaultSellPriceGroup = SalesStrings.defaultSellPriceGroup;
  static const String regularPriceLabel = SalesStrings.regularPriceLabel;
  static const String wholesalePriceLabel = SalesStrings.wholesalePriceLabel;
  static const String semiWholesalePriceLabel = SalesStrings.semiWholesalePriceLabel;
  static const String fastCashCustomer = SalesStrings.fastCashCustomer;
  static const String balanceFormat = SalesStrings.balanceFormat;

  static const String salesReturnsTitle = SalesStrings.salesReturnsTitle;
  static const String createReturnAction = SalesStrings.createReturnAction;
  static const String searchReturnHintSales = SalesStrings.searchReturnHintSales;
  static const String totalReturnsLabel = SalesStrings.totalReturnsLabel;
  static const String totalReturnedAmountsSales = SalesStrings.totalReturnedAmountsSales;
  static const String returnNumberPrefix = SalesStrings.returnNumberPrefix;
  static const String createSalesReturnTitle = SalesStrings.createSalesReturnTitle;
  static const String selectOriginalInvoiceHint = SalesStrings.selectOriginalInvoiceHint;
  static const String selectInvoiceHint = SalesStrings.selectInvoiceHint;
  static const String invoiceNumberDateFormat = SalesStrings.invoiceNumberDateFormat;
  static const String returnReasonLabel = SalesStrings.returnReasonLabel;
  static const String reasonWrongItemSales = SalesStrings.reasonWrongItemSales;
  static const String reasonCustomerReturn = SalesStrings.reasonCustomerReturn;
  static const String confirmReturnAction = SalesStrings.confirmReturnAction;
  static const String selectAtLeastOneItemError = SalesStrings.selectAtLeastOneItemError;

  static const String startNewShift = SalesStrings.startNewShift;
  static const String enterInitialCashHint = SalesStrings.enterInitialCashHint;
  static const String openShiftAction = SalesStrings.openShiftAction;
  static const String enterOpeningBalanceHint = SalesStrings.enterOpeningBalanceHint;
  static const String shiftOpenedSuccess = SalesStrings.shiftOpenedSuccess;
  static const String shiftClosedSuccess = SalesStrings.shiftClosedSuccess;
  static const String paymentMismatch = SalesStrings.paymentMismatch;
  static const String shiftOpenFailedFormat = SalesStrings.shiftOpenFailedFormat;

  static const String cashierShiftsTitle = SalesStrings.cashierShiftsTitle;
  static const String startNewSession = SalesStrings.startNewSession;
  static const String openCashier = SalesStrings.openCashier;
  static const String openingDate = SalesStrings.openingDate;
  static const String openingCash = SalesStrings.openingCash;
  static const String closingDate = SalesStrings.closingDate;
  static const String closingCash = SalesStrings.closingCash;
  static const String invoiceCount = SalesStrings.invoiceCount;
  static const String totalReturns = SalesStrings.totalReturns;
  static const String netAmount = SalesStrings.netAmount;
  static const String saleType = SalesStrings.saleType;
  static const String returnType = SalesStrings.returnType;

  static const String advancedLedgerReportTitle = ReportsStrings.advancedLedgerReportTitle;
  static const String customerType = ReportsStrings.customerType;
  static const String supplierCustomerTypeReport = ReportsStrings.supplierCustomerType;
  static const String exportSuccessReports = ReportsStrings.exportSuccess;
  static const String exportFailedFormat = ReportsStrings.exportFailedFormat;
  static const String fromDateLabel = ReportsStrings.fromDateLabel;
  static const String toDateLabel = ReportsStrings.toDateLabel;
  static const String sortLabel = ReportsStrings.sortLabel;
  static const String sortByBalance = ReportsStrings.sortByBalance;
  static const String sortByName = ReportsStrings.sortByName;
  static const String sortByDate = ReportsStrings.sortByDate;
  static const String openingBalanceLabelReports = ReportsStrings.openingBalanceLabel;
  static const String prepaidLabel = ReportsStrings.prepaidLabel;
  static const String addedDateLabel = ReportsStrings.addedDateLabel;
  static const String unpaidPurchasesLabel = ReportsStrings.unpaidPurchasesLabel;
  static const String purchaseReturnsLabelReports = ReportsStrings.purchaseReturnsLabel;
  static const String finalDueLabel = ReportsStrings.finalDueLabel;

  // ─── Extra Reports ───
  static const String typeCustomerGroups = ReportsStrings.typeCustomerGroups;
  static const String typeReceipts = ReportsStrings.typeReceipts;
  static const String typeSalesRepPerformance = ReportsStrings.typeSalesRepPerformance;
  static const String subtitleInventory = ReportsStrings.subtitleInventory;
  static const String subtitleInventoryCount = ReportsStrings.subtitleInventoryCount;
  static const String subtitlePopularItems = ReportsStrings.subtitlePopularItems;
  static const String subtitleItemMovement = ReportsStrings.subtitleItemMovement;
  static const String subtitleTaxSummary = ReportsStrings.subtitleTaxSummary;
  static const String subtitleEmployeeActivity = ReportsStrings.subtitleEmployeeActivity;
  static const String subtitleCustomerGroups = ReportsStrings.subtitleCustomerGroups;
  static const String subtitleReceipts = ReportsStrings.subtitleReceipts;
  static const String subtitleSalesRepPerformance = ReportsStrings.subtitleSalesRepPerformance;
  static const String movementTypeSale = ReportsStrings.movementTypeSale;
  static const String movementTypePurchase = ReportsStrings.movementTypePurchase;
  static const String movementTypeSaleReturn = ReportsStrings.movementTypeSaleReturn;
  static const String movementTypePurchaseReturn = ReportsStrings.movementTypePurchaseReturn;
  static const String receiptTypeSaleInvoice = ReportsStrings.receiptTypeSaleInvoice;
  static const String receiptTypePurchaseInvoice = ReportsStrings.receiptTypePurchaseInvoice;
  static const String taxTypeVatSales = ReportsStrings.taxTypeVatSales;
  static const String taxTypeIncomePurchase = ReportsStrings.taxTypeIncomePurchase;
  static const String taxTypeExpense = ReportsStrings.taxTypeExpense;
  static const String activityShiftOpen = ReportsStrings.activityShiftOpen;
  static const String activityShiftClose = ReportsStrings.activityShiftClose;
  static const String activitySubjectShift = ReportsStrings.activitySubjectShift;
  static const String activitySubjectEmployee = ReportsStrings.activitySubjectEmployee;
  static const String activityActionAddUser = ReportsStrings.activityActionAddUser;
  static const String activityRoleOwner = ReportsStrings.activityRoleOwner;
  static const String activityRoleEmployee = ReportsStrings.activityRoleEmployee;
  static const String activityNotesShiftFormat = ReportsStrings.activityNotesShiftFormat;
  static const String defaultNoGroup = ReportsStrings.defaultNoGroup;
  static const String paymentCash = ReportsStrings.paymentCash;
  static const String paymentCard = ReportsStrings.paymentCard;
  static const String paymentCredit = ReportsStrings.paymentCredit;
  static const String paymentWallet = ReportsStrings.paymentWallet;
  static const String paymentBankTransfer = ReportsStrings.paymentBankTransfer;
  static const String unitAndInvoiceFormat = ReportsStrings.unitAndInvoiceFormat;
  static const String visitsLabel = ReportsStrings.visitsLabel;
  static const String inventoryMovementReportTitleFormat = ReportsStrings.inventoryMovementReportTitleFormat;
  static const String inventoryReportTitle = ReportsStrings.inventoryReportTitle;
  static const String customerGroupAnalysisTitle = ReportsStrings.customerGroupAnalysisTitle;
  static const String receiptSummaryTitle = ReportsStrings.receiptSummaryTitle;
  static const String salesRepPerformanceTitle = ReportsStrings.salesRepPerformanceTitle;

  // ─── Purchases ───
  static const String purchaseReturnsTitle = PurchasesStrings.purchaseReturnsTitle;
  static const String purchaseReturnsSubtitle = PurchasesStrings.purchaseReturnsSubtitle;
  static const String addNewReturn = PurchasesStrings.addNewReturn;
  static const String searchReturnHint = PurchasesStrings.searchReturnHint;
  static const String totalOperations = PurchasesStrings.totalOperations;
  static const String totalReturnedAmounts = PurchasesStrings.totalReturnedAmounts;
  static const String noPurchaseReturns = PurchasesStrings.noPurchaseReturns;
  static const String noPurchaseReturnsSubtitle = PurchasesStrings.noPurchaseReturnsSubtitle;
  static const String purchaseReturnInvoicePrefix = PurchasesStrings.purchaseReturnInvoicePrefix;
  static const String supplierPrefix = PurchasesStrings.supplierPrefix;
  static const String itemsCountFormat = PurchasesStrings.itemsCountFormat;
  static const String originalInvoice = PurchasesStrings.originalInvoice;
  static const String reasonLabel = PurchasesStrings.reasonLabel;
  static const String reasonExpired = PurchasesStrings.reasonExpired;
  static const String reasonDamaged = PurchasesStrings.reasonDamaged;
  static const String reasonWrongItem = PurchasesStrings.reasonWrongItem;
  static const String reasonOther = PurchasesStrings.reasonOther;
  static const String undefined = PurchasesStrings.undefined;

  // ─── Void Operations ───
  static const String voidOperationsTitle = VoidOperationsStrings.voidOperationsTitle;
  static const String voidOperationsSalesTab = VoidOperationsStrings.voidOperationsSalesTab;
  static const String voidOperationsPurchasesTab = VoidOperationsStrings.voidOperationsPurchasesTab;
  static const String voidOperationsEmptySales = VoidOperationsStrings.voidOperationsEmptySales;
  static const String voidOperationsEmptyPurchases = VoidOperationsStrings.voidOperationsEmptyPurchases;
  static const String voidOperationsCancel = VoidOperationsStrings.voidOperationsCancel;
  static const String voidOperationsConfirmCancel = VoidOperationsStrings.voidOperationsConfirmCancel;
  static const String voidOperationsReasonLabel = VoidOperationsStrings.voidOperationsReasonLabel;
  static const String voidOperationsReasonHint = VoidOperationsStrings.voidOperationsReasonHint;
  static const String voidOperationsWarning = VoidOperationsStrings.voidOperationsWarning;
  static const String voidOperationsSuccess = VoidOperationsStrings.voidOperationsSuccess;
  static const String voidOperationsTitleSale = VoidOperationsStrings.voidOperationsTitleSale;
  static const String voidOperationsTitlePurchase = VoidOperationsStrings.voidOperationsTitlePurchase;
  static const String voidOperationsReasonError = VoidOperationsStrings.voidOperationsReasonError;
  static const String voidOperationsReasonReturn = VoidOperationsStrings.voidOperationsReasonReturn;
  static const String voidOperationsReasonCancelOrder = VoidOperationsStrings.voidOperationsReasonCancelOrder;
  static const String voidOperationsReasonOther = VoidOperationsStrings.voidOperationsReasonOther;
  static const String voidOperationsInvoiceFormat = VoidOperationsStrings.voidOperationsInvoiceFormat;
  static const String voidOperationsCustomerFormat = VoidOperationsStrings.voidOperationsCustomerFormat;
  static const String voidOperationsSupplierFormat = VoidOperationsStrings.voidOperationsSupplierFormat;
  static const String voidOperationsAmountFormat = VoidOperationsStrings.voidOperationsAmountFormat;
  static const String voidOperationsItemsFormat = VoidOperationsStrings.voidOperationsItemsFormat;
  static const String voidOperationsCardFormat = VoidOperationsStrings.voidOperationsCardFormat;

  // ─── Notifications (أكشنات القوائم الموحّدة) ───
  static const String deleteAllNotifications = AdminStrings.deleteAllNotifications;
  static const String deleteAll = AdminStrings.deleteAll;

  // ─── Admin Sidebar ───
  static const String sidebarGroupSales = AdminStrings.sidebarGroupSales;
  static const String sidebarGroupPurchases = AdminStrings.sidebarGroupPurchases;
  static const String sidebarGroupInventory = AdminStrings.sidebarGroupInventory;
  static const String sidebarGroupReports = AdminStrings.sidebarGroupReports;
  static const String sidebarGroupAdmin = AdminStrings.sidebarGroupAdmin;
  static const String sidebarItemCustomersContacts = AdminStrings.sidebarItemCustomersContacts;
  static const String sidebarItemCustomerDirectory = AdminStrings.sidebarItemCustomerDirectory;
  static const String sidebarItemStocktaking = AdminStrings.sidebarItemStocktaking;
  static const String sidebarItemInventoryTools = AdminStrings.sidebarItemInventoryTools;
  static const String sidebarItemStockTransfer = AdminStrings.sidebarItemStockTransfer;
  static const String sidebarItemStockAdjustment = AdminStrings.sidebarItemStockAdjustment;
  static const String sidebarItemBulkPriceUpdate = AdminStrings.sidebarItemBulkPriceUpdate;
  static const String sidebarItemPromotions = AdminStrings.sidebarItemPromotions;
  static const String sidebarItemImportItems = AdminStrings.sidebarItemImportItems;
  static const String sidebarItemItemsArchive = AdminStrings.sidebarItemItemsArchive;
  static const String sidebarItemInventorySettings = AdminStrings.sidebarItemInventorySettings;
  static const String sidebarItemBrands = AdminStrings.sidebarItemBrands;
  static const String sidebarItemPriceGroups = AdminStrings.sidebarItemPriceGroups;
  static const String sidebarItemVariants = AdminStrings.sidebarItemVariants;
  static const String sidebarItemReportsHub = AdminStrings.sidebarItemReportsHub;
  static const String sidebarItemExtraReports = AdminStrings.sidebarItemExtraReports;
  static const String sidebarItemAdvancedLedger = AdminStrings.sidebarItemAdvancedLedger;
  static const String sidebarItemAccounting = AdminStrings.sidebarItemAccounting;
  static const String sidebarItemAccountingDashboard = AdminStrings.sidebarItemAccountingDashboard;
  static const String sidebarItemHr = AdminStrings.sidebarItemHr;
  static const String sidebarItemAdminTools = AdminStrings.sidebarItemAdminTools;
  static const String sidebarItemAdminTasks = AdminStrings.sidebarItemAdminTasks;
  static const String sidebarItemVoidOperations = AdminStrings.sidebarItemVoidOperations;
  static const String sidebarItemNotifications = AdminStrings.sidebarItemNotifications;
  static const String sidebarItemSyncStatus = AdminStrings.sidebarItemSyncStatus;

  // ─── Shift Labels ───
  static const String totalSalesLabelShifts = SalesStrings.shiftTotalSales;
  static const String cardSalesLabelShifts = SalesStrings.cardSalesLabelShifts;
  static const String creditSalesLabelShifts = SalesStrings.creditSalesLabelShifts;
  static const String openLabel = SalesStrings.openLabel;
  static const String closedLabel = SalesStrings.closedLabel;
  static const String openingLabelShifts = SalesStrings.openingLabelShifts;
  static const String fromDatePrefix = GeneralStrings.fromDatePrefix;
  static const String toDatePrefix = GeneralStrings.toDatePrefix;
  static const String actualAmountPrefix = SalesStrings.actualAmountPrefix;
  static const String noShiftsYet = SalesStrings.noShiftsYet;
  static const String closeAction = StocktakingStrings.stocktakingClose;
  static const String itemNameLabel = SalesStrings.itemNameLabel;
  static const String quantity = SalesStrings.quantityLabel;
  static const String totalPrice = GeneralStrings.total;

  // ─── POS Messages ───
  static const String defaultUserName = GeneralStrings.defaultUserName;
  
  static String posNoStockFormat(String name, String qty) => 
      SalesStrings.posNoStockFormat.replaceFirst('%s', name).replaceFirst('%s', qty);
      
  static String posBarcodeNotFoundFormat(String code) => 
      SalesStrings.posBarcodeNotFoundFormat.replaceFirst('%s', code);
      
  static const String posCreditNeedsCustomer = SalesStrings.posCreditNeedsCustomer;
  
  static String posShiftOpenedFormat(String number) => 
      SalesStrings.posShiftOpenedFormat.replaceFirst('%s', number);
      
  static const String posShiftNotFound = SalesStrings.posShiftNotFound;
  
  static String posShiftClosedFormat(String number, String diff) => 
      SalesStrings.posShiftClosedFormat.replaceFirst('%s', number).replaceFirst('%s', diff);
      
  static String posShiftCloseFailedFormat(String error) => 
      SalesStrings.posShiftCloseFailedFormat.replaceFirst('%s', error);
      
  static const String posShiftRequired = SalesStrings.posShiftRequired;
  
  static String posSaleSuccessFormat(String receiptNumber) => 
      SalesStrings.posSaleSuccessFormat.replaceFirst('%s', receiptNumber);
      
  static String posSaleFailedFormat(String error) => 
      SalesStrings.posSaleFailedFormat.replaceFirst('%s', error);
      
  static String posPrintWarningFormat(String error) => 
      SalesStrings.posPrintWarningFormat.replaceFirst('%s', error);
      
  static const String posCartEmpty = SalesStrings.posCartEmpty;
  static const String posSaleSuspended = SalesStrings.posSaleSuspended;
  static const String posSaleResumed = SalesStrings.posSaleResumed;
  static const String posCartEmptyForQuote = SalesStrings.posCartEmptyForQuote;
  static const String posQuoteCreated = SalesStrings.posQuoteCreated;
  static const String posExpenseRequiredShift = SalesStrings.posExpenseRequiredShift;
  
  static String posExpenseRecordedFormat(String number, String desc, String amount) => 
      SalesStrings.posExpenseRecordedFormat.replaceFirst('%s', number).replaceFirst('%s', desc).replaceFirst('%s', amount);
      
  static const String posExpenseLogged = SalesStrings.posExpenseLogged;
  static const String posCustomerNotFound = SalesStrings.posCustomerNotFound;
  
  static String posCustomerPaymentFormat(String name, String amount) => 
      SalesStrings.posCustomerPaymentFormat.replaceFirst('%s', name).replaceFirst('%s', amount);
      
  static const String posSupplierNotFound = SalesStrings.posSupplierNotFound;
  
  static String posSupplierPaymentFormat(String name, String amount) => 
      SalesStrings.posSupplierPaymentFormat.replaceFirst('%s', name).replaceFirst('%s', amount);
      
  static const String posEditSaleLoaded = SalesStrings.posEditSaleLoaded;
  static const String posEditQuoteLoaded = SalesStrings.posEditQuoteLoaded;
  static const String posAutoPrintEnabled = SalesStrings.posAutoPrintEnabled;
  static const String posAutoPrintDisabled = SalesStrings.posAutoPrintDisabled;
  static const String posCashCustomer = SalesStrings.posCashCustomer;

  // ─── POS Nav Drawer ───
  static const String saleScreenNav = SalesStrings.saleScreenNav;
  static const String salesInvoicesNav = SalesStrings.salesInvoicesNav;
  static const String salesReturnNav = SalesStrings.salesReturnNav;
  static const String shiftsNav = SalesStrings.shiftsNav;
  static const String inventoryNav = SalesStrings.inventoryNav;
  static const String purchasesNav = SalesStrings.purchasesNav;
  static const String customersNav = SalesStrings.customersNav;
  static const String suppliersNav = SalesStrings.suppliersNav;
  static const String salesReportsNav = SalesStrings.salesReportsNav;
  static const String accountingNav = SalesStrings.accountingNav;
  static const String homeNav = SalesStrings.homeNav;

  // ─── POS Totals Bar ───
  static const String grandTotalLabel = SalesStrings.grandTotalLabel;
  static const String collapseLabel = SalesStrings.collapseLabel;
  static const String detailsLabel = SalesStrings.detailsLabel;
  static const String itemCountFormat = SalesStrings.itemCountFormat;

  // ─── Edit Cart Line Dialog ───
  static const String unitPriceFieldLabel = SalesStrings.unitPriceFieldLabel;
  static const String discountTypeFieldLabel = SalesStrings.discountTypeFieldLabel;
  static const String fixedAmountShort = SalesStrings.fixedAmountShort;
  static const String discountAmountFieldLabel = SalesStrings.discountAmountFieldLabel;
  static const String itemNotesFieldLabel = SalesStrings.itemNotesFieldLabel;

  // ─── POS Catalog Panel ───
  static const String searchItemsHint = SalesStrings.searchItemsHint;
  static const String noItemsFound = SalesStrings.noItemsFound;

  // ─── Shift Report Dialog ───
  static const String noOpenShiftWarning = SalesStrings.noOpenShiftWarning;
  static const String noOpenShiftEndWarning = SalesStrings.noOpenShiftEndWarning;
  static const String sessionDetailsTitle = SalesStrings.sessionDetailsTitle;
  static const String printReportLabel = SalesStrings.printReportLabel;
  static const String endSessionTitle = SalesStrings.endSessionTitle;
  static const String endSessionNowLabel = SalesStrings.endSessionNowLabel;
  static const String enterValidAmountMsg = SalesStrings.enterValidAmountMsg;
  static const String sessionClosedSuccessMsg = SalesStrings.sessionClosedSuccessMsg;
  static const String actualCashFieldLabel = SalesStrings.actualCashFieldLabel;
  static const String closingNoteFieldLabel = SalesStrings.closingNoteFieldLabel;
  static const String returnsLabel = SalesStrings.returnsLabel;
  static const String paymentSummaryTitle = SalesStrings.paymentSummaryTitle;
  static const String salesColumnHeader = SalesStrings.salesColumnHeader;
  static const String expenseColumnHeader = SalesStrings.expenseColumnHeader;
  static const String paymentCashRow = SalesStrings.paymentCashRow;
  static const String paymentCardRow = SalesStrings.paymentCardRow;
  static const String creditSaleRow = SalesStrings.creditSaleRow;
  static const String mixedPaymentRow = SalesStrings.mixedPaymentRow;
  static const String expectedDrawerTotalRow = SalesStrings.expectedDrawerTotalRow;
  static const String soldItemsSectionTitle = SalesStrings.soldItemsSectionTitle;
  static const String noSalesInShiftMsg = SalesStrings.noSalesInShiftMsg;
  static const String drawerDetailsSectionTitle = SalesStrings.drawerDetailsSectionTitle;
  static const String openingBalanceRow = SalesStrings.openingBalanceRow;
  static const String cashSalesRow = SalesStrings.cashSalesRow;
  static const String customerCollectionsRow = SalesStrings.customerCollectionsRow;
  static const String cashExpensesRow = SalesStrings.cashExpensesRow;
  static const String finalExpectedTotalRow = SalesStrings.finalExpectedTotalRow;

  // ─── Desktop Dialogs ───
  static const String addTaxTitle = SalesStrings.addTaxTitle;
  static const String addInvoiceDiscountTitle = SalesStrings.addInvoiceDiscountTitle;
  static const String taxAmountFieldLabel = SalesStrings.taxAmountFieldLabel;
  static const String currentBalanceFormat = SalesStrings.currentBalanceFormat;
  static const String fixedAmountChipLabel = SalesStrings.fixedAmountChipLabel;
  static const String selectCustomerFirstWarning = SalesStrings.selectCustomerFirstWarning;
  static const String noDataForCustomerTitle = SalesStrings.noDataForCustomerTitle;
  static const String noDataForCustomerSubtitle = SalesStrings.noDataForCustomerSubtitle;
  static const String customerQuotesSectionTitle = SalesStrings.customerQuotesSectionTitle;
  static const String pendingDraftsSectionTitle = SalesStrings.pendingDraftsSectionTitle;
  static const String invoiceItemSummaryFormat = SalesStrings.invoiceItemSummaryFormat;
  static const String confirmVoidInvoiceMsg = SalesStrings.confirmVoidInvoiceMsg;
  static const String quickExpensesLabel = SalesStrings.quickExpensesLabel;
  static const String expenseDescriptionLabel = SalesStrings.expenseDescriptionLabel;
  static const String expenseDescriptionHint = SalesStrings.expenseDescriptionHint;
  static const String expenseAmountLabel = SalesStrings.expenseAmountLabel;
  static const String quoteNumberFormatShort = SalesStrings.quoteNumberFormatShort;
  static const String discountPercentFormat = SalesStrings.discountPercentFormat;
  static const String discountFixedFormat = SalesStrings.discountFixedFormat;
  static const String unnamedCustomer = SalesStrings.unnamedCustomer;
  static const String jointSupplierCustomer = SalesStrings.jointSupplierCustomer;
  static const String creditLimitFormat = SalesStrings.creditLimitFormat;
  static const List<String> quickExpenseOptions = SalesStrings.quickExpenseOptions;

  // ─── Widget Strings (Table) & Reports ───
  static const String tableSearchHint = WidgetStrings.tableSearchHint;
  static const String tableColumnsVisibility = WidgetStrings.tableColumnsVisibility;
  static const String tableDensity = WidgetStrings.tableDensity;
  static const String tableDensityCompact = WidgetStrings.tableDensityCompact;
  static const String tableDensityMedium = WidgetStrings.tableDensityMedium;
  static const String tableDensityComfortable = WidgetStrings.tableDensityComfortable;
  static const String tableExport = WidgetStrings.tableExport;
  static const String tableExportCsv = WidgetStrings.tableExportCsv;
  static const String tableExportExcel = WidgetStrings.tableExportExcel;
  static const String tablePrint = WidgetStrings.tablePrint;
  static const String tableSelectAll = WidgetStrings.tableSelectAll;
  static const String tableDeselectAll = WidgetStrings.tableDeselectAll;
  static const String tableTotalSummary = WidgetStrings.tableTotalSummary;
  static const String tableAllRows = WidgetStrings.tableAllRows;
  static const String todayLabel = ReportsStrings.todayLabel;
}
