import 'package:app_services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sbccapp/core/design_system/design_system.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/core/shared_preference_keys.dart';
import 'package:sbccapp/models/leads.dart';
import 'package:dio/dio.dart';

class LeadPage extends StatelessWidget {
  const LeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LeadsController controller = Get.put(LeadsController());
    controller.fetchLeadsData();

    return Scaffold(
      backgroundColor: ThemeColors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-leads'),
        backgroundColor: ThemeColors.themeBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text(
          "Lead",
          style: ThemeFonts.text20Bold(textColor: ThemeColors.white),
        ),
        backgroundColor: ThemeColors.themeBlue,
        foregroundColor: ThemeColors.white,
        // actions: const [
        //   Icon(Icons.search),
        //   Padding(
        //     padding: EdgeInsets.only(left: 15, right: 15),
        //     child: Icon(Icons.filter_alt_outlined),
        //   ),
        // ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final leads = controller.getLeadsModel?.data ?? [];
        if (leads.isEmpty) {
          return const Center(child: Text("No Leads Available"));
        }

        return ListView.separated(
          itemCount: leads.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final lead = leads[index];
            return GestureDetector(
              onTap: () {
                String uuid=controller.getLeadsModel?.data?[index].uuid??'';
                String name=controller.getLeadsModel?.data?[index].name??'';
                print("~~~~~~~~>$uuid");
                context.push("/lead-detail/$uuid/$name");
              },
                child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.name ?? "No Name",
                      style: ThemeFonts.text20Bold(
                        textColor: ThemeColors.primaryBlack,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_pin, size: 16),
                        Text(
                          "${lead.city ?? ''}, ${lead.state ?? ''}",
                          style: ThemeFonts.text12(
                            textColor: ThemeColors.midGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class LeadsController extends GetxController {
  GetLeadsModel? getLeadsModel;
  var isLoading = false.obs;

  Future<void> fetchLeadsData() async {
    try {
      isLoading.value = true;
      final result = await Repository.getLeads();
      if (result != null) {
        getLeadsModel = result;
      }
    } catch (e) {
      Get.log("Leads load error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}

class Repository {
  static const String baseUrl = "http://erp.sbccindia.com/api/v1/leads";

  static Future<GetLeadsModel?> getLeads() async {
    try {
      final dio = Dio();
      final bearerToken = await locator<InstantLocalPersistenceService>().getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
      dio.options.headers["Authorization"] = "Bearer $bearerToken";
      print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>$bearerToken');

      final response = await dio.get(baseUrl);

      if (response.statusCode == 200) {
        return GetLeadsModel.fromJson(response.data);
      } else {
        print("Error: ${response.statusCode} - ${response.data}");
        return null;
      }
    } catch (e) {
      print("Dio Exception: $e");
      return null;
    }
  }
}
