import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(CurrencyExchangeApp());
}

class CurrencyExchangeApp extends StatelessWidget {
  const CurrencyExchangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Exchange',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: CurrencyExchangePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CurrencyExchangePage extends StatefulWidget {
  const CurrencyExchangePage({super.key});

  @override
  _CurrencyExchangePageState createState() => _CurrencyExchangePageState();
}

class _CurrencyExchangePageState extends State<CurrencyExchangePage>
    with TickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'IDR';
  double _result = 0.0;
  double _rate = 0.0;
  bool _isLoading = false;
  String _errorMessage = '';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, String>> _currencies = [
    {'code': 'USD', 'name': 'US Dollar', 'flag': '🇺🇸'},
    {'code': 'IDR', 'name': 'Indonesian Rupiah', 'flag': '🇮🇩'},
    {'code': 'EUR', 'name': 'Euro', 'flag': '🇪🇺'},
    {'code': 'GBP', 'name': 'British Pound', 'flag': '🇬🇧'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'flag': '🇯🇵'},
    {'code': 'SGD', 'name': 'Singapore Dollar', 'flag': '🇸🇬'},
    {'code': 'MYR', 'name': 'Malaysian Ringgit', 'flag': '🇲🇾'},
    {'code': 'THB', 'name': 'Thai Baht', 'flag': '🇹🇭'},
    {'code': 'CNY', 'name': 'Chinese Yuan', 'flag': '🇨🇳'},
    {'code': 'KRW', 'name': 'South Korean Won', 'flag': '🇰🇷'},
  ];

  @override
  void initState() {
    super.initState();
    _amountController.text = '1';
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));
    
    _animationController.forward();
    _convertCurrency();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _convertCurrency() async {
    if (_amountController.text.isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final amount = double.parse(_amountController.text);
      final url = 'https://api.frankfurter.app/latest?from=$_fromCurrency&to=$_toCurrency';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['rates'] != null && data['rates'][_toCurrency] != null) {
          final rate = data['rates'][_toCurrency].toDouble();
          setState(() {
            _rate = rate;
            _result = amount * rate;
          });
        } else {
          setState(() {
            _errorMessage = 'Currency not supported';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Network error occurred';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid amount or network error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    _convertCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F23),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Currency Exchange',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Real-time exchange rates',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white54,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildExchangeCard(),
                  ),
                ),
                SizedBox(height: 24),
                if (_result > 0 && !_isLoading)
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildResultCard(),
                    ),
                  ),
                if (_errorMessage.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red[300]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                
                SizedBox(height: 40),
                
                // API Documentation
                _buildApiDocumentation(),
                
                SizedBox(height: 24),
                
                // Developer Credit
                _buildDeveloperCredit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildExchangeCard() {
  return Container(
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: Colors.white.withOpacity(0.1),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        // Amount Input
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: TextField(
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              labelText: 'Amount',
              labelStyle: TextStyle(color: Colors.white60),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(20),
              prefixIcon: Icon(Icons.attach_money, color: Colors.white60),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                _convertCurrency();
              }
            },
          ),
        ),
        
        SizedBox(height: 24),
        
        // Currency Selection
        Row(
          children: [
            Expanded(child: _buildCurrencyDropdown(_fromCurrency, true)),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: _swapCurrencies,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4F46E5).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.swap_horiz,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            Expanded(child: _buildCurrencyDropdown(_toCurrency, false)),
          ],
        ),
        
        // Tombol Convert sudah dihapus
        // Konversi akan terjadi otomatis saat user mengetik atau mengubah currency
      ],
    ),
  );
}
Widget _buildCurrencyDropdown(String selectedCurrency, bool isFrom) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.15)),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedCurrency,
        dropdownColor: Color(0xFF1A1A2E),
        style: TextStyle(color: Colors.white),
        icon: Icon(Icons.arrow_drop_down, color: Colors.white60, size: 20),
        isExpanded: true, // This is crucial to prevent overflow
        items: _currencies.map((currency) {
          return DropdownMenuItem<String>(
            value: currency['code'],
            child: Container(
              constraints: BoxConstraints(maxWidth: 200), // Prevent overflow in dropdown items
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currency['flag']!,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 6),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currency['code']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          currency['name']!,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        // Custom selected item display to fit in narrow space
        selectedItemBuilder: (BuildContext context) {
          return _currencies.map<Widget>((currency) {
            return Container(
              alignment: Alignment.centerLeft,
              constraints: BoxConstraints(maxWidth: 120), // Constrain width
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currency['flag']!,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      currency['code']!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        },
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              if (isFrom) {
                _fromCurrency = newValue;
              } else {
                _toCurrency = newValue;
              }
            });
            _convertCurrency();
          }
        },
      ),
    ),
  );
}

  Widget _buildResultCard() {
    final fromCurrency = _currencies.firstWhere((c) => c['code'] == _fromCurrency);
    final toCurrency = _currencies.firstWhere((c) => c['code'] == _toCurrency);
    
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4F46E5).withOpacity(0.2),
            Color(0xFF7C3AED).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Color(0xFF4F46E5).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4F46E5).withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          fromCurrency['flag']!,
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${_amountController.text} $_fromCurrency',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.trending_up,
                color: Color(0xFF10B981),
                size: 24,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          toCurrency['flag']!,
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${_formatNumber(_result)} $_toCurrency',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.white60,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  '1 $_fromCurrency = ${_formatNumber(_rate)} $_toCurrency',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else if (number < 1 && number > 0) {
      return number.toStringAsFixed(6);
    } else {
      return number.toStringAsFixed(2);
    }
  }

  Widget _buildApiDocumentation() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.api, color: Colors.blue[300], size: 20),
              SizedBox(width: 8),
              Text(
                'API Documentation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Powered by Frankfurter API',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Endpoint:',
                  style: TextStyle(color: Colors.green[300], fontSize: 12),
                ),
                Text(
                  'https://api.frankfurter.app/latest?from=USD&to=IDR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Response:',
                  style: TextStyle(color: Colors.green[300], fontSize: 12),
                ),
                Text(
                  '{"amount": 1.0, "base": "USD", "date": "2024-01-15", "rates": {"IDR": 15425.123}}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[400], size: 16),
              SizedBox(width: 6),
              Text(
                'Free • No API Key Required • ECB Data',
                style: TextStyle(
                  color: Colors.green[400],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCredit() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.code, color: Colors.purple[300], size: 18),
          SizedBox(width: 8),
          Text(
            'Developed by ',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final url = Uri.parse('https://github.com/Ian7672');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            child: Text(
              'github.com/Ian7672',
              style: TextStyle(
                color: Colors.purple[300],
                fontSize: 13,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
