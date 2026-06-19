import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrderSubItem {
  final String name;
  final int qty;
  final double price;

  const OrderSubItem({
    required this.name,
    required this.qty,
    required this.price,
  });
}

class OrderItem {
  final String id;
  final String studentName;
  final String time;
  final String status; // 'Baru', 'Sedang Dimasak', 'Siap Diambil', 'Siap Diantar'
  final String? deliveryLocation;
  final List<OrderSubItem> items;
  final double totalAmount;

  const OrderItem({
    required this.id,
    required this.studentName,
    required this.time,
    required this.status,
    this.deliveryLocation,
    required this.items,
    required this.totalAmount,
  });

  OrderItem copyWith({
    String? status,
    String? deliveryLocation,
  }) {
    return OrderItem(
      id: id,
      studentName: studentName,
      time: time,
      status: status ?? this.status,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      items: items,
      totalAmount: totalAmount,
    );
  }
}

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  String _selectedTab = 'semua'; // 'semua', 'baru', 'proses'

  // Initial mock list matching the counts in the screenshot:
  // Semua Pesanan (12) = Baru (5) + Proses (7)
  late List<OrderItem> _orders;

  @override
  void initState() {
    super.initState();
    _orders = [
      const OrderItem(
        id: '1',
        studentName: 'Budi Santoso',
        time: '10:15 WIB',
        status: 'Sedang Dimasak',
        items: [
          OrderSubItem(name: 'Nasi Goreng Spesial', qty: 1, price: 15000),
          OrderSubItem(name: 'Es Teh Manis', qty: 1, price: 5000),
        ],
        totalAmount: 20000,
      ),
      const OrderItem(
        id: '2',
        studentName: 'Siti Aminah',
        time: '09:45 WIB',
        status: 'Siap Diambil',
        items: [
          OrderSubItem(name: 'Mie Ayam Bakso', qty: 2, price: 30000),
          OrderSubItem(name: 'Jus Jeruk', qty: 1, price: 8000),
        ],
        totalAmount: 38000,
      ),
      const OrderItem(
        id: '3',
        studentName: 'Agus Pratama',
        time: '09:30 WIB',
        status: 'Siap Diantar',
        deliveryLocation: 'Ruang Guru',
        items: [
          OrderSubItem(name: 'Kopi Hitam', qty: 3, price: 15000),
          OrderSubItem(name: 'Roti Bakar Coklat', qty: 1, price: 12000),
        ],
        totalAmount: 27000,
      ),
      const OrderItem(
        id: '4',
        studentName: 'Dewi Lestari',
        time: '10:30 WIB',
        status: 'Baru',
        items: [
          OrderSubItem(name: 'Ayam Geprek', qty: 1, price: 15000),
          OrderSubItem(name: 'Air Mineral', qty: 1, price: 3000),
        ],
        totalAmount: 18000,
      ),
      const OrderItem(
        id: '5',
        studentName: 'Rian Hidayat',
        time: '10:25 WIB',
        status: 'Baru',
        items: [
          OrderSubItem(name: 'Roti Bakar', qty: 2, price: 16000),
          OrderSubItem(name: 'Susu Coklat', qty: 2, price: 10000),
        ],
        totalAmount: 26000,
      ),
      const OrderItem(
        id: '6',
        studentName: 'Eka Saputra',
        time: '10:20 WIB',
        status: 'Baru',
        items: [
          OrderSubItem(name: 'Nasi Uduk', qty: 1, price: 12000),
          OrderSubItem(name: 'Teh Tawar', qty: 1, price: 3000),
        ],
        totalAmount: 15000,
      ),
      const OrderItem(
        id: '7',
        studentName: 'Lina Marlina',
        time: '10:10 WIB',
        status: 'Baru',
        items: [
          OrderSubItem(name: 'Batagor', qty: 1, price: 10000),
        ],
        totalAmount: 10000,
      ),
      const OrderItem(
        id: '8',
        studentName: 'Dedi Kurniawan',
        time: '10:05 WIB',
        status: 'Baru',
        items: [
          OrderSubItem(name: 'Siomay', qty: 2, price: 16000),
          OrderSubItem(name: 'Es Jeruk', qty: 1, price: 7000),
        ],
        totalAmount: 23000,
      ),
      const OrderItem(
        id: '9',
        studentName: 'Fajar Siddiq',
        time: '09:55 WIB',
        status: 'Sedang Dimasak',
        items: [
          OrderSubItem(name: 'Soto Ayam', qty: 1, price: 15000),
          OrderSubItem(name: 'Es Teh Manis', qty: 1, price: 5000),
        ],
        totalAmount: 20000,
      ),
      const OrderItem(
        id: '10',
        studentName: 'Hendra Wijaya',
        time: '09:50 WIB',
        status: 'Sedang Dimasak',
        items: [
          OrderSubItem(name: 'Bakso Kuah', qty: 2, price: 24000),
        ],
        totalAmount: 24000,
      ),
      const OrderItem(
        id: '11',
        studentName: 'Rini Anggraini',
        time: '09:40 WIB',
        status: 'Sedang Dimasak',
        items: [
          OrderSubItem(name: 'Gado-Gado', qty: 1, price: 12000),
          OrderSubItem(name: 'Es Jeruk', qty: 1, price: 7000),
        ],
        totalAmount: 19000,
      ),
      const OrderItem(
        id: '12',
        studentName: 'Mega Lestari',
        time: '09:35 WIB',
        status: 'Sedang Dimasak',
        items: [
          OrderSubItem(name: 'Mie Goreng', qty: 1, price: 12000),
        ],
        totalAmount: 12000,
      ),
    ];
  }

  void _updateOrderStatus(String id, String newStatus) {
    setState(() {
      _orders = _orders.map((order) {
        if (order.id == id) {
          return order.copyWith(status: newStatus);
        }
        return order;
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status pesanan berhasil diubah menjadi "$newStatus"'),
        backgroundColor: const Color(0xFF006767),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter calculations
    final List<OrderItem> filteredOrders = _orders.where((order) {
      if (_selectedTab == 'baru') {
        return order.status == 'Baru';
      } else if (_selectedTab == 'proses') {
        return order.status == 'Sedang Dimasak' ||
            order.status == 'Siap Diambil' ||
            order.status == 'Siap Diantar';
      }
      return true; // 'semua'
    }).toList();

    final int countSemua = _orders.length;
    final int countBaru = _orders.where((o) => o.status == 'Baru').length;
    final int countProses = _orders.where((o) =>
        o.status == 'Sedang Dimasak' ||
        o.status == 'Siap Diambil' ||
        o.status == 'Siap Diantar').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FE),
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: Border(
          bottom: BorderSide(
            color: const Color(0xFFBDC9C8).withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        leading: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                CupertinoIcons.person_crop_circle,
                color: Color(0xFF006767),
                size: 24,
              ),
              onPressed: () {
                // Placeholder profile action
              },
            ),
          ),
        ),
        title: Text(
          'Daftar Pesanan',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006767),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.bell,
              color: Color(0xFF006767),
              size: 24,
            ),
            onPressed: () {
              // Placeholder notification action
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Segmented Tabs Header Row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Row(
                    children: [
                      _buildTabButton('semua', 'Semua Pesanan ($countSemua)'),
                      const SizedBox(width: 8),
                      _buildTabButton('baru', 'Baru ($countBaru)'),
                      const SizedBox(width: 8),
                      _buildTabButton('proses', 'Proses ($countProses)'),
                    ],
                  ),
                ),

                // Order Cards List
                Expanded(
                  child: filteredOrders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.square_list,
                                size: 64,
                                color: Color(0xFFBDC9C8),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada pesanan',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF7A7A7A),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            return _buildOrderCard(filteredOrders[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String tabKey, String label) {
    final bool isSelected = _selectedTab == tabKey;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = tabKey;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF006767) : const Color(0xFFEAEAEA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF7A7A7A),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderItem order) {
    // Determine card indicator color and badge details
    Color indicatorColor;
    Color badgeBgColor;
    Color badgeTextColor;
    IconData badgeIcon;
    String badgeLabel = order.status;

    if (order.status == 'Sedang Dimasak') {
      indicatorColor = const Color(0xFFFFB300); // Amber
      badgeBgColor = const Color(0xFFFEF5E7);
      badgeTextColor = const Color(0xFFD35400);
      badgeIcon = Icons.soup_kitchen;
    } else if (order.status == 'Siap Diambil') {
      indicatorColor = const Color(0xFF2ECC71); // Green
      badgeBgColor = const Color(0xFFEBFDF2);
      badgeTextColor = const Color(0xFF15803D);
      badgeIcon = Icons.shopping_bag_outlined;
    } else if (order.status == 'Siap Diantar') {
      indicatorColor = const Color(0xFF2ECC71); // Green
      badgeBgColor = const Color(0xFFEBFDF2);
      badgeTextColor = const Color(0xFF15803D);
      badgeIcon = Icons.local_shipping_outlined;
      if (order.deliveryLocation != null) {
        badgeLabel = 'Siap Diantar (${order.deliveryLocation})';
      }
    } else {
      // 'Baru'
      indicatorColor = const Color(0xFF3498DB); // Blue
      badgeBgColor = const Color(0xFFEFF6FF);
      badgeTextColor = const Color(0xFF1D4ED8);
      badgeIcon = Icons.fiber_new_outlined;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left color stripe
            Container(
              width: 5,
              color: indicatorColor,
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top header: Name + Status Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            order.studentName,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1C1F),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                badgeIcon,
                                size: 12,
                                color: badgeTextColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                badgeLabel,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: badgeTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Time Row
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.time,
                          size: 13,
                          color: Color(0xFF7A7A7A),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.time,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF7A7A7A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // List of items
                    ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.qty}x ${item.name}',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF4A4A4A),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Rp ${NumberFormat('#,###', 'id_ID').format(item.price * item.qty)}',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF4A4A4A),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 8),

                    // Dashed Divider
                    _buildDashedDivider(),
                    const SizedBox(height: 8),

                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1C1F),
                          ),
                        ),
                        Text(
                          'Rp ${NumberFormat('#,###', 'id_ID').format(order.totalAmount)}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1C1F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Status Dropdown selector
                    Align(
                      alignment: Alignment.bottomRight,
                      child: PopupMenuButton<String>(
                        onSelected: (newStatus) {
                          _updateOrderStatus(order.id, newStatus);
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: 'Baru',
                            child: Text('Baru'),
                          ),
                          const PopupMenuItem(
                            value: 'Sedang Dimasak',
                            child: Text('Sedang Dimasak'),
                          ),
                          const PopupMenuItem(
                            value: 'Siap Diambil',
                            child: Text('Siap Diambil'),
                          ),
                          const PopupMenuItem(
                            value: 'Siap Diantar',
                            child: Text('Siap Diantar'),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                order.status,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF3A3A3C),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                CupertinoIcons.chevron_down,
                                size: 10,
                                color: Color(0xFF3A3A3C),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashedDivider() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFE5E5EA)),
              ),
            );
          }),
        );
      },
    );
  }
}
