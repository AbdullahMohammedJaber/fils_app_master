import 'package:easy_localization/easy_localization.dart';
import 'package:fils/model/response/reports_response.dart';
import 'package:fils/screen/Seller/reports/wave_box.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:flutter/material.dart';

import '../../../utils/theme/color_manager.dart';
import '../../../widget/pdf_helper.dart';
import '../../general/chat_boot.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  Data? data;

  final ScrollController _scrollController = ScrollController();

  double scrollOffset = 0;
  bool loading = true;
List<Map<String , dynamic>> reportList = [];
  _fetchData() async {
    loading = true;
    final json = await NetworkHelper.sendRequest(
      requestType: RequestType.get,
      endpoint: "dashboard/dashboard-counters",
    );
    setState(() {
      loading = false;
    });
    if (json.containsKey("errorMessage")) {
    } else {
      ReportsResponse reportsResponse = ReportsResponse.fromJson(json);
      data = reportsResponse.data;
      reportList.add({'name' : "Total Orders" , "value" : data!.totalOrders , "color" : moveH});
      reportList.add({'name' : "Paid Orders" , "value" : data!.paidOrders, "color" : blueH});
      reportList.add({'name' : "Delivered Orders" , "value" : data!.deliveredOrders, "color" : orangeH});
      reportList.add({'name' : "Canceled Orders" , "value" : data!.canceledOrders ,  "color" : nahdiH });
      reportList.add({'name' : "Products" , "value" : data!.products, "color" : zaherH});
      reportList.add({'name' : "Total Sales" , "value" : data!.totalSales, "color" : kohliH});
      setState(() {

      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        scrollOffset = _scrollController.offset; // قيمة التمرير الحالية
      });
    });
    _fetchData();
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, automaticallyImplyLeading: false),
      body: Column(
        children: [
          SizedBox(height: heigth * 0.06),
          Row(
            children: [
              Expanded(child: itemBackAndTitle(context, title: "Reports".tr(), showBackIcon: true)),
              TextButton(onPressed: ()async{
                await PdfHelper.createReportPdf(reportList , getAllShop().name!);
              }, child: DefaultText("Print Report".tr())),
            ],
          ),
          SizedBox(height: heigth * 0.06),

          Expanded(
            child:
                loading
                    ? TypingIndicator(color: primaryDarkColor)
                    : Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 ,
                          crossAxisSpacing: 5 ,
                          mainAxisSpacing: 5,
                        ),

                        itemBuilder: (context, index) {
                         /* return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                reportList[index]['color'],
                                white,

                              ])
                            ),
                             child:Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 DefaultText(reportList[index]['name'].toString().tr()),
                                  SizedBox(height: 20),
                                 DefaultText(reportList[index]['value'].toString()),
                               ],
                             ) ,
                          );*/
                          return AnimatedWaveCard(

                            waveColor:   reportList[index]['color'],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DefaultText(reportList[index]['name'].toString().tr()),
                                SizedBox(height: 20),
                                DefaultText(reportList[index]['value'].toString()),
                              ],
                            ),
                          );
                        },
                        itemCount: reportList.length,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
