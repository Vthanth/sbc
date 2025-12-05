class Order {
  final String id;
  final String customerName;
  final String orderNumber;
  final DateTime orderDate;
  final String status;
  final String role; // 'sales' or 'service'

  Order({
    required this.id,
    required this.customerName,
    required this.orderNumber,
    required this.orderDate,
    required this.status,
    required this.role,
  });

  // Sample data generator
  static List<Order> getSampleOrders(String role) {
    return [
      Order(
        id: '1',
        customerName: 'John Doe',
        orderNumber: 'ORD-001',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        status: 'Pending',
        role: role,
      ),
      Order(
        id: '2',
        customerName: 'Jane Smith',
        orderNumber: 'ORD-002',
        orderDate: DateTime.now().subtract(const Duration(hours: 5)),
        status: 'In Progress',
        role: role,
      ),
      Order(
        id: '3',
        customerName: 'Mike Johnson',
        orderNumber: 'ORD-003',
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'Completed',
        role: role,
      ),
      Order(
        id: '4',
        customerName: 'Sarah Williams',
        orderNumber: 'ORD-004',
        orderDate: DateTime.now(),
        status: 'New',
        role: role,
      ),
    ];
  }
}
