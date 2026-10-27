import 'dart:convert';

import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// TODO: แก้ path ให้ตรงกับโปรเจกต์ (ตัวแปร api และหน้า Login ที่เมนูอื่นใช้อยู่)
// import 'package:application_thaweeyont/....dart';  // ที่ประกาศตัวแปร api
// import 'package:application_thaweeyont/....dart';  // class Authen

import 'stock_count_common.dart';

/// สถานะสินค้าที่ใช้กับ API ประเภท / ยี่ห้อ / รุ่น (itemStatus=1)
const String kItemStatus = '1';

/// API ค้นหา กลุ่ม/ประเภท/ยี่ห้อ/รุ่น สินค้า
/// ทุกฟังก์ชันรับคำค้น (kw) แล้วคืน List<PickItem> ให้ SearchPickerPage ใช้ต่อ
class StockItemApi {
  // setup/branchList  (ไม่มีพารามิเตอร์ — ใช้โหลดรายการสาขาใน dropdown)
  static Future<List<PickItem>> branchList(BuildContext context) {
    return _fetch(context, 'setup/branchList', {}, paging: false);
  }

  // setup/warehouseList  ← branchId
  static Future<List<PickItem>> warehouseList(
    BuildContext context,
    String kw, {
    required String branchId,
  }) {
    return _fetch(context, 'setup/warehouseList', {
      'searchName': kw,
      'branchId': branchId,
    });
  }

  // setup/itemGroupList
  static Future<List<PickItem>> groupList(BuildContext context, String kw) {
    return _fetch(context, 'setup/itemGroupList', {
      'searchName': kw,
    });
  }

  // setup/itemTypeList  ← itemGroupId
  static Future<List<PickItem>> typeList(
    BuildContext context,
    String kw, {
    required String itemGroupId,
  }) {
    return _fetch(context, 'setup/itemTypeList', {
      'searchName': kw,
      'itemGroupId': itemGroupId,
      'itemStatus': kItemStatus,
    });
  }

  // setup/itemBrandList  ← itemGroupId, itemTypeId
  static Future<List<PickItem>> brandList(
    BuildContext context,
    String kw, {
    required String itemGroupId,
    required String itemTypeId,
  }) {
    return _fetch(context, 'setup/itemBrandList', {
      'searchName': kw,
      'itemGroupId': itemGroupId,
      'itemTypeId': itemTypeId,
      'itemStatus': kItemStatus,
    });
  }

  // setup/itemModelList  ← itemGroupId, itemTypeId, itemBrandId
  static Future<List<PickItem>> modelList(
    BuildContext context,
    String kw, {
    required String itemGroupId,
    required String itemTypeId,
    required String itemBrandId,
  }) {
    return _fetch(context, 'setup/itemModelList', {
      'searchName': kw,
      'itemGroupId': itemGroupId,
      'itemTypeId': itemTypeId,
      'itemBrandId': itemBrandId,
      'itemStatus': kItemStatus,
    });
  }

  // ───────────── ตัวกลางเรียก API ─────────────
  static Future<List<PickItem>> _fetch(
    BuildContext context,
    String path,
    Map<String, String> params, {
    bool paging =
        true, // false = ไม่ส่ง searchId/page/limit (สำหรับ branchList)
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('tokenId') ?? '';

      final uri = Uri.parse('$api$path').replace(
        queryParameters: paging
            ? {
                // searchId ส่งว่างไว้ (ค้นหาด้วยชื่ออย่างเดียว) ตามรูปแบบ URL ของ API
                'searchId': '',
                ...params,
                'page': '1',
                'limit': '100',
              }
            : (params.isEmpty ? null : params),
      );

      final res = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      switch (res.statusCode) {
        case 200:
          final map = Map<String, dynamic>.from(json.decode(res.body));
          final list = (map['data'] as List?) ?? [];
          return list.map<PickItem>((e) {
            final m = Map<String, dynamic>.from(e as Map);
            // TODO: ถ้า field ของ response ไม่ใช่ id / name ให้แก้ตรงนี้
            return PickItem('${m['id']}', '${m['name']}', m);
          }).toList();

        case 400: // ไม่พบข้อมูล → แสดง "ไม่พบข้อมูล" ในหน้าค้นหา
        case 404:
          return [];

        case 401: // Token หมดอายุ → กลับหน้า Login (เหมือนเมนูอื่น)
          await prefs.clear();
          final nav = Navigator.of(context);
          nav.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const Authen()),
            (Route<dynamic> route) => false,
          );
          showAppAlert(nav.context, 'แจ้งเตือน', 'กรุณา Login เข้าสู่ระบบใหม่');
          throw SessionExpiredException();

        case 405:
          throw ApiException('ไม่พบข้อมูล (${res.statusCode})');
        case 500:
          throw ApiException('ข้อมูลผิดพลาด (${res.statusCode})');
        default:
          throw ApiException('กรุณาติดต่อผู้ดูแลระบบ');
      }
    } on ApiException {
      rethrow;
    } on SessionExpiredException {
      rethrow;
    } catch (e) {
      debugPrint('ไม่มีข้อมูล $e');
      throw ApiException('เกิดข้อผิดพลาด! กรุณาแจ้งผู้ดูแลระบบ');
    }
  }
}
