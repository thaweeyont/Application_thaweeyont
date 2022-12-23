import 'dart:math';

import 'package:application_thaweeyont/Tap.dart';
import 'package:application_thaweeyont/product_home/search_product.dart';
import 'package:application_thaweeyont/provider/Controllerprovider.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Header extends StatefulWidget {
  final TrackingScrollController scrollController;
  final String? type;

  Header(this.scrollController, this.type);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  var notification;
  final border = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.transparent,
      width: 0,
    ),
    borderRadius: const BorderRadius.all(
      const Radius.circular(4.0),
    ),
  );

  Future<Null> random_noti() async {
    var rng = Random();
    for (var i = 0; i < 10; i++) {
      notification = rng.nextInt(30);
    }
  }

  _onScroll() {
    final scrolloffset = widget.scrollController.offset;
    context.read<ControllerProvider>().onScroll(scrolloffset);
  }

  @override
  void initState() {
    random_noti();

    widget.scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ControllerProvider controllerprovider, child) {
        return Container(
          color: controllerprovider.backgroundColor,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                child: Row(
                  children: [
                    if (widget.type == "subhead") ...[
                      iconback(ColorIcon: controllerprovider.ColorIcon),
                    ],
                    Expanded(
                      child: SizedBox(
                        child: TextField(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) {
                                  return SearchProduct();
                                },
                              ),
                            );
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(4),
                            isDense: true,
                            enabledBorder: border,
                            focusedBorder: border,
                            hintText: "Thaweeyont",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Icon(Icons.search),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.1,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.1,
                            ),
                            suffixIcon: Icon(Icons.camera_alt),
                            suffixIconConstraints: MyContant().sizeIcon,
                            filled: true,
                            fillColor: controllerprovider.backgroundColorSearch,
                          ),
                        ),
                      ),
                    ),
                    _buildIconButton(
                      onPressed: () async {
                        await launch("https://www.thaweeyont.com/company");
                      },
                      icon: Icons.pin_drop_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildIconButton(
          {VoidCallback? onPressed, IconData? icon, int notification = 0}) =>
      Consumer(
        builder: (context, ControllerProvider controllerprovider, child) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: onPressed,
                  child: Icon(
                    icon,
                    color: controllerprovider.ColorIcon,
                  ),
                ),
              ),
              notification == 0
                  ? SizedBox()
                  : Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.red,
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 20,
                          maxHeight: 20,
                        ),
                        child: Text(
                          '$notification',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
            ],
          );
        },
      );
}

class iconback extends StatelessWidget {
  const iconback({
    Key? key,
    required Color? ColorIcon,
  })  : _ColorIcon = ColorIcon,
        super(key: key);

  final Color? _ColorIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TapControl("0")),
        (Route<dynamic> route) => false,
      ),
      child: Icon(
        Icons.arrow_back_ios,
        color: _ColorIcon,
      ),
    );
  }
}
