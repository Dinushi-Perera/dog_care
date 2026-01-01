import 'package:flutter/material.dart';
import 'product_catalog.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  
  const CartScreen({Key? key, required this.cartItems}) : super(key: key);
  
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? selectedPaymentMethod;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        widget.cartItems.removeAt(index);
      } else {
        widget.cartItems[index].quantity = newQuantity;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item removed from cart'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearCart() {
    setState(() {
      widget.cartItems.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cart cleared'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showBill() {
    double subtotal = widget.cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
    double tax = subtotal * 0.1; // 10% tax
    double delivery = 200.0; // Fixed delivery charge
    double total = subtotal + tax + delivery;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bill Summary', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Items:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                ...widget.cartItems.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('${item.quantity}x ${item.product.name}',
                            style: TextStyle(fontSize: 14)),
                      ),
                      Text('Rs ${(item.product.price * item.quantity).toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                )).toList(),
                Divider(thickness: 1),
                _buildBillRow('Subtotal:', 'Rs ${subtotal.toStringAsFixed(2)}'),
                _buildBillRow('Tax (10%):', 'Rs ${tax.toStringAsFixed(2)}'),
                _buildBillRow('Delivery:', 'Rs ${delivery.toStringAsFixed(2)}'),
                Divider(thickness: 2),
                _buildBillRow('Total:', 'Rs ${total.toStringAsFixed(2)}', isTotal: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showPaymentMethodDialog(total);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Proceed to Payment'),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentMethodDialog(double totalAmount) {
    selectedPaymentMethod = null;
    _cardNumberController.clear();
    _expiryController.clear();
    _cvvController.clear();
    _phoneController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Select Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Container(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Amount: Rs ${totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                      SizedBox(height: 16),
                      
                      // Payment Method Selection
                      Text('Choose Payment Method:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      
                      // Cash on Delivery
                      RadioListTile<String>(
                        title: Row(
                          children: [
                            Icon(Icons.money, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Cash on Delivery'),
                          ],
                        ),
                        value: 'cod',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedPaymentMethod = value;
                          });
                        },
                      ),
                      
                      // Credit/Debit Card
                      RadioListTile<String>(
                        title: Row(
                          children: [
                            Icon(Icons.credit_card, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Credit/Debit Card'),
                          ],
                        ),
                        value: 'card',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedPaymentMethod = value;
                          });
                        },
                      ),
                      
                      // Card Details (show only if card is selected)
                      if (selectedPaymentMethod == 'card') ...[
                        SizedBox(height: 16),
                        Text('Card Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        TextField(
                          controller: _cardNumberController,
                          decoration: InputDecoration(
                            labelText: 'Card Number',
                            hintText: '1234 5678 9012 3456',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.credit_card),
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 19,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _expiryController,
                                decoration: InputDecoration(
                                  labelText: 'MM/YY',
                                  hintText: '12/25',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 5,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _cvvController,
                                decoration: InputDecoration(
                                  labelText: 'CVV',
                                  hintText: '123',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                      
                      // Mobile Payment
                      RadioListTile<String>(
                        title: Row(
                          children: [
                            Icon(Icons.phone_android, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Mobile Payment'),
                          ],
                        ),
                        value: 'mobile',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedPaymentMethod = value;
                          });
                        },
                      ),
                      
                      // Mobile Payment Details (show only if mobile is selected)
                      if (selectedPaymentMethod == 'mobile') ...[
                        SizedBox(height: 16),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                            hintText: '077 123 4567',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                        ),
                      ],
                      
                      // Bank Transfer
                      RadioListTile<String>(
                        title: Row(
                          children: [
                            Icon(Icons.account_balance, color: Colors.purple),
                            SizedBox(width: 8),
                            Text('Bank Transfer'),
                          ],
                        ),
                        value: 'bank',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedPaymentMethod = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_validatePayment()) {
                      Navigator.of(context).pop();
                      _processPayment(totalAmount);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Pay Now'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool _validatePayment() {
    if (selectedPaymentMethod == null) {
      _showAlert('Payment Method Required', 'Please select a payment method to continue.', Colors.orange);
      return false;
    }

    if (selectedPaymentMethod == 'card') {
      if (_cardNumberController.text.isEmpty || _cardNumberController.text.length < 16) {
        _showAlert('Invalid Card Number', 'Please enter a valid card number.', Colors.red);
        return false;
      }
      if (_expiryController.text.isEmpty || !_expiryController.text.contains('/')) {
        _showAlert('Invalid Expiry Date', 'Please enter a valid expiry date (MM/YY).', Colors.red);
        return false;
      }
      if (_cvvController.text.isEmpty || _cvvController.text.length < 3) {
        _showAlert('Invalid CVV', 'Please enter a valid CVV code.', Colors.red);
        return false;
      }
    }

    if (selectedPaymentMethod == 'mobile') {
      if (_phoneController.text.isEmpty || _phoneController.text.length < 10) {
        _showAlert('Invalid Mobile Number', 'Please enter a valid mobile number.', Colors.red);
        return false;
      }
    }

    return true;
  }

  void _showAlert(String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: color),
              SizedBox(width: 8),
              Text(title, style: TextStyle(color: color)),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _processPayment(double amount) {
    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Processing payment...'),
            ],
          ),
        );
      },
    );

    // Simulate payment processing
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close processing dialog
      _showPaymentSuccess(amount);
    });
  }

  void _showPaymentSuccess(double amount) {
    String paymentMethodName = '';
    switch (selectedPaymentMethod) {
      case 'cod':
        paymentMethodName = 'Cash on Delivery';
        break;
      case 'card':
        paymentMethodName = 'Credit/Debit Card';
        break;
      case 'mobile':
        paymentMethodName = 'Mobile Payment';
        break;
      case 'bank':
        paymentMethodName = 'Bank Transfer';
        break;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.check_circle, color: Colors.green, size: 60),
          title: Text('Payment Successful!', style: TextStyle(color: Colors.green)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Payment of Rs ${amount.toStringAsFixed(2)} has been processed successfully.'),
              SizedBox(height: 8),
              Text('Payment Method: $paymentMethodName', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Your order has been confirmed and will be processed shortly.'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showOrderConfirmation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBillRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          )),
          Text(amount, style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? Colors.green : Colors.black,
          )),
        ],
      ),
    );
  }

  void _showOrderConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.check_circle, color: Colors.green, size: 60),
          title: Text('Order Placed!', style: TextStyle(color: Colors.green)),
          content: Text('Your order has been placed successfully. You will receive a confirmation shortly.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearCart();
                Navigator.of(context).pop(); // Go back to catalog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Continue Shopping'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
    int totalItems = widget.cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart (${totalItems} items)', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        actions: [
          if (widget.cartItems.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep, color: Colors.white),
              onPressed: _clearCart,
              tooltip: 'Clear Cart',
            ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: widget.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Your cart is empty',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Continue Shopping'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = widget.cartItems[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  cartItem.product.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[200],
                                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.product.name,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Rs ${cartItem.product.price.toStringAsFixed(2)} each',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => _updateQuantity(index, cartItem.quantity - 1),
                                          icon: Icon(Icons.remove_circle_outline),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.grey[200],
                                            padding: EdgeInsets.all(4),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          child: Text(
                                            '${cartItem.quantity}',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _updateQuantity(index, cartItem.quantity + 1),
                                          icon: Icon(Icons.add_circle_outline),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.grey[200],
                                            padding: EdgeInsets.all(4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () => _removeItem(index),
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Rs ${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal (${totalItems} items):',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rs ${total.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: widget.cartItems.isNotEmpty ? _showBill : null,
                          icon: Icon(Icons.receipt_long),
                          label: Text('Generate Bill & Checkout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}