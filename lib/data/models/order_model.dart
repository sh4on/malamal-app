/// order customer address details model
class OrderCustomer {
  final String name;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String? note;

  const OrderCustomer({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    this.note,
  });

  /// map json to OrderCustomer instance
  factory OrderCustomer.fromJson(Map<String, dynamic> json) {
    return OrderCustomer(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      note: json['note'],
    );
  }

  /// serialize OrderCustomer instance to json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'city': city,
      'note': note,
    };
  }
}

/// order simple item sku entry model
class OrderItem {
  final String sku;
  final int quantity;
  final String? name;
  final double? price;
  final String? image;

  const OrderItem({
    required this.sku,
    required this.quantity,
    this.name,
    this.price,
    this.image,
  });

  /// map json to OrderItem instance
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      sku: json['sku'] ?? '',
      quantity: json['quantity'] ?? 0,
      name: json['name'] ?? json['title'],
      price: (json['price'] as num?)?.toDouble() ?? (json['unitPrice'] as num?)?.toDouble(),
      image: json['image'],
    );
  }

  /// serialize OrderItem to json
  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'quantity': quantity,
      'name': name,
      'price': price,
      'image': image,
    };
  }
}

/// shopping order details model
class OrderModel {
  final String id;
  final String? reference;
  final String? invoiceId;
  final double amount;
  final String status;
  final List<OrderItem> items;
  final OrderCustomer customer;
  final String paymentMethod;
  final String? createdAt;

  const OrderModel({
    required this.id,
    this.reference,
    this.invoiceId,
    required this.amount,
    required this.status,
    required this.items,
    required this.customer,
    required this.paymentMethod,
    this.createdAt,
  });

  /// map json to OrderModel instance
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List?;
    final itemsList = list != null
        ? list.map((e) => OrderItem.fromJson(e)).toList()
        : const <OrderItem>[];

    return OrderModel(
      id: json['id'] ?? json['_id'] ?? '',
      reference: json['reference'],
      invoiceId: json['invoice_id'] ?? json['invoiceId'],
      amount: (json['amount'] as num?)?.toDouble() ??
          (json['total'] as num?)?.toDouble() ??
          (json['totalAmount'] as num?)?.toDouble() ??
          0.0,
      status: json['status'] ?? 'PENDING',
      items: itemsList,
      customer: OrderCustomer.fromJson(json['customer'] ?? {}),
      paymentMethod: json['paymentMethod'] ?? 'COD',
      createdAt: json['createdAt'],
    );
  }

  /// serialize OrderModel to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'invoice_id': invoiceId,
      'amount': amount,
      'status': status,
      'items': items.map((e) => e.toJson()).toList(),
      'customer': customer.toJson(),
      'paymentMethod': paymentMethod,
      'createdAt': createdAt,
    };
  }
}
