import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_model.dart';
import 'package:pharmacy_system/app/core/data/repositories/customers_repository.dart';
import 'package:pharmacy_system/app/core/injection.dart';

class CustomerService {
  static CustomersRepository get _repo => sl<CustomersRepository>();
  static const _uuid = Uuid();

  static Future<void> init() async {
    // ????? ????? ????? ??? ??? ?????
    await _repo.getCustomers();
  }

  /// ???? ????? ??????? ?? ????? (?????? ?? ???????? ?????????)
  static List<CustomerModel> getAll({bool activeOnly = false}) {
    return _repo.getCachedCustomers(activeOnly: activeOnly);
  }

  /// ??? ????? ???????? ?? ????????? (Async)
  static Future<List<CustomerModel>> refreshAll({bool activeOnly = false}) async {
    return await _repo.getCustomers(activeOnly: activeOnly);
  }

  static CustomerModel? getById(String id) {
    return _repo.getById(id);
  }

  static Future<CustomerModel> add({
    required String name,
    required CustomerKind kind,
    String? phone,
    String? address,
    String? companyName,
    String? email,
    String? taxId,
    double creditLimit = 0,
    double discountPercent = 0,
    int paymentTermDays = 0,
    String? notes,
  }) async {
    final customer = CustomerModel(
      id: _uuid.v4(),
      name: name,
      kind: kind,
      phone: phone,
      address: address,
      companyName: companyName,
      email: email,
      taxId: taxId,
      creditLimit: creditLimit,
      discountPercent: discountPercent,
      paymentTermDays: paymentTermDays,
      notes: notes,
    );
    await _repo.create(customer);
    return customer;
  }

  static Future<void> update(CustomerModel customer) async {
    await _repo.update(customer);
  }

  static Future<void> delete(String id) async {
    final customer = _repo.getById(id);
    if (customer != null) {
      await _repo.delete(customer);
    }
  }

  static Future<void> deactivate(String id) async {
    final customer = _repo.getById(id);
    if (customer != null) {
      await _repo.update(customer.copyWith(isActive: false));
    }
  }

  static Future<void> activate(String id) async {
    final customer = _repo.getById(id);
    if (customer != null) {
      await _repo.update(customer.copyWith(isActive: true));
    }
  }

  static Future<void> hardDelete(String id) async {
    final customer = _repo.getById(id);
    if (customer != null) {
      await _repo.delete(customer);
    }
  }
}




