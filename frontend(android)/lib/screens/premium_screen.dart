import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMonth;
  String? _selectedYear;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _showSuccessDialog() {
    _controller.forward();
    showDialog(
      context: context,
      builder: (context) => FadeTransition(
        opacity: _opacityAnimation,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Success'),
          content: const Text('Payment method added successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.reset();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double contentWidth = constraints.maxWidth < 600
                ? constraints.maxWidth
                : 500; // For web/desktop center the form

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Container(
                  width: contentWidth,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTopIcon('lib/assets/app-drawer.png'),
                            const Text(
                              'Payment Method',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                            _buildTopIcon('lib/assets/crown.png'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        const Center(
                          child: Text(
                            'Credit Card Details',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Payment method logos
                        DottedBorder(
                          color: Colors.grey.shade400,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(8),
                          dashPattern: [6, 3],
                          strokeWidth: 1,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Payment Method',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Image.asset('lib/assets/mastercard.png', height: 24),
                                    const SizedBox(width: 6),
                                    Image.asset('lib/assets/visa.png', height: 24),
                                    const SizedBox(width: 6),
                                    Image.asset('lib/assets/amex.png', height: 24),
                                    const SizedBox(width: 6),
                                    Image.asset('lib/assets/discover.png', height: 24),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _nameController,
                          label: 'Name on card',
                          hint: 'Meet Patel',
                          validator: (value) => value!.isEmpty ? 'Required field' : null,
                        ),
                        _buildTextField(
                          controller: _cardController,
                          label: 'Card number',
                          hint: '0000 0000 0000 0000',
                          validator: (value) => value!.length < 16 ? 'Enter valid card number' : null,
                        ),

                        const Text('Card expiration', style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                hint: 'Month',
                                value: _selectedMonth,
                                items: List.generate(12, (i) => '${i + 1}'),
                                onChanged: (val) => setState(() => _selectedMonth = val),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdown(
                                hint: 'Year',
                                value: _selectedYear,
                                items: List.generate(10, (i) => '${2024 + i}'),
                                onChanged: (val) => setState(() => _selectedYear = val),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _codeController,
                          label: 'Card Security Code',
                          hint: 'Code',
                          suffixIcon: Icons.help_outline,
                          validator: (value) => value!.length < 3 ? 'Invalid code' : null,
                        ),
                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B1A55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  _selectedMonth != null &&
                                  _selectedYear != null) {
                                _showSuccessDialog();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please complete all fields')),
                                );
                              }
                            },
                            child: const Text(
                              'Continue',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopIcon(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1A55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(
        assetPath,
        height: 20,
        width: 20,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20) : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Required' : null,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _cardController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}
