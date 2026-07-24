import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:pharmacy_system/app/core/models/contacts/customer_group_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_customer_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/sales_agent_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/contact_ledger_model.dart';

import '../database/database.dart';

class ContactsMapper {
  // ── CustomerGroup ──────────────────────────────────────────────────────────

  static CustomerGroupModel customerGroupFromData(CustomerGroupsTableData d) =>
      CustomerGroupModel(
        id: d.id,
        name: d.name,
        discountPercent: d.discountPercent,
        priceGroupId: d.priceGroupId,
        description: d.description,
        isActive: d.isActive,
        accountId: d.accountId,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
        syncVersion: d.syncVersion,
      );

  static CustomerGroupsTableCompanion customerGroupToCompanion(
          CustomerGroupModel m) =>
      CustomerGroupsTableCompanion(
        id: Value(m.id),
        name: Value(m.name),
        discountPercent: Value(m.discountPercent),
        priceGroupId: Value(m.priceGroupId),
        description: Value(m.description),
        isActive: Value(m.isActive),
        accountId: Value(m.accountId),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: Value(m.syncVersion),
      );

  // ── Customer ───────────────────────────────────────────────────────────────

  static CustomerModel customerFromData(CustomersTableData d) => CustomerModel(
        id: d.id,
        name: d.name,
        phone: d.phone,
        secondPhone: d.secondPhone,
        address: d.address,
        email: d.email,
        groupId: d.groupId,
        groupName: d.groupName,
        creditLimit: d.creditLimit,
        discountPercent: d.discountPercent,
        debitAmount: d.debitAmount,
        creditAmount: d.creditAmount,
        isActive: d.isActive,
        notes: d.notes,
        branchId: d.branchId,
        accountId: d.accountId,
        syncVersion: d.syncVersion,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
      );

  static CustomersTableCompanion customerToCompanion(CustomerModel m) =>
      CustomersTableCompanion(
        id: Value(m.id),
        name: Value(m.name),
        phone: Value(m.phone),
        secondPhone: Value(m.secondPhone),
        address: Value(m.address),
        email: Value(m.email),
        groupId: Value(m.groupId),
        groupName: Value(m.groupName),
        creditLimit: Value(m.creditLimit),
        discountPercent: Value(m.discountPercent),
        debitAmount: Value(m.debitAmount),
        creditAmount: Value(m.creditAmount),
        isActive: Value(m.isActive),
        notes: Value(m.notes),
        branchId: Value(m.branchId),
        accountId: Value(m.accountId),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: Value(m.syncVersion),
      );

  // ── Supplier ───────────────────────────────────────────────────────────────

  static SupplierModel supplierFromData(SuppliersTableData d) => SupplierModel(
        id: d.id,
        name: d.name,
        phone: d.phone,
        address: d.address,
        email: d.email,
        contactPerson: d.contactPerson,
        taxId: d.taxId,
        creditAmount: d.creditAmount,
        debitAmount: d.debitAmount,
        paymentTermDays: d.paymentTermDays,
        isActive: d.isActive,
        notes: d.notes,
        branchId: d.branchId,
        accountId: d.accountId,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
        syncVersion: d.syncVersion,
      );

  static SuppliersTableCompanion supplierToCompanion(SupplierModel m) =>
      SuppliersTableCompanion(
        id: Value(m.id),
        name: Value(m.name),
        phone: Value(m.phone),
        address: Value(m.address),
        email: Value(m.email),
        contactPerson: Value(m.contactPerson),
        taxId: Value(m.taxId),
        creditAmount: Value(m.creditAmount),
        debitAmount: Value(m.debitAmount),
        paymentTermDays: Value(m.paymentTermDays),
        isActive: Value(m.isActive),
        notes: Value(m.notes),
        branchId: Value(m.branchId),
        accountId: Value(m.accountId),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: Value(m.syncVersion),
      );

  // ── SupplierCustomer ───────────────────────────────────────────────────────

  static SupplierCustomerModel supplierCustomerFromData(
          SupplierCustomersTableData d) =>
      SupplierCustomerModel(
        id: d.id,
        name: d.name,
        phone: d.phone,
        address: d.address,
        email: d.email,
        companyName: d.companyName,
        taxId: d.taxId,
        creditLimit: d.creditLimit,
        discountPercent: d.discountPercent,
        paymentTermDays: d.paymentTermDays,
        supplierBalance: d.supplierBalance,
        customerBalance: d.customerBalance,
        isActive: d.isActive,
        notes: d.notes,
        branchId: d.branchId,
        accountId: d.accountId,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
      );

  static SupplierCustomersTableCompanion supplierCustomerToCompanion(
          SupplierCustomerModel m) =>
      SupplierCustomersTableCompanion(
        id: Value(m.id),
        name: Value(m.name),
        phone: Value(m.phone),
        address: Value(m.address),
        email: Value(m.email),
        companyName: Value(m.companyName),
        taxId: Value(m.taxId),
        creditLimit: Value(m.creditLimit),
        discountPercent: Value(m.discountPercent),
        paymentTermDays: Value(m.paymentTermDays),
        supplierBalance: Value(m.supplierBalance),
        customerBalance: Value(m.customerBalance),
        isActive: Value(m.isActive),
        notes: Value(m.notes),
        branchId: Value(m.branchId),
        accountId: Value(m.accountId),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: const Value.absent(),
      );

  // ── SalesAgent ─────────────────────────────────────────────────────────────

  static SalesAgentModel salesAgentFromData(SalesRepsTableData d) =>
      SalesAgentModel(
        id: d.id,
        name: d.name,
        phone: d.phone,
        email: d.email,
        commissionPercentage: d.commissionPercentage,
        totalCommissionEarned: d.totalCommissionEarned,
        isActive: d.isActive,
        branchId: d.branchId,
        accountId: d.accountId,
        notes: d.notes,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
        syncVersion: d.syncVersion,
      );

  static SalesRepsTableCompanion salesAgentToCompanion(SalesAgentModel m) =>
      SalesRepsTableCompanion(
        id: Value(m.id),
        name: Value(m.name),
        phone: Value(m.phone),
        email: Value(m.email),
        commissionPercentage: Value(m.commissionPercentage),
        totalCommissionEarned: Value(m.totalCommissionEarned),
        isActive: Value(m.isActive),
        notes: Value(m.notes),
        branchId: Value(m.branchId),
        accountId: Value(m.accountId),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: Value(m.syncVersion),
      );

  // ── ContactLedger ──────────────────────────────────────────────────────────

  static ContactLedgerModel contactLedgerFromData(ContactLedgersTableData d) =>
      ContactLedgerModel(
        id: d.id,
        contactId: d.contactId,
        transactionDate: d.entryDate,
        referenceNumber: d.referenceNumber,
        transactionType: LedgerTransactionType.values.firstWhere(
          (t) => t.name == d.entryType,
          orElse: () => LedgerTransactionType.saleInvoice,
        ),
        debitAmount: d.debit,
        creditAmount: d.credit,
        runningBalance: d.balanceAfter,
        description: d.description,
        branchId: d.branchId,
        accountId: d.accountId,
        syncVersion: d.syncVersion,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
      );

  static ContactLedgersTableCompanion contactLedgerToCompanion(
          ContactLedgerModel m) =>
      ContactLedgersTableCompanion(
        id: Value(m.id),
        contactId: Value(m.contactId),
        entryDate: Value(m.transactionDate),
        referenceNumber: Value(m.referenceNumber),
        entryType: Value(m.transactionType.name),
        debit: Value(m.debitAmount),
        credit: Value(m.creditAmount),
        balanceAfter: Value(m.runningBalance),
        description: Value(m.description),
        branchId: Value(m.branchId),
        accountId: Value(m.accountId),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: Value(m.syncVersion),
      );
}
