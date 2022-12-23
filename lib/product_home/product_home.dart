import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:application_thaweeyont/model/mainproductmodel.dart';
import 'package:application_thaweeyont/provider/Controllerprovider.dart';
import 'package:application_thaweeyont/provider/producthotprovider.dart';
import 'package:application_thaweeyont/provider/productprovider.dart';
import 'package:application_thaweeyont/provider/promotionprovider.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/state/state_credit/navigator_bar_credit.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/widgets/header.dart';
import 'package:application_thaweeyont/widgets/main_menu.dart';
import 'package:application_thaweeyont/widgets/skeleton_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:application_thaweeyont/widgets/banner_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Product_home extends StatefulWidget {
  const Product_home({Key? key}) : super(key: key);

  @override
  State<Product_home> createState() => _Product_homeState();
}

class _Product_homeState extends State<Product_home> {
  int offset = 0;

  //provider
  GetListData() async {
    //provider สินค้าขายดี
    context.read<ProductProvider>().myScroll(_scrollControll, offset);
    context.read<ControllerProvider>().clear_tabbar();
    await context.read<Promotion>().getpromotion();
    await context.read<ControllerProvider>().advert(context);
    await context.read<ProductProvider>().clear_product();
    await context.read<ProductProvider>().getproduct(offset);
    await context.read<ProducthotProvider>().getproduct_hot();
    getprofile_user();
  }

  Future<Null> getprofile_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getString('userId') != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigator_bar_credit('2')),
        (Route<dynamic> route) => false,
      );
    }
  }

  //เรียกใช้เมื่อมีการเปิดหน้านี้ขึ้นมา
  @override
  void initState() {
    // getprofile_user();
    GetListData();
    super.initState();
  }

  final _scrollControll = TrackingScrollController();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: MyContant.load,
      onRefresh: () async {
        await context.read<ProducthotProvider>().clear_product();
        await context.read<ProductProvider>().clear_product();
        await Future.delayed(Duration(seconds: 3));
        await context.read<ProductProvider>().getproduct(0);
        await context.read<ProducthotProvider>().getproduct_hot();
      },
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: Scaffold(
          backgroundColor: Colors.white,
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
                    title_product_hot(),
                    data_product_hot(),
                    MyContant().space_box(15),
                    title_product(),
                    data_product(),
                    title_end_page(),
                    // ButtonHome(context),
                  ],
                ),
              ),
              Header(_scrollControll, "header"),
            ],
          ),
        ),
      ),
    );
  }

  TextButton ButtonHome(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.black26),
        ),
        padding: EdgeInsets.all(8),
      ),
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Authen()),
          (Route<dynamic> route) => false,
        );
      },
      child: Text('Go Page Home'),
    );
  }
}

class data_product extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ProductProvider controllerprovider, child) {
        var items = controllerprovider.dataproduct;
        if (items.isEmpty) {
          return buildSkeleton_product();
        } else {
          return list_product(items: items);
        }
      },
    );
  }
}

class list_product extends StatelessWidget {
  const list_product({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<MainProduct> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      margin: EdgeInsets.only(top: 0),
      color: Colors.grey[200],
      child: GridView.builder(
        padding: EdgeInsets.all(2),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.73,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          var max = int.parse(items[index].optionPrice.toString());
          var min = int.parse(items[index].promotionPrice.toString());
          var value_min = max - min;
          return Stack(
            children: [
              InkWell(
                onTap: () async {
                  await launch(
                      "https://www.thaweeyont.com/detail_product?product_id=${items[index].productId}");
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ClipRect(
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://www.thaweeyont.com/${items[index].imgLocation}",
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
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "${items[index].productName}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "฿${items[index].optionPrice}",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "฿${items[index].promotionPrice}",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
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
              ),
              if (value_min > 300) ...[
                Positioned(
                  right: 0,
                  child: ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      color: Colors.yellow,
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          Text(
                            "ลด",
                            style: MyContant().small_text(Colors.white),
                          ),
                          show_per(index),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Text show_per(index) {
    var max = int.parse(items[index].optionPrice.toString());
    var min = int.parse(items[index].promotionPrice.toString());
    var val_min = max - min;
    var persen = (val_min / max) * 100;

    return Text(
      "${persen.toStringAsFixed(0)}%",
      style: MyContant().small_text(Colors.deepOrange),
    );
  }
}

class buildSkeleton_product extends StatelessWidget {
  const buildSkeleton_product({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(top: 0),
        margin: EdgeInsets.only(top: 0),
        color: Colors.white,
        child: GridView.builder(
          padding: EdgeInsets.all(2),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.73,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              color: Colors.grey[300],
              // height: 200,

              child: SkeletonContainer.square(
                width: double.infinity,
                height: 0,
                radins: 0,
              ),
            );
          },
        ),
      );
}

// class Promotion_data extends StatelessWidget {
//   Uint8List convertBase64Image(String base64String) {
//     return Base64Decoder().convert(base64String.split(',').last);
//   }

//   const Promotion_data({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(builder: (context, Promotion controllerprovider, child) {
//       var items = controllerprovider.datapromotion;
//       var item = controllerprovider.detailpromotion;
//       if (items.isEmpty) {
//         return Container();
//         // return buildSkeleton_promotion(context: context);
//       } else {
//         return Container(
//           child: GridView.builder(
//               padding: EdgeInsets.all(0),
//               scrollDirection: Axis.vertical,
//               shrinkWrap: true,
//               physics: const ClampingScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 1,
//                 childAspectRatio: 0.95,
//               ),
//               itemCount: items.length,
//               itemBuilder: ((context, index) {
//                 return Column(
//                   children: [
//                     Container(
//                       color: Colors.white,
//                       padding: EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 5),
//                                 child: Image.memory(
//                                   convertBase64Image(
//                                       items[index].ribbonPromotion.toString()),
//                                   gaplessPlayback: true,
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.4,
//                                 ),
//                               ),
//                               date_time_st(context, items[index].startPromotion,
//                                   items[index].endPromotion)
//                             ],
//                           ),
//                           Container(
//                             width: double.infinity,
//                             height: MediaQuery.of(context).size.width * 0.32,
//                             // color: Colors.grey[300],
//                             child: ClipRRect(
//                               child: CachedNetworkImage(
//                                 fit: BoxFit.fill,
//                                 imageUrl:
//                                     "https://www.thaweeyont.com/img/banner/${items[index].promotionBaner}",
//                                 placeholder: (context, url) {
//                                   return Container(
//                                     child: SkeletonContainer.square(
//                                       width: double.infinity,
//                                       height: double.infinity,
//                                       radins: 0,
//                                     ),
//                                   );
//                                 },
//                                 errorWidget: (context, url, error) =>
//                                     Icon(Icons.error),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             height: MediaQuery.of(context).size.height * 0.25,
//                             child: GridView(
//                               scrollDirection: Axis.horizontal,
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 1,
//                                 crossAxisSpacing: 5,
//                                 childAspectRatio: 1.3,
//                               ),
//                               children: [
//                                 for (var i = 0; i < item.length; i++)
//                                   if (item[i].idPromotion ==
//                                       items[index].idRunPromotion) ...[
//                                     Stack(
//                                       children: [
//                                         InkWell(
//                                           onTap: () async {
//                                             await launch(
//                                                 "https://www.thaweeyont.com/detail_product?product_id=${item[i].idProduct}");
//                                           },
//                                           child: Container(
//                                             margin: EdgeInsets.only(
//                                                 top: 8, right: 10),
//                                             color: Colors.grey[200],
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: [
//                                                 ClipRect(
//                                                   child: Stack(
//                                                     children: [
//                                                       CachedNetworkImage(
//                                                         imageUrl:
//                                                             "https://www.thaweeyont.com/${item[i].imgLocation}",
//                                                         placeholder:
//                                                             (context, url) {
//                                                           return Container(
//                                                             child:
//                                                                 SkeletonContainer
//                                                                     .square(
//                                                               width: double
//                                                                   .infinity,
//                                                               height: MediaQuery.of(
//                                                                           context)
//                                                                       .size
//                                                                       .height *
//                                                                   0.20,
//                                                               radins: 0,
//                                                             ),
//                                                           );
//                                                         },
//                                                         errorWidget: (context,
//                                                                 url, error) =>
//                                                             Icon(Icons.error),
//                                                       ),
//                                                       Positioned(
//                                                         left: 0,
//                                                         bottom: 0,
//                                                         child: ClipPath(
//                                                           // clipper: MyClipper(),
//                                                           child: Image.memory(
//                                                             convertBase64Image(
//                                                                 items[index]
//                                                                     .ribbonPromotion
//                                                                     .toString()),
//                                                             gaplessPlayback:
//                                                                 true,
//                                                             width: MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width *
//                                                                 0.2,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 // ),
//                                                 Row(
//                                                   children: [
//                                                     Expanded(
//                                                       child: SizedBox(
//                                                         // height: 5,
//                                                         width: double.infinity,
//                                                         child: Text(
//                                                           "${item[i].nameProduct}",
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets
//                                                       .symmetric(vertical: 2),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: [
//                                                       Expanded(
//                                                         child: Row(
//                                                           children: [
//                                                             ClipPath(
//                                                               clipper:
//                                                                   CuponClipper(),
//                                                               child: Container(
//                                                                 padding: EdgeInsets
//                                                                     .only(
//                                                                         left:
//                                                                             10,
//                                                                         right:
//                                                                             10),
//                                                                 color: Colors
//                                                                     .yellow,
//                                                                 child:
//                                                                     hiddent_price(
//                                                                         item,
//                                                                         i),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                       child: Container(
//                         color: Colors.grey[200],
//                       ),
//                     )
//                   ],
//                 );
//               })),
//         );
//       }
//     });
//   }

//   Row date_time_st(context, items, itemslast) {
//     // DateFormat alldate = DateFormat("yyyy-MM-dd");
//     String day = DateFormat('dd').format(items);
//     String month = DateFormat('MM').format(items);
//     String year = DateFormat('yyyy').format(items);
//     var total = int.parse(year) + 543;
//     String year_format = "$total";

//     String lastday = DateFormat('dd').format(itemslast);
//     String lastmonth = DateFormat('MM').format(itemslast);
//     String lastyear = DateFormat('yyyy').format(itemslast);
//     var lasttotal = int.parse(year) + 543;
//     String lastyear_format = "$lasttotal";
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Text(
//         //   "$day : $month : ${year_format[2]}${year_format[3]}",
//         //   style: TextStyle(fontSize: 14),
//         // ),
//         Text(
//           "$day/$month/${year_format[2]}${year_format[3]} ",
//           style: TextStyle(fontSize: 13),
//         ),
//         Text(" - "),
//         Text(
//           "$lastday/$lastmonth/${lastyear_format[2]}${lastyear_format[3]} ",
//           style: TextStyle(fontSize: 13),
//         ),
//         Icon(
//           Icons.date_range,
//           size: MediaQuery.of(context).size.width * 0.05,
//           color: Colors.red.shade400,
//         ),
//       ],
//     );
//   }

//   Text hiddent_price(item, i) {
//     var setarray = item[i].priceProdPromo;
//     var setarray_length = setarray.toString().length;
//     String totle_value;
//     switch (setarray_length) {
//       case 1:
//         {
//           totle_value = setarray;
//         }
//         break;
//       case 2:
//         {
//           totle_value = setarray;
//         }
//         break;
//       case 3:
//         {
//           totle_value = "?" + setarray[1] + setarray[2];
//         }
//         break;
//       case 4:
//         {
//           totle_value = setarray[0] + "?" + setarray[2] + setarray[3];
//         }
//         break;
//       case 5:
//         {
//           totle_value = setarray[0] + "?" + "?" + setarray[3] + setarray[4];
//         }
//         break;
//       default:
//         {
//           totle_value = setarray;
//         }
//         break;
//     }
//     return Text(
//       "฿$totle_value",
//       style: TextStyle(
//         color: Colors.red,
//         fontSize: 14,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
// }

class title_product_hot extends StatelessWidget {
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
                "สินค้าขายดี",
                style: MyContant().bold_text(Colors.red.shade600),
              ),
            ),
            InkWell(
              onTap: () async {
                await launch("https://www.thaweeyont.com/hotproduct");
                // launchUrlString("https://www.thaweeyont.com/hotproduct");
              },
              child: Row(
                children: [
                  Text(
                    "ดูเพิ่มเติม",
                    style: MyContant().small_text(Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ],
        ),
      );
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
                "สินค้าทั้งหมด",
                style: MyContant().bold_text(Colors.red.shade600),
              ),
            ),
            InkWell(
              onTap: () async {
                await launch("https://www.thaweeyont.com");
              },
              child: Row(
                children: [
                  Text(
                    "ดูเพิ่มเติม",
                    style: MyContant().small_text(Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ],
        ),
      );
}

class data_product_hot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ProducthotProvider controllerprovider, child) {
      var items = controllerprovider.dataproduct_hot;
      if (items.isEmpty) {
        return buildSkeleton_producthot(context: context);
      } else {
        return list_product_hot(items: items);
      }
    });
  }
}

class buildSkeleton_producthot extends StatelessWidget {
  const buildSkeleton_producthot({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(top: 0),
        height: MediaQuery.of(context).size.height * 0.27,
        child: GridView.builder(
          padding: EdgeInsets.only(left: 4),
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 5,
            childAspectRatio: 1.3,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.height * 0.27,
              height: MediaQuery.of(context).size.height * 0.27,
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              color: Colors.grey[200],
              child: Column(
                children: [
                  SkeletonContainer.square(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    radins: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SkeletonContainer.square(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.02,
                      radins: 15,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: SkeletonContainer.square(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.02,
                      radins: 15,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}

class list_product_hot extends StatelessWidget {
  const list_product_hot({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<MainProduct> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0),
      height: MediaQuery.of(context).size.height * 0.27,
      child: GridView.builder(
        padding: EdgeInsets.only(left: 4),
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 5,
          childAspectRatio: 1.3,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              InkWell(
                onTap: () async {
                  await launch(
                      "https://www.thaweeyont.com/detail_product?product_id=${items[index].productId}");
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            "https://www.thaweeyont.com/${items[index].imgLocation}",
                        placeholder: (context, url) {
                          return Container(
                            child: SkeletonContainer.square(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.20,
                              radins: 0,
                            ),
                          );
                        },
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                child: Text(
                                  "${items[index].productName}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
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
                                      "฿${items[index].optionPrice}",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "฿${items[index].promotionPrice}",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
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
              ),
              Positioned(
                right: 0,
                child: ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    color: Colors.yellow,
                    padding: EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Text(
                          'ลด',
                          style: MyContant().small_text(Colors.white),
                        ),
                        show_per(index),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Text show_per(index) {
    var max = int.parse(items[index].optionPrice.toString());
    var min = int.parse(items[index].promotionPrice.toString());
    var val_min = max - min;
    var persen = (val_min / max) * 100;

    return Text(
      "${persen.toStringAsFixed(0)}%",
      style: MyContant().small_text(Colors.deepOrange),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var smallLineLength = size.width / 6;
    const smallLineHeight = 6;
    var path = Path();

    path.lineTo(0, size.height);
    for (int i = 1; i <= 20; i++) {
      if (i % 2 == 0) {
        path.lineTo(smallLineLength * i, size.height);
      } else {
        path.lineTo(smallLineLength * i, size.height - smallLineHeight);
      }
    }
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) => false;
}

class CuponClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0);

    final radius = size.height * .065;

    Path holePath = Path();

    for (int i = 1; i <= 4; i++) {
      holePath.addOval(
        Rect.fromCircle(
          center: Offset(0, (size.height * .2) * i),
          radius: radius,
        ),
      );
    }
    for (int i = 1; i <= 4; i++) {
      holePath.addOval(
        Rect.fromCircle(
          center: Offset(size.width, (size.height * .2) * i),
          radius: radius,
        ),
      );
    }

    return Path.combine(PathOperation.difference, path, holePath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class title_end_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ProductProvider controllerprovider, child) {
        if (controllerprovider.isloading) {
          return load_data();
        } else {
          return end_page();
        }
      },
    );
  }
}

class load_data extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'กำลังโหลด',
            style: TextStyle(
              color: Colors.red[400],
              fontFamily: 'prompt',
              fontSize: 14,
            ),
          ),
          AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                '........',
                textStyle: TextStyle(
                  color: Colors.red[400],
                  fontFamily: 'prompt',
                  fontSize: 14,
                ),
              ),
            ],
          ),
          AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                '........',
                textStyle: TextStyle(
                  color: Colors.red[400],
                  fontFamily: 'prompt',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class end_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "สิ้นสุดหน้า",
      style: TextStyle(
        color: Colors.red[400],
        fontFamily: 'prompt',
        fontSize: 14,
      ),
    );
  }
}
