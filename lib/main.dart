import 'package:flutter/material.dart';
import 'settings_page.dart';

void main() {
  runApp(TipCalculatorApp());
}

class TipCalculatorApp extends StatefulWidget {
  @override
  _TipCalculatorAppState createState() => _TipCalculatorAppState();
}

class _TipCalculatorAppState extends State<TipCalculatorApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tip Calculator',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: TipCalculator(onThemeChanged: _toggleTheme),
    );
  }
}

class TipCalculator extends StatefulWidget {
  final Function(bool) onThemeChanged;
  TipCalculator({required this.onThemeChanged});

  @override
  _TipCalculatorState createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  final TextEditingController _billController = TextEditingController();
  double _tipPercentage = 0.15;
  double _billAmount = 0.0;
  double _tipAmount = 0.0;
  double _totalAmount = 0.0;
  bool _isSplit = false;

  void _calculateTip() {
    setState(() {
      _billAmount = double.tryParse(_billController.text) ?? 0.0;
      _tipAmount = _billAmount * _tipPercentage;
      _totalAmount = _billAmount + _tipAmount;

      if (_isSplit) {
        _tipAmount /= 2;
        _totalAmount /= 2;
      }
    });
  }

  void _setTipPercentage(double percentage) {
    setState(() {
      _tipPercentage = percentage;
      _calculateTip();
    });
  }

  void _toggleSplit(bool value) {
    setState(() {
      _isSplit = value;
      _calculateTip();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tip Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsPage(onThemeChanged: widget.onThemeChanged),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Bill Amount Input
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Bill Amount',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _billController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Bill Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          _calculateTip();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Split Toggle
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Split Bill Between Two People',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Switch(
                            value: _isSplit,
                            onChanged: _toggleSplit,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Tip Preset Buttons
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Tip Percentage',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => _setTipPercentage(0.10),
                            child: Text('10%'),
                          ),
                          ElevatedButton(
                            onPressed: () => _setTipPercentage(0.15),
                            child: Text('15%'),
                          ),
                          ElevatedButton(
                            onPressed: () => _setTipPercentage(0.20),
                            child: Text('20%'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Tip Slider
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adjust Tip Percentage',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 10),
                      Slider(
                        value: _tipPercentage,
                        min: 0.0,
                        max: 0.3,
                        divisions: 6,
                        label: '${(_tipPercentage * 100).toStringAsFixed(0)}%',
                        onChanged: (value) {
                          setState(() {
                            _tipPercentage = value;
                            _calculateTip();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Results Card for Tip and Total Amount
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Results (Per Person if Split)',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tip Amount:'),
                          Text(
                            '\$${_tipAmount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Amount:'),
                          Text(
                            '\$${_totalAmount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
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
