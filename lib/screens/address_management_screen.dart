import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';

class AddressManagementScreen extends StatefulWidget {
  final bool selectMode; // If true, tapping an address selects it and pops back

  const AddressManagementScreen({super.key, this.selectMode = false});

  @override
  State<AddressManagementScreen> createState() => _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  void _showAddressForm({Address? existingAddress}) {
    final labelCtrl = TextEditingController(text: existingAddress?.label ?? 'Home');
    final streetCtrl = TextEditingController(text: existingAddress?.street ?? '');
    final cityCtrl = TextEditingController(text: existingAddress?.city ?? '');
    final zipCtrl = TextEditingController(text: existingAddress?.zip ?? '');
    final instructionsCtrl = TextEditingController(text: existingAddress?.deliveryInstructions ?? '');
    String selectedLabel = existingAddress?.label ?? 'Home';
    double selectedLat = existingAddress?.lat ?? 28.6139;
    double selectedLng = existingAddress?.lng ?? 77.2090;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      existingAddress != null ? 'Edit Address' : 'Add New Address',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 16),

                    // Mock Visual Map Picker Area
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: MiniMapPainter(lat: selectedLat, lng: selectedLng),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on, color: AppTheme.orange, size: 36),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Lat: ${selectedLat.toStringAsFixed(4)}, Lng: ${selectedLng.toStringAsFixed(4)}',
                                    style: const TextStyle(color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setModalState(() {
                                  // Simulate detecting current location
                                  selectedLat = 28.62 + (indexCounter % 100) * 0.001;
                                  selectedLng = 77.21 + (indexCounter % 100) * 0.001;
                                  indexCounter++;
                                  streetCtrl.text = 'Flat 40B, Shanti Kunj Apartments';
                                  cityCtrl.text = 'New Delhi';
                                  zipCtrl.text = '110070';
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Current GPS location detected!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.orange,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                textStyle: const TextStyle(fontSize: 10),
                              ),
                              icon: const Icon(Icons.my_location, size: 12, color: Colors.white),
                              label: const Text('Detect GPS', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Label Selector
                    Row(
                      children: ['Home', 'Work', 'Custom'].map((lbl) {
                        final isSel = selectedLabel == lbl;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setModalState(() => selectedLabel = lbl),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSel ? AppTheme.orangeLight : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSel ? AppTheme.orange : AppTheme.border,
                                  width: isSel ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    lbl == 'Home'
                                        ? Icons.home_outlined
                                        : (lbl == 'Work' ? Icons.work_outline : Icons.place_outlined),
                                    color: isSel ? AppTheme.orange : AppTheme.textSecondary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    lbl,
                                    style: TextStyle(
                                      color: isSel ? AppTheme.orange : AppTheme.textPrimary,
                                      fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: streetCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Street Name / Apartment No',
                        prefixIcon: Icon(Icons.apartment, color: AppTheme.orange, size: 20),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: cityCtrl,
                            decoration: const InputDecoration(
                              labelText: 'City',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: zipCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Zip Code',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: instructionsCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Delivery Instructions (optional)',
                        hintText: 'e.g. Leave with guard, ring doorbell...',
                        prefixIcon: Icon(Icons.note_alt_outlined, color: AppTheme.orange, size: 20),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        if (streetCtrl.text.isEmpty || cityCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter street and city details')),
                          );
                          return;
                        }

                        final state = AppStateProvider.of(context, listen: false);
                        final fullAddr = '${streetCtrl.text.trim()}, ${cityCtrl.text.trim()} - ${zipCtrl.text.trim()}';
                        final newAddr = Address(
                          id: existingAddress?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                          label: selectedLabel,
                          street: streetCtrl.text.trim(),
                          city: cityCtrl.text.trim(),
                          zip: zipCtrl.text.trim(),
                          fullAddress: fullAddr,
                          deliveryInstructions: instructionsCtrl.text.trim(),
                          lat: selectedLat,
                          lng: selectedLng,
                        );

                        if (existingAddress != null) {
                          state.updateAddress(existingAddress.id, newAddr);
                        } else {
                          state.addAddress(newAddr);
                        }

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(existingAddress != null ? 'Address updated successfully!' : 'Address added successfully!'),
                            backgroundColor: AppTheme.green,
                          ),
                        );
                      },
                      child: const Text('Save Address', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  int indexCounter = 1;

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final list = state.addresses;
    final selected = state.selectedAddress;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Address Management'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.location_off_outlined, size: 72, color: AppTheme.textMuted),
                          SizedBox(height: 16),
                          Text(
                            'No addresses saved yet',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add your home, work, or custom delivery address to begin ordering.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final isSelected = selected?.id == item.id;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppTheme.orange : AppTheme.border,
                            width: isSelected ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            state.selectAddress(item);
                            if (widget.selectMode) {
                              Navigator.pop(context);
                            }
                          },
                          contentPadding: const EdgeInsets.all(12),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.orangeLight : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.label == 'Home'
                                  ? Icons.home
                                  : (item.label == 'Work' ? Icons.work : Icons.location_on),
                              color: isSelected ? AppTheme.orange : AppTheme.textSecondary,
                              size: 20,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                item.label,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.orangeLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Selected',
                                    style: TextStyle(color: AppTheme.orange, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                item.fullAddress,
                                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                              ),
                              if (item.deliveryInstructions.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.info_outline, size: 12, color: AppTheme.orange),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item.deliveryInstructions,
                                        style: TextStyle(color: Colors.orange.shade800, fontSize: 10, fontStyle: FontStyle.italic),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppTheme.textSecondary, size: 18),
                                onPressed: () => _showAddressForm(existingAddress: item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                                onPressed: () {
                                  state.deleteAddress(item.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Address deleted')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: () => _showAddressForm(),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add New Address',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.orange,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MiniMapPainter extends CustomPainter {
  final double lat;
  final double lng;

  MiniMapPainter({required this.lat, required this.lng});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE3F2FD);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final roadBorderPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    // Draw random stylized grids
    final path = Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.2, size.height)
      ..moveTo(size.width * 0.7, 0)
      ..lineTo(size.width * 0.7, size.height)
      ..moveTo(0, size.height * 0.4)
      ..lineTo(size.width, size.height * 0.4)
      ..moveTo(0, size.height * 0.8)
      ..lineTo(size.width, size.height * 0.8);

    canvas.drawPath(path, roadBorderPaint);
    canvas.drawPath(path, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
