import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/model/mainproductmodel.dart';
import 'package:application_thaweeyont/provider/Controllerprovider.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/banner_slider.dart';
import 'package:application_thaweeyont/widgets/header.dart';
import 'package:application_thaweeyont/widgets/main_menu.dart';
import 'package:application_thaweeyont/widgets/skeleton_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CateGory extends StatefulWidget {
  final id_cate;
  CateGory(this.id_cate);

  @override
  State<CateGory> createState() => _CateGoryState();
}

class _CateGoryState extends State<CateGory> {
  int offset = 0;
  bool isloading = true;
  final _scrollControll = TrackingScrollController();
  List<MainProduct> dataproduct = [];
  List<MainProduct> dataproduct_value = [];
  //function รับข้อมูลสินค้า
  Future<void> _getproduct(offset) async {
    try {
      var respose = await http.get(Uri.http(
          ipconfig_web,
          '/api_mobile/product_category_new.php',
          {"id_cate": widget.id_cate, "offset": offset.toString()}));
      print(respose.body);
      if (respose.statusCode == 200) {
        setState(() {
          dataproduct_value = mainProductFromJson(respose.body);
          dataproduct.addAll(dataproduct_value);
        });
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
    }
  }

  void myScroll() {
    _scrollControll.addListener(() async {
      double currentScroll = _scrollControll.position.pixels;

      if (_scrollControll.position.pixels ==
          _scrollControll.position.maxScrollExtent) {
        await Future.delayed(
          const Duration(seconds: 1),
          () {
            setState(() {
              offset = offset + 10;
              _getproduct(offset);
            });
          },
        );
      }
    });
  }

  st_provider() async {
    context.read<ControllerProvider>().clear_tabbar();
  }

  @override
  void initState() {
    super.initState();
    st_provider();
    myScroll();
    _getproduct(offset);
    // _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollControll,
            child: Column(
              children: [
                BannerS(),
                MainMenu(),
                SizedBox(height: 20),
                MyContant().space_box(15),
                title_product(),
                data_product(),
                if (isloading == true && dataproduct.isNotEmpty) ...[
                  load_data(),
                ]
              ],
            ),
          ),
          Header(_scrollControll, "subhead"),
        ],
      ),
    );
  }

  Container data_product() {
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      child: dataproduct.isEmpty
          ? Container(
              height: 150,
              color: isloading == true ? Colors.transparent : Colors.white,
              child: isloading == true ? load_data() : empty_product(),
            )
          : GridView.builder(
              padding: EdgeInsets.all(2),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 4,
                childAspectRatio:
                    (orientation == Orientation.portrait) ? 0.73 : 0.80,
              ),
              itemCount: dataproduct.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://www.thaweeyont.com/${dataproduct[index].imgLocation}",
                                  placeholder: (context, url) {
                                    return Container(
                                      child: SkeletonContainer.square(
                                        width: double.infinity,
                                        height: double.infinity,
                                        radins: 0,
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: SizedBox(
                                      // height: 5,
                                      width: double.infinity,
                                      child: Text(
                                        "${dataproduct[index].productName}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            "฿${dataproduct[index].optionPrice}",
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "฿${dataproduct[index].promotionPrice}",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
    );
  }
}

class empty_product extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.close,
                size: 25,
                color: Colors.grey,
              ),
              Text(
                "ไม่พบสินค้าที่ค้นหาอยู่",
                style: MyContant().normal_text(Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class load_data extends StatelessWidget {
  const load_data({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "กำลังโหลด",
      style: TextStyle(
        color: Colors.red[400],
        fontFamily: 'prompt',
        fontSize: 14,
      ),
    );
  }
}

class title_product extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.only(right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "รายการสินค้า",
                style: MyContant().bold_text(Colors.red.shade600),
              ),
            ),
          ],
        ),
      );
}
