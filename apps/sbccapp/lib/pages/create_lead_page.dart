import 'package:app_services/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sbccapp/core/design_system/design_system.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/core/shared_preference_keys.dart';
import 'package:sbccapp/shared_widgets/theme_text_field.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CreateLeadPage extends StatelessWidget {
  CreateLeadPage({super.key});

  final controller = Get.put(CreateLeadsController());

  // Define the specific blue color from the design
  final Color _primaryBlue = const Color(0xFF004a99);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: Icon(Icons.arrow_back, color: Colors.grey[800], size: 20),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "ADD LEAD",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Name field
                _buildLabelText("Name"),
                const SizedBox(height: 10),
                _buildNameField(),
                const SizedBox(height: 25),
                // Address field
                _buildLabelText("Address"),
                const SizedBox(height: 10),
                _buildAddressField(),
                const SizedBox(height: 25),
                // Company field
                _buildLabelText("Company"),
                const SizedBox(height: 10),
                _buildCompanyField(),
                const SizedBox(height: 25),
                // WhatsApp Number field
                _buildLabelText("WhatsApp Number"),
                const SizedBox(height: 10),
                _buildWhatsAppField(),
                const SizedBox(height: 25),
                // Source field
                _buildLabelText("Source"),
                const SizedBox(height: 10),
                _buildSourceField(context),
                const SizedBox(height: 25),
                // Industry field
                _buildLabelText("Industry"),
                const SizedBox(height: 10),
                _buildIndustryField(context),
                const SizedBox(height: 40),
                // ADD LEAD button
                _buildAddLeadButton(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: _primaryBlue,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: controller.nameController,
      keyboardType: TextInputType.name,
      style: TextStyle(color: Colors.grey[900], fontSize: 16),
      decoration: InputDecoration(
        filled: false,
        hintText: "Enter Name",
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Name is required';
        }
        if (value.length < 3) {
          return 'Enter a valid name';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller.addressController,
            style: TextStyle(color: Colors.grey[900], fontSize: 16),
            decoration: InputDecoration(
              filled: false,
              hintText: "Enter Address",
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
              contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _primaryBlue, width: 1.5),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.5),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _primaryBlue, width: 1.5),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Address is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 10),
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => LocationDialog(controller: controller),
            ),
            child: Text(
              "ADD +",
              style: TextStyle(
                color: _primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyField() {
    return TextFormField(
      controller: controller.componyNameController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.grey[900], fontSize: 16),
      decoration: InputDecoration(
        filled: false,
        hintText: "Enter Company Name",
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildWhatsAppField() {
    return TextFormField(
      controller: controller.whatsappController,
      keyboardType: TextInputType.phone,
      style: TextStyle(color: Colors.grey[900], fontSize: 16),
      decoration: InputDecoration(
        filled: false,
        hintText: "Enter WhatsApp Number",
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSourceField(BuildContext context) {
    return TextFormField(
      controller: controller.sourceController,
      readOnly: true,
      showCursor: false,
      onTap: () => _showSourcePicker(context),
      style: TextStyle(color: Colors.grey[900], fontSize: 16),
      decoration: InputDecoration(
        filled: false,
        hintText: "Select Source",
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
        suffixIcon: Icon(Icons.arrow_drop_down, color: _primaryBlue, size: 24),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildIndustryField(BuildContext context) {
    return TextFormField(
      controller: controller.industryController,
      readOnly: true,
      showCursor: false,
      onTap: () => _showIndustryPicker(context),
      style: TextStyle(color: Colors.grey[900], fontSize: 16),
      decoration: InputDecoration(
        filled: false,
        hintText: "Select Industry",
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
        suffixIcon: Icon(Icons.arrow_drop_down, color: _primaryBlue, size: 24),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildAddLeadButton(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isCreating.value
              ? null
              : () async {
                  String? token = await locator<InstantLocalPersistenceService>()
                      .getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
                  if (controller.formKey.currentState!.validate()) {
                    controller.createLead(token!, context);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 3,
          ),
          child: controller.isCreating.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_add, color: Colors.white, size: 24),
                    SizedBox(width: 10),
                    Text(
                      "ADD LEAD",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _showSourcePicker(BuildContext context) async {
    final selectedSource = await showDialog<String>(
      context: context,
      builder: (_) {
        return SimpleDialog(
          backgroundColor: ThemeColors.white,
          title: Text(
            'Select Source',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: ["Internet", "Website"]
              .map(
                (source) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, source),
                  child: Text(
                    source,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );

    if (selectedSource != null) {
      controller.sourceController.text = selectedSource;
    }
  }

  Future<void> _showIndustryPicker(BuildContext context) async {
    final selectedIndustry = await showDialog<String>(
      context: context,
      builder: (_) {
        return SimpleDialog(
          backgroundColor: ThemeColors.white,
          title: Text(
            'Select Industry',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: ["Hardware", "Software", "Manufacturing", "Healthcare", "Education"]
              .map(
                (industry) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, industry),
                  child: Text(
                    industry,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );

    if (selectedIndustry != null) {
      controller.industryController.text = selectedIndustry;
    }
  }
}

class CreateLeadsController extends GetxController {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final componyNameController = TextEditingController();
  final whatsappController = TextEditingController();
  final sourceController = TextEditingController();
  final industryController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final pincodeController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final formKeyDialog = GlobalKey<FormState>();

  var isCreating = false.obs;

  Future<void> createLead(String token,BuildContext context) async {
    // if (!formKey.currentState!.validate()) return;
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

    final leadData = {
      "name": nameController.text,
      "source": sourceController.text,
      "industry": industryController.text,
      "company_name": componyNameController.text,
      "address": addressController.text,
      "country": countryController.text,
      "state": stateController.text,
      "city": cityController.text,
      "area": areaController.text,
      "pincode": pincodeController.text,
      "email": emailController.text,
      "contact": numberController.text,
      "whatsapp_number": whatsappController.text,
    };
    try {
      isCreating.value = true;
      bool success = await Repository.createLead(token: token, body: leadData);
      if (success) {
        context.pop();
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    } finally {
      isCreating.value = false;
    }
  }
}

class Repository {
  static const String baseUrl = "http://erp.sbccindia.com/api/v1/leads";

  static Future<bool> createLead({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    try {
      final dio = Dio();

      dio.options.headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token", // Replace if auth is not needed
        "Content-Type": "application/json",
      };

      final response = await dio.post(baseUrl, data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Lead Created Successfully: ${response.data}");
        return true;
      } else {
        print("Error: ${response.statusCode} - ${response.data}");
        return false;
      }
    } catch (e) {
      print("Dio Exception in createLead: $e");
      return false;
    }
  }
}

class LocationDialog extends StatelessWidget {
  final CreateLeadsController controller;

  const LocationDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ThemeColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 450,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap:
                        () => context.pop(),
                    child: Icon(
                      Icons.arrow_back,
                      color: ThemeColors.themeBlue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Address Details",
                    style: ThemeFonts.text18Bold(
                      textColor: ThemeColors.themeBlue,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (controller.formKeyDialog.currentState!.validate()) {
                        context.pop();
                      }
                    },
                    child: Icon(Icons.check, color: ThemeColors.themeBlue),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: controller.formKeyDialog,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Fetch Current Address Button
                      GestureDetector(
                        onTap: () async {
                          final placemark = await context.push<Placemark?>(
                            '/mapPicker',
                          );

                          if (placemark != null) {
                            final fullAddress =
                                "${placemark.street ?? ''}, "
                                "${placemark.subLocality ?? ''}, "
                                "${placemark.locality ?? ''}, "
                                "${placemark.administrativeArea ?? ''}, "
                                "${placemark.country ?? ''}, "
                                "${placemark.postalCode ?? ''}";

                            controller.addressController.text = fullAddress;
                            controller.countryController.text =
                                placemark.country ?? '';
                            controller.stateController.text =
                                placemark.administrativeArea ?? '';
                            controller.cityController.text =
                                placemark.locality ?? '';
                            controller.areaController.text =
                                placemark.subLocality ?? '';
                            controller.pincodeController.text =
                                placemark.postalCode ?? '';
                          }
                        },
                        child: Text(
                          "Fetch Current Address",
                          style: TextStyle(
                            color: ThemeColors.themeBlue,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      /// Themed Fields
                      ThemeAddressField2(
                        controller: controller.addressController,
                      ),
                      const SizedBox(height: 10),
                      ThemeCountryField(
                        controller: controller.countryController,
                      ),
                      const SizedBox(height: 10),
                      ThemeStateField(controller: controller.stateController),
                      const SizedBox(height: 10),
                      ThemeCityField(controller: controller.cityController),
                      const SizedBox(height: 10),
                      ThemeAreaField(controller: controller.areaController),
                      const SizedBox(height: 10),
                      ThemePincodeField(
                        controller: controller.pincodeController,
                      ),
                      const SizedBox(height: 10),
                      ThemeNumberField(controller: controller.numberController),
                      const SizedBox(height: 10),
                      ThemePlainEmailField(
                        controller: controller.emailController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => MapPickerScreenState();
}

class MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? pickedLocation;
  String currentAddress = "Fetching location...";

  @override
  void initState() {
    super.initState();
    checkPermissionAndFetchLocation();
  }

  Future<void> checkPermissionAndFetchLocation() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      await getCurrentLocation();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      setState(() => currentAddress = "Location permission denied");
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        pickedLocation = LatLng(position.latitude, position.longitude);
      });

      await getAddressFromLatLng(position);
    } catch (e) {
      setState(() => currentAddress = "Error: $e");
    }
  }

  Future<void> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          currentAddress =
              "${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}";
        });
      }
    } catch (e) {
      setState(() => currentAddress = "Error: $e");
    }
  }

  void confirmLocation() async {
    if (pickedLocation == null) return;

    List<Placemark> placemarks = await placemarkFromCoordinates(
      pickedLocation!.latitude,
      pickedLocation!.longitude,
    );

    if (placemarks.isNotEmpty) {
      context.pop(placemarks.first);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.white,
      appBar: AppBar(
        backgroundColor: ThemeColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text("Pick Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: confirmLocation,
          ),
        ],
      ),
      body:
          pickedLocation == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      currentAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: pickedLocation!,
                        initialZoom: 15,
                        onPositionChanged: (pos, _) {
                          if (pos.center != null) {
                            setState(() {
                              pickedLocation = pos.center!;
                            });
                          }
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.lead.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: pickedLocation!,
                              width: 80,
                              height: 80,
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
