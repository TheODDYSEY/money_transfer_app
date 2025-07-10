import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_send_button_simple.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _selectedPaymentMethod = 'Card';
  bool _isLoading = false;
  bool _saveAsContact = false;

  final List<String> _paymentMethods = [
    'Card',
    'Bank Transfer',
    'Mobile Money',
    'Crypto Wallet'
  ];

  final List<double> _quickAmounts = [50, 100, 200, 500, 1000];

  final List<Map<String, dynamic>> _favoriteContacts = [
    {
      'name': 'John Doe',
      'phone': '+1 (555) 123-4567',
      'avatar': 'J',
      'lastSent': '\$250.00',
    },
    {
      'name': 'Sarah Wilson',
      'phone': '+1 (555) 987-6543',
      'avatar': 'S',
      'lastSent': '\$1,200.00',
    },
    {
      'name': 'Mike Johnson',
      'phone': '+1 (555) 456-7890',
      'avatar': 'M',
      'lastSent': '\$75.50',
    },
  ];

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _selectQuickAmount(double amount) {
    _amountController.text = amount.toString();
  }

  void _selectFavoriteContact(Map<String, dynamic> contact) {
    _recipientController.text = contact['name'];
  }

  void _handleSendMoney() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success!'),
            content: Text(
              'Successfully sent \$${_amountController.text} to ${_recipientController.text}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Send Money',
                      style: AppTheme.headingStyle.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Favorite Contacts
                          Text(
                            'Favorite Contacts',
                            style: AppTheme.headingStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _favoriteContacts.length,
                              itemBuilder: (context, index) {
                                final contact = _favoriteContacts[index];
                                return GestureDetector(
                                  onTap: () => _selectFavoriteContact(contact),
                                  child: Container(
                                    width: 70,
                                    margin: const EdgeInsets.only(right: 16),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor:
                                              AppTheme.primaryColor,
                                          child: Text(
                                            contact['avatar'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          contact['name'].split(' ')[0],
                                          style: AppTheme.captionStyle,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Recipient Field
                          TextFormField(
                            controller: _recipientController,
                            style: AppTheme.bodyStyle.copyWith(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Recipient',
                              hintText: 'Enter name or phone number',
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: AppTheme.primaryColor,
                              ),
                              labelStyle: AppTheme.bodyStyle,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter recipient name or phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Amount Field
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            style: AppTheme.bodyStyle.copyWith(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              hintText: 'Enter amount',
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: AppTheme.primaryColor,
                              ),
                              labelStyle: AppTheme.bodyStyle,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter amount';
                              }
                              final amount = double.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return 'Please enter a valid amount';
                              }
                              if (amount > 10000) {
                                return 'Amount exceeds daily limit';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Quick Amount Selection
                          Text(
                            'Quick Amount',
                            style: AppTheme.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _quickAmounts.map((amount) {
                              return GestureDetector(
                                onTap: () => _selectQuickAmount(amount),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: AppTheme.borderColor),
                                  ),
                                  child: Text(
                                    '\$${amount.toStringAsFixed(0)}',
                                    style: AppTheme.bodyStyle.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // Payment Method Dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedPaymentMethod,
                            style: AppTheme.bodyStyle.copyWith(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Payment Method',
                              prefixIcon: Icon(
                                Icons.payment,
                                color: AppTheme.primaryColor,
                              ),
                              labelStyle: AppTheme.bodyStyle,
                            ),
                            items: _paymentMethods.map((method) {
                              return DropdownMenuItem(
                                value: method,
                                child: Text(
                                  method,
                                  style: AppTheme.bodyStyle.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPaymentMethod = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // Note Field
                          TextFormField(
                            controller: _noteController,
                            maxLines: 3,
                            style: AppTheme.bodyStyle.copyWith(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Note (Optional)',
                              hintText: 'Add a note for this transaction',
                              prefixIcon: Icon(
                                Icons.note_outlined,
                                color: AppTheme.primaryColor,
                              ),
                              labelStyle: AppTheme.bodyStyle,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Save as Contact Switch
                          SwitchListTile(
                            title: Text(
                              'Save as Contact',
                              style: AppTheme.bodyStyle,
                            ),
                            subtitle: Text(
                              'Add recipient to your favorites',
                              style: AppTheme.captionStyle,
                            ),
                            value: _saveAsContact,
                            activeColor: AppTheme.primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _saveAsContact = value;
                              });
                            },
                          ),
                          const SizedBox(height: 32),

                          // Send Button
                          CustomSendButton(
                            text: 'Send Money',
                            onPressed: _handleSendMoney,
                            isLoading: _isLoading,
                            icon: Icons.send,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
