import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/custom_appbar.dart';

class ReportSKUSaleList extends StatefulWidget {
  final dynamic itemGroupIds,
      itemTypeIds,
      idBrandlist,
      idModellist,
      idStylellist,
      idSizelist,
      idColorlist,
      selectProvinbranchlist,
      selectBranchgrouplist,
      selectAreaBranchlist,
      itemSupplyIds,
      selectMonthId1,
      selectMonthId2,
      selectMonthId3,
      selectMonthId4,
      selectYearlist1,
      selectYearlist2,
      selectYearlist3,
      selectYearlist4,
      idChkExclude;

  final String? startdate, startdatePO, enddatePO, startDatesale, endDatesale;
  const ReportSKUSaleList({
    super.key,
    this.itemGroupIds,
    this.itemTypeIds,
    this.idBrandlist,
    this.idModellist,
    this.idStylellist,
    this.idSizelist,
    this.idColorlist,
    this.selectProvinbranchlist,
    this.selectBranchgrouplist,
    this.selectAreaBranchlist,
    this.itemSupplyIds,
    this.startdate,
    this.startdatePO,
    this.enddatePO,
    this.startDatesale,
    this.endDatesale,
    this.selectMonthId1,
    this.selectMonthId2,
    this.selectMonthId3,
    this.selectMonthId4,
    this.selectYearlist1,
    this.selectYearlist2,
    this.selectYearlist3,
    this.selectYearlist4,
    this.idChkExclude,
  });

  @override
  State<ReportSKUSaleList> createState() => _ReportSKUSaleListState();
}

class _ReportSKUSaleListState extends State<ReportSKUSaleList> {
  String userId = '',
      empId = '',
      firstName = '',
      lastName = '',
      tokenId = '',
      branchId = '',
      branchAreaId = '',
      branchAreaName = '',
      appGroupId = '';

  @override
  void initState() {
    super.initState();
    getdata();
    printIncomingData();
  }

  Future<void> getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      userId = preferences.getString('userId')!;
      empId = preferences.getString('empId')!;
      firstName = preferences.getString('firstName')!;
      lastName = preferences.getString('lastName')!;
      tokenId = preferences.getString('tokenId')!;
      branchId = preferences.getString('branchId')!;
      branchAreaId = preferences.getString('branchAreaId')!;
      branchAreaName = preferences.getString('branchAreaName')!;
      appGroupId = preferences.getString('appGroupId')!;
    });
  }

  void printIncomingData() {
    print('itemGroupIds:> ${widget.itemGroupIds}');
    print('itemTypeIds:> ${widget.itemTypeIds}');
    print('idBrandlist:> ${widget.idBrandlist ?? ''}');
    print('idModellist:> ${widget.idModellist ?? ''}');
    print('idStylellist:> ${widget.idStylellist ?? ''}');
    print('idSizelist:> ${widget.idSizelist ?? ''}');
    print('idColorlist:> ${widget.idColorlist ?? ''}');
    print('selectProvinbranchlist:> ${widget.selectProvinbranchlist ?? ''}');
    print('selectBranchgrouplist:> ${widget.selectBranchgrouplist ?? ''}');
    print('selectAreaBranchlist:> ${widget.selectAreaBranchlist ?? ''}');
    print('itemSupplyIds:> ${widget.itemSupplyIds}');
    print('startdate:> ${widget.startdate ?? ''}');
    print('startdatePO:> ${widget.startdatePO ?? ''}');
    print('enddatePO:> ${widget.enddatePO ?? ''}');
    print('startDatesale:> ${widget.startDatesale ?? ''}');
    print('endDatesale:> ${widget.endDatesale ?? ''}');
    print('month1:> ${widget.selectMonthId1 ?? ''}');
    print('month2:> ${widget.selectMonthId2 ?? ''}');
    print('month3:> ${widget.selectMonthId3 ?? ''}');
    print('month4:> ${widget.selectMonthId4 ?? ''}');
    print('year1:> ${widget.selectYearlist1 ?? ''}');
    print('year2:> ${widget.selectYearlist2 ?? ''}');
    print('year3:> ${widget.selectYearlist3 ?? ''}');
    print('year4:> ${widget.selectYearlist4 ?? ''}');
    print('idChkExclude:> ${widget.idChkExclude ?? ''}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "รายงาน SKU Sale"),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text('Report SKU Sale List Screen'),
        ),
      ),
    );
  }
}
