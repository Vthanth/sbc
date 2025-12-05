import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sbccapp/core/design_system/design_system.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/core/shared_preference_keys.dart';
import 'package:dio/dio.dart';
import 'package:sbccapp/models/single_lead.dart';
import 'package:sbccapp/pages/widgets/custom_image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sbccapp/shared_widgets/theme_text_field.dart';

class LeadDetailPage extends StatefulWidget {
  final String leadId;
  final String name;

  const LeadDetailPage({super.key, required this.leadId, required this.name});

  @override
  State<LeadDetailPage> createState() => _LeadDetailPageState();
}

class _LeadDetailPageState extends State<LeadDetailPage> {
  final controller = Get.put(LeadDetailController());

  @override
  void initState() {
    super.initState();
    print('~~~~~~~~~~~~~~~~~~~~~~~~~~~>${widget.leadId}');
    controller.fetchLeadData(widget.leadId);
    controller.leadId = widget.leadId;
  }

  Future<void> _launchWhatsApp(String phone, {String message = "Hello"}) async {
    final Uri url = Uri.parse(
      "whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // fallback to web if app not available
      final Uri webUrl = Uri.parse(
        "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
      );
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        throw "Could not launch WhatsApp";
      }
    }
  }

  Future<void> _launchDialer(String phone) async {
    final Uri url = Uri(scheme: "tel", path: phone);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open dialer for $phone";
    }
  }

  Future<void> _launchSMS(String phone, {String message = "Hello"}) async {
    final Uri url = Uri(
      scheme: "sms",
      path: phone,
      queryParameters: {"body": message},
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not send SMS to $phone";
    }
  }

  String? leadType;
  String? leadRating;
  String? product;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ThemeColors.white,
        appBar: AppBar(
          title: Text(
            "LEAD",
            style: ThemeFonts.text20Bold(textColor: ThemeColors.white),
          ),
          backgroundColor: ThemeColors.themeBlue,
          foregroundColor: ThemeColors.white,
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: ThemeColors.themeBlue,
        //   onPressed: () {},
        //   child: const Icon(Icons.add, color: Colors.white),
        // ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lead name + Lead Status dropdown + Convert button
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Abc - duplicate',
                style: ThemeFonts.text18Bold(
                  textColor: ThemeColors.primaryBlack,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      dropdownColor: ThemeColors.white,
                      underline: const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(12),
                      isExpanded: true,
                      value: leadType,
                      hint: Text(
                        "Select Lead Type",
                        style: ThemeFonts.text12Bold(
                          textColor: ThemeColors.midGrey,
                        ),
                      ),
                      items:
                          ["Cold Call", "Option 2"]
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: ThemeFonts.text12Bold(
                                      textColor: ThemeColors.midGrey,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        setState(() {
                          leadType = val!;
                          controller.leadType = leadType;
                        });
                      },
                    ),
                  ),
                  Expanded(flex: 1, child: SizedBox(width: 30)),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.themeBlue,
                        foregroundColor: ThemeColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        List<String> imagesBase64 = controller.selectedImages.map((file) {
                          final bytes = file.readAsBytesSync();
                          return base64Encode(bytes);
                        }).toList();

                        final bearerToken =
                            await locator<InstantLocalPersistenceService>()
                                .getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);

                        final logData = {
                          "lead_uuid": widget.leadId,
                          "lead_type": controller.leadType,
                          "rating": controller.leadRating,
                          "visit_date": controller.visitDate,
                          "visit_start_time": controller.visitStartTime,
                          "visit_start_latitude": controller.visitStartLat,
                          "visit_start_longitude": controller.visitStartLng,
                          "visit_start_location_name":
                              controller.visitStartLocationName,
                          "visit_end_time": controller.visitEndTime,
                          "visit_end_latitude": controller.visitEndLat,
                          "visit_end_longitude": controller.visitEndLng,
                          "visit_end_location_name":
                              controller.visitEndLocationName,
                          "notes": controller.feedbackController.text,
                          "presented_products": controller.product,
                          "images": imagesBase64.isNotEmpty ? imagesBase64 : [null],
                        };

                        await controller.createLeadLog(logData, "$bearerToken");
                        setState(() {
                          controller.resetFormFields();
                        });
                      },
                      child: Obx(
                        () =>
                            controller.isCreatingLog.value
                                ? Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: ThemeColors.white,
                                    ),
                                  ),
                                )
                                : Text('CONVERT'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dropdowns
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lead Rating",
                          style: ThemeFonts.text12Bold(
                            textColor: ThemeColors.themeBlue,
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: ThemeColors.white,
                          underline: const SizedBox.shrink(),
                          borderRadius: BorderRadius.circular(12),
                          hint: Text(
                            "Select Rating",
                            style: ThemeFonts.text12Bold(
                              textColor: ThemeColors.midGrey,
                            ),
                          ),
                          isExpanded: true,
                          value: leadRating,
                          items:
                              ["Hot", "User A", "User B"]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: ThemeFonts.text12Bold(
                                          textColor: ThemeColors.midGrey,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            setState(() {
                              leadRating = val!;
                              controller.leadRating = leadRating;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lead Collaborators",
                          style: ThemeFonts.text12Bold(
                            textColor: ThemeColors.themeBlue,
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: ThemeColors.white,
                          underline: const SizedBox.shrink(),
                          borderRadius: BorderRadius.circular(12),
                          isExpanded: true,
                          hint: Text(
                            "Select Product",
                            style: ThemeFonts.text12Bold(
                              textColor: ThemeColors.midGrey,
                            ),
                          ),
                          value: product,
                          items:
                              ["CRM Software A", "product B", "Product C"]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: ThemeFonts.text12Bold(
                                          textColor: ThemeColors.midGrey,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            setState(() {
                              product = val;
                              controller.product = product;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Action Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                customActions(
                  icon: Icons.location_pin,
                  onTap: () {
                    final latitude =
                        controller
                            .getSingleLeadModel
                            ?.data
                            ?.visitLogs?[0]
                            .visitStartLatitude ??
                        '';
                    final longitude =
                        controller
                            .getSingleLeadModel
                            ?.data
                            ?.visitLogs?[0]
                            .visitStartLongitude ??
                        '';

                    final lat = double.tryParse(latitude);
                    final lng = double.tryParse(longitude);

                    if (lat != null && lng != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => LeadLocationPage(
                                latitude: lat,
                                longitude: lng,
                              ),
                        ),
                      );
                    }
                  },
                ),
                customActions(
                  icon: Icons.edit,
                  onTap: () {
                    final phoneNumber =
                        controller.getSingleLeadModel?.data?.contact ?? '';
                    // _launchDialer(phoneNumber);
                    showDialog(
                      context: context,
                      builder:
                          (context) => visitNoteDialog(
                            feedbackController: controller.feedbackController,
                            context: context,
                            controller: controller
                          ),
                    );
                  },
                ),
                customActions(
                  icon: Icons.call,
                  onTap: () {
                    final phoneNumber =
                        controller.getSingleLeadModel?.data?.contact ?? "";
                    if (phoneNumber.isNotEmpty) {
                      _launchDialer(phoneNumber);
                    } else {
                      Get.snackbar("Error", "Phone number not available");
                    }
                  },
                ),

                customActions(
                  icon: Icons.chat,
                  onTap: () {
                    final phoneNumber =
                        controller.getSingleLeadModel?.data?.contact ?? "";
                    if (phoneNumber.isNotEmpty) {
                      _launchSMS(
                        phoneNumber,
                        message:
                            "Hi, I’d like to follow up regarding the lead.",
                      );
                    } else {
                      Get.snackbar("Error", "Phone number not available");
                    }
                  },
                ),

                customActions(
                  isSvg: true,
                  onTap: () async {
                    final whatsappNumber =
                        controller.getSingleLeadModel?.data?.whatsappNumber ??
                        "";
                    if (whatsappNumber.isNotEmpty) {
                      try {
                        await _launchWhatsApp(
                          whatsappNumber,
                          message:
                              "Hi, I’d like to connect with you regarding the lead.",
                        );
                      } catch (e) {}
                    } else {}
                  },
                ),
              ],
            ),

            const SizedBox(height: 15),

            // TabBar
            const TabBar(
              labelColor: ThemeColors.themeBlue,
              indicatorColor: ThemeColors.themeBlue,
              indicatorWeight: 1,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: ThemeColors.opacitiesBlack60,
              tabs: [Tab(text: "ACTIVITY"), Tab(text: "DETAIL")],
            ),

            // TabBar Content
            Expanded(
              child: TabBarView(
                children: [
                  // Activity Tab
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Start Visit Row
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Obx(
                                () => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeColors.themeBlue,
                                    foregroundColor: ThemeColors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed:
                                      controller.isProcessing.value
                                          ? null
                                          : () async {
                                            if (controller.isRunning.value) {
                                              await controller.stopTimer(
                                                context,
                                              );
                                              print(controller.visitStartTime);
                                              print(controller.visitEndTime);
                                              print(controller.visitStartLat);
                                              print(controller.visitEndLng);
                                              print(controller.visitStartLng);
                                              print(controller.visitStartLat);
                                              print(
                                                controller
                                                    .visitStartLocationName,
                                              );
                                              print(
                                                controller.visitEndLocationName,
                                              );
                                              showDialog(
                                                context: context,
                                                // barrierDismissible: false,
                                                builder:
                                                    (
                                                      context,
                                                    ) => visitNoteDialog(
                                                      feedbackController:
                                                          controller
                                                              .feedbackController,
                                                      context: context,
                                                      controller: controller
                                                    ),
                                              );
                                            } else {
                                              controller.startTimer(context);
                                            }
                                          },
                                  child:
                                      controller.isProcessing.value
                                          ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : Text(
                                            controller.isRunning.value
                                                ? 'STOP VISIT'
                                                : 'START VISIT',
                                          ),
                                ),
                              ),

                              const Spacer(),
                              Obx(
                                () => Text(
                                  controller.elapsedTime.value,
                                  style: ThemeFonts.text16Bold(
                                    textColor: ThemeColors.primaryBlack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "Start the timer to do further process.",
                            style: ThemeFonts.text14(
                              textColor: ThemeColors.opacitiesBlack60,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Planned Section
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.black.withOpacity(0.08),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    "LOGS",
                                    style: ThemeFonts.text16Bold(
                                      textColor: ThemeColors.themeBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Obx(
                          () =>
                              controller.isLoading.value
                                  ? Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                  : Column(
                                    children: List.generate(
                                      controller
                                              .getSingleLeadModel
                                              ?.data
                                              ?.visitLogs
                                              ?.length ??
                                          0,
                                      (index) {
                                        String formatVisitLogTime(
                                          VisitLogs? visitLog,
                                        ) {
                                          if (visitLog == null) {
                                            return '';
                                          }
                                          DateFormat dateFormat = DateFormat(
                                            "yyyy-MM-dd",
                                          );
                                          DateTime dateTime = dateFormat.parse(
                                            visitLog.visitDate!,
                                          ); // Parse date string to DateTime
                                          DateFormat timeFormat = DateFormat(
                                            "HH:mm:ss",
                                          );
                                          DateTime time = timeFormat.parse(
                                            visitLog.visitEndTime!,
                                          ); // Parse time string to DateTime
                                          DateFormat outputFormat = DateFormat(
                                            "h:mm:ss a",
                                          ); // 12-hour time format with AM/PM
                                          String formattedTime = outputFormat
                                              .format(time);
                                          return '${DateFormat("yyyy-MM-dd").format(dateTime)} $formattedTime'; // "2023-09-27 7:19:30 PM"
                                        }

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Visit ",
                                                    style:
                                                        ThemeFonts.text14Light(),
                                                  ),
                                                  Text(
                                                    "#${controller.getSingleLeadModel?.data?.visitLogs?[index].id} ",
                                                    style:
                                                        ThemeFonts.text14Bold(),
                                                  ),
                                                  Text(
                                                    "generated. (${controller.getSingleLeadModel?.data?.visitLogs?[index].leadType} : )",
                                                    style:
                                                        ThemeFonts.text14Light(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Done by ",
                                                    style:
                                                        ThemeFonts.text14Light(
                                                          textColor: Colors
                                                              .black
                                                              .withOpacity(0.5),
                                                        ),
                                                  ),
                                                  Text(
                                                    "${controller.getSingleLeadModel?.data?.name} ",
                                                    style:
                                                        ThemeFonts.text14Bold(
                                                          textColor: Colors
                                                              .black
                                                              .withOpacity(0.5),
                                                        ),
                                                  ),
                                                  Text(
                                                    "on ${formatVisitLogTime(controller.getSingleLeadModel?.data?.visitLogs?[index])}",
                                                    style:
                                                        ThemeFonts.text14Light(
                                                          textColor: Colors
                                                              .black
                                                              .withOpacity(0.5),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(height: 25),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),

                  // Details Tab
                  Center(
                    child: Text(
                      "This is the Details tab",
                      style: ThemeFonts.text16Bold(
                        textColor: ThemeColors.primaryBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget customActions({
  IconData? icon,
  required VoidCallback onTap,
  bool? isSvg,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        shape: BoxShape.circle,
        border: Border.all(color: ThemeColors.midGrey),
      ),
      child:
          isSvg == true
              ? SvgPicture.asset(
                "assets/images/whatsapp.svg",
                color: ThemeColors.midGrey,
              )
              : Icon(icon, color: ThemeColors.midGrey),
    ),
  );
}

Widget OpenLocation({required double latitude, required double longitude}) {
  return FlutterMap(
    options: MapOptions(
      initialCenter: LatLng(latitude, longitude),
      initialZoom: 15,
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.app',
      ),
      MarkerLayer(
        markers: [
          Marker(
            point: LatLng(latitude, longitude),
            width: 80,
            height: 80,
            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
          ),
        ],
      ),
    ],
  );
}

class LeadLocationPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const LeadLocationPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<LeadLocationPage> createState() => _LeadLocationPageState();
}

class _LeadLocationPageState extends State<LeadLocationPage> {
  @override
  void initState() {
    super.initState();
    checkPermissionAndFetchLocation();
  }

  Future<void> checkPermissionAndFetchLocation() async {
    await Permission.location.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "VIEW LOCATION",
          style: ThemeFonts.text20Bold(textColor: ThemeColors.white),
        ),
        backgroundColor: ThemeColors.themeBlue,
        foregroundColor: ThemeColors.white,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(widget.latitude, widget.longitude),
          initialZoom: 15,
        ),
        children: [
          // Base map
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.lead.app',
          ),

          // Marker pin
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(widget.latitude, widget.longitude),
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget visitNoteDialog({
  required TextEditingController feedbackController,
  required BuildContext context,
  required LeadDetailController controller,
}) {
  return Dialog(
    backgroundColor: ThemeColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: StatefulBuilder(
        builder: (context, setState) {
          List<File> selectedImages = [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Visit Feedback', style: ThemeFonts.text18Bold(textColor: ThemeColors.themeBlue)),
              const SizedBox(height: 10),

              ThemeTextField(
                label: "Enter Note",
                hint: "Enter your feedback",
                controller: feedbackController,
                maxLines: 4,
              ),
              const SizedBox(height: 15),

              Center(
                child: Text("Other Details",
                    style: ThemeFonts.text18Bold(textColor: ThemeColors.themeBlue)),
              ),
              const SizedBox(height: 10),

              Text("Click Picture",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black38)),
              const SizedBox(height: 5),

              GestureDetector(
                onTap: () async {
                  final images = await customMultipleImagePicker(context);
                  if (images != null && images.isNotEmpty) {
                    setState(() {
                      controller.selectedImages = images; // store in controller
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.08)),
                  child: Row(
                    children: [
                      const Icon(Icons.image_outlined, color: Colors.black26),
                      const SizedBox(width: 10),
                      Text(
                        "Tap to attach file",
                        style: ThemeFonts.text16Light2(
                          textColor: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              // Optional: show image previews
              if (selectedImages.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedImages
                      .map((file) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(file, width: 70, height: 70, fit: BoxFit.cover),
                  ))
                      .toList(),
                ),
              ],

              const SizedBox(height: 25),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      print("Feedback: ${feedbackController.text}");
                      print("Images: ${selectedImages.map((f) => f.path).toList()}");
                      Navigator.pop(context);
                    },
                    child: Text("Submit",
                        style: ThemeFonts.text16Light(textColor: ThemeColors.themeBlue)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}

class LeadDetailController extends GetxController {
  var elapsedTime = "00:00:00".obs;
  var isRunning = false.obs;
  String? leadId;

  String? leadType;
  String? leadRating;
  String? product;

  TextEditingController visitStart = TextEditingController();
  TextEditingController visitEnd = TextEditingController();
  TextEditingController feedbackController = TextEditingController();

  List<File> selectedImages = [];

  Timer? _timer;
  int _seconds = 0;

  String? visitDate;
  String? visitStartTime;
  String? visitEndTime;

  double? visitStartLat;
  double? visitStartLng;
  double? visitEndLat;
  double? visitEndLng;

  String? visitStartLocationName;
  String? visitEndLocationName;

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  var isProcessing = false.obs;

  void startTimer(BuildContext context) async {
    if (isRunning.value || isProcessing.value) return;

    isProcessing.value = true;
    try {
      // 1️⃣ Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Permission.location.request();
      }
      // 2️⃣ Request permission
      PermissionStatus status = await Permission.location.status;
      if (status.isDenied) {
        status = await Permission.location.request();
      }
      if (status.isPermanentlyDenied) {
        // Open app settings
        _showSnackBar(context);
        openAppSettings(); // opens the device settings
        return;
      }
      // ✅ Everything OK → get location
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // Store start date/time/location in IST (UTC+5:30)
      final now = _getISTTime();
      visitDate = DateFormat("yyyy-MM-dd").format(now);
      visitStartTime = DateFormat("HH:mm:ss").format(now);
      visitStartLat = pos.latitude;
      visitStartLng = pos.longitude;
      visitStartLocationName = await getAddressFromLatLng(
        pos.latitude,
        pos.longitude,
      );
      // Start timer
      isRunning.value = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _seconds++;
        elapsedTime.value = _formatTime(_seconds);
      });
    } catch (e) {
      _showSnackBar(context);
    } finally {
      isProcessing.value = false;
    }
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please turn on the location"),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
    );
  }

  void resetFormFields() {
    leadType = null;
    leadRating = null;
    product = null;
    feedbackController.clear();
  }

  Future<void> stopTimer(BuildContext context) async {
    _timer?.cancel();
    isRunning.value = false;

    final now = DateTime.now();
    visitEndTime = DateFormat("HH:mm:ss").format(now);

    var isProcessing = false.obs;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar(context);
        return;
      }

      PermissionStatus status = await Permission.location.status;
      if (status.isDenied) {
        status = await Permission.location.request();
        if (status.isDenied) {
          _showSnackBar(context);
          return;
        }
      }

      if (status.isPermanentlyDenied) {
        _showSnackBar(context);
        openAppSettings();
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      visitEndLat = pos.latitude;
      visitEndLng = pos.longitude;
      visitEndLocationName = await getAddressFromLatLng(
        pos.latitude,
        pos.longitude,
      );
      debugPrint("End Lat: $visitEndLat, End Lng: $visitEndLng");
    } catch (e) {
      debugPrint("Location error on stop: $e");
      _showSnackBar(context);
    } finally {
      isProcessing.value = false;
    }
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return "Unknown location";

      final place = placemarks.first;

      final street = '';
      final house = '';
      final locality = place.locality ?? '';
      final admin = place.administrativeArea ?? '';
      final country = place.country ?? '';

      // Avoid duplicates and empty strings
      final parts =
          [
            house,
            street,
            locality,
            admin,
            country,
          ].where((e) => e.isNotEmpty).toList();

      return parts.join(', ');
    } catch (e) {
      debugPrint("Error getting address: $e");
      return "Unknown location";
    }
  }

  void resetData() {
    _seconds = 0;
    elapsedTime.value = "00:00:00";
    visitDate = null;
    visitStartTime = null;
    visitEndTime = null;
    visitStartLat = null;
    visitStartLng = null;
    visitEndLat = null;
    visitEndLng = null;
    visitStartLocationName = null;
    visitEndLocationName = null;

    // 🔹 Reset dropdowns and text fields
    leadType = null;
    leadRating = null;
    product = null;
    feedbackController.clear();
  }

  String _formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return "${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}";
  }

  /// Get current time in IST (Indian Standard Time, UTC+5:30)
  DateTime _getISTTime() {
    final utcNow = DateTime.now().toUtc();
    // IST is UTC+5:30 (5 hours and 30 minutes)
    return utcNow.add(const Duration(hours: 5, minutes: 30));
  }

  String _twoDigits(int n) => n.toString().padLeft(2, "0");

  GetSingleLeadModel? getSingleLeadModel;
  var isLoading = false.obs;

  Future<void> fetchLeadData(String leadId) async {
    try {
      isLoading.value = true;
      final result = await Repository.getLeadById(leadId);
      if (result != null) {
        getSingleLeadModel = result;
      }
    } catch (e) {
      Get.log("Lead load error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  List<String> convertImagesToBase64(List<File> images) {
    return images.map((file) {
      final bytes = file.readAsBytesSync();
      return base64Encode(bytes); // convert to base64 string
    }).toList();
  }

  var isCreatingLog = false.obs;

  Future<void> createLeadLog(Map<String, dynamic> logData, String token) async {
    try {
      isCreatingLog.value = true;
      final success = await Repository.createLeadLog(
        token: token,
        body: logData,
      );
      if (success) {
        fetchLeadData(leadId ?? '');
        resetFormFields();
        resetData();
      }
    } catch (e) {
      rethrow;
    } finally {
      isCreatingLog.value = false;
    }
  }
}

class Repository {
  static const String baseUrl = "http://erp.sbccindia.com/api/v1/leads";

  static Future<GetSingleLeadModel?> getLeadById(String leadId) async {
    try {
      final dio = Dio();
      final bearerToken = await locator<InstantLocalPersistenceService>()
          .getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
      dio.options.headers["Authorization"] = "Bearer $bearerToken";

      print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~abcd");
      final response = await dio.get("$baseUrl/$leadId");
      print(response);

      if (response.statusCode == 200) {
        return GetSingleLeadModel.fromJson(response.data);
      } else {
        print("Error: ${response.statusCode} - ${response.data}");
        return null;
      }
    } catch (e) {
      print("Dio Exception: $e");
      return null;
    }
  }

  static const String leadLogsUrl = "http://erp.sbccindia.com/api/v1/store-lead-log-with-images";

  static Future<bool> createLeadLog({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    try {
      final dio = Dio();

      dio.options.headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      final response = await dio.post(leadLogsUrl, data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Lead Log Created Successfully: ${response.data}");
        return true;
      } else {
        print("Error: ${response.statusCode} - ${response.data}");
        return false;
      }
    } catch (e) {
      print("Dio Exception in createLeadLog: $e");
      return false;
    }
  }
}
