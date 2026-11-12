import 'dart:convert';

import 'package:application_thaweeyont/utility/my_constant.dart';
import 'package:application_thaweeyont/api.dart';
import 'package:application_thaweeyont/state/authen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'stock_count_common.dart';

/// stockType ของ inventorycount/itemList (ทั้งสองแท็บใช้ API และค่าเดียวกัน)
const String kStockTypeSerial = '1';

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

  // inventorycount/itemList  (POST)  ← ค้นหาสินค้าตามตัวกรอง
  static Future<List<StockItem>> itemList(
    BuildContext context, {
    required String stockType, // "1" = แท็บสแกนเลขเครื่อง
    required List<String> whId, // [] = ทุกคลัง
    String itemName = '',
    required String groupId,
    required String itemTypeId,
    required String brandId,
    required String modelId,
  }) async {
    final body = <String, dynamic>{
      'stockType': stockType,
      'whId': whId,
      'itemName': itemName,
      'groupFree': '',
      'freeItemId': '',
      'freeItemCode': '',
      'groupId': groupId,
      'itemTypeId': itemTypeId,
      'brandId': brandId,
      'modelId': modelId,
      'styleId': '',
      'sizeId': '',
      'colorId': '',
      'page': 1,
      'limit': 100,
    };
    // ดู body ที่ส่งจริงได้ใน Debug Console (คัดลอกไปทดสอบใน Postman เทียบกันได้)
    debugPrint('itemList body: ${jsonEncode(body)}');

    final map = await _call(
      context,
      (token) => http.post(
        Uri.parse('${api}inventorycount/itemList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(body),
      ),
    );
    if (map == null) return [];
    final detail = ((map['data'] as Map?)?['detail'] as List?) ?? [];
    return detail
        .map<StockItem>(
            (e) => StockItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  // ───────────── ตัวกลางเรียก API (GET รายการสำหรับหน้าค้นหา) ─────────────
  static Future<List<PickItem>> _fetch(
    BuildContext context,
    String path,
    Map<String, String> params, {
    bool paging =
        true, // false = ไม่ส่ง searchId/page/limit (สำหรับ branchList)
  }) async {
    final map = await _call(context, (token) {
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
      return http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );
    });
    if (map == null) return [];
    final list = (map['data'] as List?) ?? [];
    return list.map<PickItem>((e) {
      final m = Map<String, dynamic>.from(e as Map);
      // TODO: ถ้า field ของ response ไม่ใช่ id / name ให้แก้ตรงนี้
      return PickItem('${m['id']}', '${m['name']}', m);
    }).toList();
  }

  // ───────────── ตัวกลางจัดการสถานะ (ใช้ร่วมทุก API) ─────────────
  /// คืน response ทั้งก้อน (Map) เมื่อ 200, คืน null เมื่อไม่พบข้อมูล (400/404)
  /// 401 → ไปหน้า Login แล้ว throw SessionExpiredException
  /// อื่นๆ → throw ApiException(ข้อความ)
  static Future<Map<String, dynamic>?> _call(
    BuildContext context,
    Future<http.Response> Function(String token) send,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('tokenId') ?? '';

      final res = await send(token);

      // log สำหรับตรวจสอบ (ตัดความยาวไม่ให้ยาวเกินไป)
      debugPrint('API ${res.request?.method} ${res.request?.url} '
          '-> ${res.statusCode}');
      debugPrint(res.body.length > 400
          ? '${res.body.substring(0, 400)}...'
          : res.body);

      switch (res.statusCode) {
        case 200:
          return Map<String, dynamic>.from(json.decode(res.body));

        case 400: // ไม่พบข้อมูล
        case 404:
          return null;

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
