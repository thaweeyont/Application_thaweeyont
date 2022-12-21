import 'package:application_thaweeyont/product_home/product_home.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:flutter/material.dart';

class TapControl extends StatefulWidget {
  final index;
  TapControl(this.index);

  @override
  State<TapControl> createState() => _TapControlState();
}

class _TapControlState extends State<TapControl> {
  late AnimationController _controller;

  void check_index() {
    var index_page = widget.index;
    switch (index_page) {
      case "0":
        setState(() {
          _selectedIndex = 0;
        });
        break;
      case "1":
        setState(() {
          _selectedIndex = 1;
        });
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    check_index();
    // _controller = AnimationController(vsync: this);
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );
  static List<Widget> _widgetOption = <Widget>[
    Product_home(),
    // Authen(),
  ];

  @override
  void _onItemTapped(int index) {
    if (index != 1) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Authen()),
        (Route<dynamic> route) => false,
      );
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (context) => Authen()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    double size = MediaQuery.of(context).size.width;
    double size_h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: _widgetOption.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: (orientation == Orientation.portrait)
          ? bottomNavigator(size, size_h)
          : null,
    );
  }

  Widget bottomNavigator(size, size_h) => BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 15,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Prompt',
          fontSize: size_h * 0.016,
        ),
        unselectedLabelStyle: TextStyle(fontFamily: 'Prompt'),
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: size_h * 0.014,
        unselectedFontSize: size_h * 0.014,
        selectedItemColor: Colors.red[600],
        unselectedItemColor: Colors.grey[400],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: size * 0.06,
            ),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: size * 0.06,
            ),
            label: 'โปร์ไฟล์',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      );
}
