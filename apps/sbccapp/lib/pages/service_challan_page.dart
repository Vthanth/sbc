import 'dart:io';
import 'dart:ui' as ui;

import 'package:app_models/models.dart';
import 'package:flutter/material.dart';
import 'package:sbccapp/core/design_system/src/theme_colors.dart';
import 'package:sbccapp/core/design_system/src/theme_fonts.dart';
import 'package:sbccapp/helper/challan_multi_image_uploader_helper.dart';
import 'package:sbccapp/pages/widgets/add_item_dialog.dart';
import 'package:sbccapp/pages/widgets/image_upload_section.dart';
import 'package:sbccapp/pages/widgets/items_section.dart';
import 'package:sbccapp/shared_widgets/theme_button.dart';
import 'package:sbccapp/shared_widgets/theme_text_field.dart';

class ServiceChallanPage extends StatefulWidget {
  final String ticketUuid;
  final String? initialContactName;
  final String? initialContactNumber;
  final String? initialModelNumber;
  final String? initialSerialNumber;

  const ServiceChallanPage({super.key, required this.ticketUuid,this.initialContactName,
    this.initialContactNumber,this.initialModelNumber,
    this.initialSerialNumber,});

  @override
  State<ServiceChallanPage> createState() => _ServiceChallanPageState();
}

class _ServiceChallanPageState extends State<ServiceChallanPage> {
  // Define the specific blue color from the design (matching HTML reference)
  final Color _primaryBlue = const Color(0xFF00479b);
  
  final _serviceTypeController = TextEditingController();
  final _contactPersonNameController = TextEditingController();
  final _contactDetailController = TextEditingController();
  final _paymentTypeController = TextEditingController();
  final _paymentStatusController = TextEditingController();
  final _unitModelNumberController = TextEditingController();
  final _unitSrNoController = TextEditingController();
  final _serviceDescriptionController = TextEditingController();
  final _refrigerantController = TextEditingController();
  final _voltageController = TextEditingController();
  final _ampRController = TextEditingController();
  final _ampYController = TextEditingController();
  final _ampBController = TextEditingController();
  final _standingPressureController = TextEditingController();
  final _suctionPressureController = TextEditingController();
  final _dischargePressureController = TextEditingController();
  final _suctionTempController = TextEditingController();
  final _dischargeTempController = TextEditingController();
  final _exvOpeningController = TextEditingController();
  final _chilledWaterInController = TextEditingController();
  final _chilledWaterOutController = TextEditingController();
  final _waterTankTempController = TextEditingController();
  final _conWaterInController = TextEditingController();
  final _conWaterOutController = TextEditingController();
  final _cabinetTempController = TextEditingController();
  final _roomTempController = TextEditingController();
  final _roomSupplyAirTempController = TextEditingController();
  final _roomReturnAirTempController = TextEditingController();
  final _lpSettingController = TextEditingController();
  final _hpSettingController = TextEditingController();
  final _aftController = TextEditingController();
  final _thermostatSettingController = TextEditingController();

  ServiceChallanData? _challanData;
  String? _errorMessage;
  final List<Item> _items = [];
  final List<File> _images = [];
  bool _imagesUploaded = false;

  // Dropdown values
  String? _selectedServiceType;
  String? _selectedPaymentType;
  String? _selectedPaymentStatus;
  String? _selectedPaymentOption;

  // Dropdown options
  final List<String> _serviceTypeOptions = ['Equipment Testing', 'Commissioning', 'Service Report'];
  final List<String> _paymentTypeOptions = ['Warranty', 'AMC', 'CAMC', 'Paid'];
  final List<String> _paymentStatusOptions = ['Pending', 'Paid'];
  final List<String> _paymentOptions = ['Bill', 'Cash'];

  @override
  void initState() {
    super.initState();
    if (widget.initialContactName != null) {
      _contactPersonNameController.text = widget.initialContactName!;
    }
    if (widget.initialContactNumber != null) {
      _contactDetailController.text = widget.initialContactNumber!;
    }
    if (widget.initialModelNumber != null) {
      _unitModelNumberController.text = widget.initialModelNumber!;
    }
    if (widget.initialSerialNumber != null) {
      _unitSrNoController.text = widget.initialSerialNumber!;
    }
    _setupControllers();
  }

  void _setupControllers() {
    _contactPersonNameController.addListener(_updateChallanData);
    _unitModelNumberController.addListener(_updateChallanData);
    _unitSrNoController.addListener(_updateChallanData);
    _serviceDescriptionController.addListener(_updateChallanData);
    _refrigerantController.addListener(_updateChallanData);
    _voltageController.addListener(_updateChallanData);
    _ampRController.addListener(_updateChallanData);
    _ampYController.addListener(_updateChallanData);
    _ampBController.addListener(_updateChallanData);
    _standingPressureController.addListener(_updateChallanData);
    _suctionPressureController.addListener(_updateChallanData);
    _dischargePressureController.addListener(_updateChallanData);
    _suctionTempController.addListener(_updateChallanData);
    _dischargeTempController.addListener(_updateChallanData);
    _exvOpeningController.addListener(_updateChallanData);
    _chilledWaterInController.addListener(_updateChallanData);
    _chilledWaterOutController.addListener(_updateChallanData);
    _waterTankTempController.addListener(_updateChallanData);
    _conWaterInController.addListener(_updateChallanData);
    _conWaterOutController.addListener(_updateChallanData);
    _cabinetTempController.addListener(_updateChallanData);
    _roomTempController.addListener(_updateChallanData);
    _roomSupplyAirTempController.addListener(_updateChallanData);
    _roomReturnAirTempController.addListener(_updateChallanData);
    _lpSettingController.addListener(_updateChallanData);
    _hpSettingController.addListener(_updateChallanData);
    _aftController.addListener(_updateChallanData);
    _thermostatSettingController.addListener(_updateChallanData);
  }

  void _updateChallanData() {
    setState(() {
      _errorMessage = null;
      _challanData = ServiceChallanData(
        serviceType: _selectedServiceType?.toLowerCase().replaceAll(' ', '_'),
        contactPersonName: _contactPersonNameController.text,
        paymentType: _selectedPaymentType?.toLowerCase().replaceAll(' ', '_'),
        paymentStatus: _selectedPaymentStatus?.toLowerCase().replaceAll(' ', '_'),
        paymentMode: _selectedPaymentOption?.toLowerCase().replaceAll(' ', '_'),
        log: '',
        unitModelNumber: _unitModelNumberController.text,
        unitSrNo: _unitSrNoController.text,
        serviceDescription: _serviceDescriptionController.text,
        refrigerant: _refrigerantController.text,
        voltage: double.tryParse(_voltageController.text),
        ampR: double.tryParse(_ampRController.text),
        ampY: double.tryParse(_ampYController.text),
        ampB: double.tryParse(_ampBController.text),
        standingPressure: double.tryParse(_standingPressureController.text),
        suctionPressure: double.tryParse(_suctionPressureController.text),
        dischargePressure: double.tryParse(_dischargePressureController.text),
        suctionTemp: double.tryParse(_suctionTempController.text),
        dischargeTemp: double.tryParse(_dischargeTempController.text),
        exvOpening: double.tryParse(_exvOpeningController.text),
        chilledWaterIn: double.tryParse(_chilledWaterInController.text),
        chilledWaterOut: double.tryParse(_chilledWaterOutController.text),
        waterTankTemp: double.tryParse(_waterTankTempController.text),
        conWaterIn: double.tryParse(_conWaterInController.text),
        conWaterOut: double.tryParse(_conWaterOutController.text),
        cabinetTemp: double.tryParse(_cabinetTempController.text),
        roomTemp: double.tryParse(_roomTempController.text),
        roomSupplyAirTemp: double.tryParse(_roomSupplyAirTempController.text),
        roomReturnAirTemp: double.tryParse(_roomReturnAirTempController.text),
        lpSetting: double.tryParse(_lpSettingController.text),
        hpSetting: double.tryParse(_hpSettingController.text),
        aft: double.tryParse(_aftController.text),
        thermostatSetting: double.tryParse(_thermostatSettingController.text),
        items: _items,
      );
    });
  }

  Future<void> _showAddItemDialog() async {
    final item = await AddItemDialog.show(context);
    if (item != null) {
      setState(() => _items.add(item));
    }
  }

  bool _validateData() {
    if (_selectedServiceType == null) {
      setState(() => _errorMessage = 'Please select service type');
      return false;
    }
    if (_contactPersonNameController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter contact person name');
      return false;
    }
    if (_unitModelNumberController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter unit model number');
      return false;
    }
    if (_unitSrNoController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter unit serial number');
      return false;
    }
    return true;
  }

  Future<void> _uploadImages() async {
    await ChallanMultiImageUploaderHelper.uploadImages(
      context: context,
      images: _images,
      ticketUuid: widget.ticketUuid,
      onImagesUploaded: () {
        setState(() {
          _imagesUploaded = true;
        });
      },
    );
  }

  void _onSave() async {
    if (_validateData()) {
      if (_images.isNotEmpty) {
        await _uploadImages();
      }
      _challanData = ServiceChallanData(
        serviceType: _selectedServiceType?.toLowerCase().replaceAll(' ', '_'),
        contactPersonName: _contactPersonNameController.text,
        paymentType: _selectedPaymentType?.toLowerCase().replaceAll(' ', '_'),
        paymentStatus: _selectedPaymentStatus?.toLowerCase().replaceAll(' ', '_'),
        paymentMode: _selectedPaymentOption?.toLowerCase().replaceAll(' ', '_'),
        log: '',
        unitModelNumber: _unitModelNumberController.text,
        unitSrNo: _unitSrNoController.text,
        serviceDescription: _serviceDescriptionController.text,
        refrigerant: _refrigerantController.text,
        voltage: double.tryParse(_voltageController.text),
        ampR: double.tryParse(_ampRController.text),
        ampY: double.tryParse(_ampYController.text),
        ampB: double.tryParse(_ampBController.text),
        standingPressure: double.tryParse(_standingPressureController.text),
        suctionPressure: double.tryParse(_suctionPressureController.text),
        dischargePressure: double.tryParse(_dischargePressureController.text),
        suctionTemp: double.tryParse(_suctionTempController.text),
        dischargeTemp: double.tryParse(_dischargeTempController.text),
        exvOpening: double.tryParse(_exvOpeningController.text),
        chilledWaterIn: double.tryParse(_chilledWaterInController.text),
        chilledWaterOut: double.tryParse(_chilledWaterOutController.text),
        waterTankTemp: double.tryParse(_waterTankTempController.text),
        conWaterIn: double.tryParse(_conWaterInController.text),
        conWaterOut: double.tryParse(_conWaterOutController.text),
        cabinetTemp: double.tryParse(_cabinetTempController.text),
        roomTemp: double.tryParse(_roomTempController.text),
        roomSupplyAirTemp: double.tryParse(_roomSupplyAirTempController.text),
        roomReturnAirTemp: double.tryParse(_roomReturnAirTempController.text),
        lpSetting: double.tryParse(_lpSettingController.text),
        hpSetting: double.tryParse(_hpSettingController.text),
        aft: double.tryParse(_aftController.text),
        thermostatSetting: double.tryParse(_thermostatSettingController.text),
        items: _items,
      );
      Navigator.pop(context, _challanData);
    }
  }

  @override
  void dispose() {
    _serviceTypeController.dispose();
    _contactPersonNameController.dispose();
    _paymentTypeController.dispose();
    _paymentStatusController.dispose();
    _unitModelNumberController.dispose();
    _unitSrNoController.dispose();
    _serviceDescriptionController.dispose();
    _refrigerantController.dispose();
    _voltageController.dispose();
    _ampRController.dispose();
    _ampYController.dispose();
    _ampBController.dispose();
    _standingPressureController.dispose();
    _suctionPressureController.dispose();
    _dischargePressureController.dispose();
    _suctionTempController.dispose();
    _dischargeTempController.dispose();
    _exvOpeningController.dispose();
    _chilledWaterInController.dispose();
    _chilledWaterOutController.dispose();
    _waterTankTempController.dispose();
    _conWaterInController.dispose();
    _conWaterOutController.dispose();
    _cabinetTempController.dispose();
    _roomTempController.dispose();
    _roomSupplyAirTempController.dispose();
    _roomReturnAirTempController.dispose();
    _lpSettingController.dispose();
    _hpSettingController.dispose();
    _aftController.dispose();
    _thermostatSettingController.dispose();
    super.dispose();
  }

  void _onClose() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _ServiceChallanAppBar(onClose: _onClose),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ContactPersonSection(
                    nameController: _contactPersonNameController,
                    detailController: _contactDetailController,
                  ),
                  // Service Information Section
                  _ServiceInformationSection(
                    selectedServiceType: _selectedServiceType,
                    serviceTypeOptions: _serviceTypeOptions,
                    // contactPersonNameController: _contactPersonNameController,
                    // contactDetailController: _contactDetailController,
                    selectedPaymentType: _selectedPaymentType,
                    paymentTypeOptions: _paymentTypeOptions,
                    selectedPaymentStatus: _selectedPaymentStatus,
                    paymentStatusOptions: _paymentStatusOptions,
                    paymentOptions: _paymentOptions,
                    selectedPaymentOption: _selectedPaymentOption,
                    onServiceTypeChanged: (value) {
                      setState(() {
                        _selectedServiceType = value;
                        _updateChallanData();
                      });
                    },
                    onPaymentOptionChanged: (value) {
                      setState(() {
                        _selectedPaymentOption = value; // Update state
                        _updateChallanData(); // Refresh data model
                      });
                    },
                    onPaymentTypeChanged: (value) {
                      setState(() {
                        _selectedPaymentType = value;
                        _updateChallanData();
                      });
                    },
                    onPaymentStatusChanged: (value) {
                      setState(() {
                        _selectedPaymentStatus = value;
                        _updateChallanData();
                      });
                    },
                  ),

                  // Unit Information Section
                  _UnitInformationSection(
                    unitModelNumberController: _unitModelNumberController,
                    unitSrNoController: _unitSrNoController,
                    serviceDescriptionController: _serviceDescriptionController,
                    refrigerantController: _refrigerantController,
                  ),

                  // Electrical Measurements Section
                  _ElectricalMeasurementsSection(
                    voltageController: _voltageController,
                    ampRController: _ampRController,
                    ampYController: _ampYController,
                    ampBController: _ampBController,
                  ),

                  // Pressure & Temperature Section (Combined)
                  _PressureMeasurementsSection(
                    standingPressureController: _standingPressureController,
                    suctionPressureController: _suctionPressureController,
                    dischargePressureController: _dischargePressureController,
                    suctionTempController: _suctionTempController,
                  ),

                  // Room & Settings Section (Combined)
                  _RoomSettingsSection(
                    roomTempController: _roomTempController,
                    roomReturnAirTempController: _roomReturnAirTempController,
                    lpSettingController: _lpSettingController,
                    hpSettingController: _hpSettingController,
                  ),

                  // Spares & Media Section
                  _SparesMediaSection(
                    onAddItem: _showAddItemDialog,
                    onAddImage: () {
                      // This will be handled by ImageUploadSection widget
                    },
                  ),
                  
                  // Items Section (if items exist)
                  if (_items.isNotEmpty)
                    ItemsSection(items: _items, onAddItem: _showAddItemDialog),

                  // Images Section
                  ImageUploadSection(
                    images: _images,
                    onImagesChanged: (images) {
                      setState(() {
                        _images.clear();
                        _images.addAll(images);
                      });
                    },
                    isUploaded: _imagesUploaded,
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    _ErrorMessageView(errorMessage: _errorMessage!),
                  ],
                  const SizedBox(height: 90), // Space for fixed footer
                ],
              ),
            ),
          ),
          _SaveButtonSection(onSave: _onSave),
        ],
      ),
    );
  }
}

// Helper functions for underline text fields
Widget _buildLabelTextHelper(String text, Color primaryBlue) {
  return Text(
    text.toUpperCase(),
    style: TextStyle(
      color: primaryBlue,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );
}

Widget _buildUnderlineTextFieldHelper({
  required TextEditingController controller,
  required String hint,
  int maxLines = 1,
  required Color primaryBlue,
  TextInputType? inputType,
  bool readOnly = false,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: inputType,
    maxLines: maxLines,
    readOnly: readOnly,
    enabled: !readOnly,
    style: TextStyle(color: const Color(0xFF1a1a1a), fontSize: 15),
    decoration: InputDecoration(
      filled: false,
      hintText: hint,
      hintStyle: TextStyle(color: const Color(0xFFb0b0b0), fontSize: 15, fontWeight: FontWeight.w400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFFe0e0e0), width: 1),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFFe0e0e0), width: 1),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryBlue, width: 2),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryBlue, width: 2),
      ),
    ),
  );
}

/// Custom AppBar for service challan
class _ServiceChallanAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onClose;

  const _ServiceChallanAppBar({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: kToolbarHeight,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFf7f7f7),
            ),
            child: Icon(Icons.arrow_back, color: const Color(0xFF333333), size: 20),
          ),
          onPressed: onClose,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          'SERVICE CHALLAN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF222222),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// NEW: Contact Person Details Section
class _ContactPersonSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController? detailController;

  const _ContactPersonSection({
    required this.nameController,
    this.detailController,
  });

  @override
  Widget build(BuildContext context) {
    // Reusing your existing _primaryBlue color
    final Color primaryBlue = const Color(0xFF00479b);

    return _FormSection(
      title: 'Contact Person Details', // New Title
      icon: Icons.person, // Person Icon
      primaryBlue: primaryBlue,
      children: [
        _InputGroup(
          label: 'Contact Person Name',
          child: _buildUnderlineTextFieldHelper(
            controller: nameController,
            hint: 'Enter name',
            primaryBlue: primaryBlue,
            readOnly: true, // Keep it read-only
          ),
        ),
        if (detailController != null)
          _InputGroup(
            label: 'Contact Detail',
            child: _buildUnderlineTextFieldHelper(
              controller: detailController!,
              hint: 'Enter phone/email',
              primaryBlue: primaryBlue,
              readOnly: true, // Keep it read-only
            ),
          ),
      ],
    );
  }
}

/// Service Information Section
class _ServiceInformationSection extends StatelessWidget {
  final String? selectedServiceType;
  final List<String> serviceTypeOptions;
  // final TextEditingController contactPersonNameController;
  // final TextEditingController? contactDetailController;
  final String? selectedPaymentType;
  final List<String> paymentTypeOptions;
  final String? selectedPaymentStatus;
  final List<String> paymentStatusOptions;
  final List<String> paymentOptions;
  final ValueChanged<String?> onServiceTypeChanged;
  final ValueChanged<String?> onPaymentTypeChanged;
  final ValueChanged<String?> onPaymentStatusChanged;
  final String? selectedPaymentOption;
  final ValueChanged<String?> onPaymentOptionChanged;

  const _ServiceInformationSection({
    required this.selectedServiceType,
    required this.serviceTypeOptions,
    // required this.contactPersonNameController,
    // this.contactDetailController,
    required this.selectedPaymentType,
    required this.paymentTypeOptions,
    required this.paymentOptions,
    required this.selectedPaymentStatus,
    required this.paymentStatusOptions,
    required this.onServiceTypeChanged,
    required this.onPaymentTypeChanged,
    required this.onPaymentStatusChanged,
    required this.selectedPaymentOption,
    required this.onPaymentOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color _primaryBlue = const Color(0xFF00479b);
    return _FormSection(
      title: 'Service Information',
      icon: Icons.build,
      primaryBlue: _primaryBlue,
      children: [
        _InputGroup(
          label: 'Service Type',
          child: _CustomDropdownField<String>(
            value: selectedServiceType,
            labelText: 'Service Type',
            items: serviceTypeOptions,
            onChanged: onServiceTypeChanged,
            primaryBlue: _primaryBlue,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _InputGroup(
                label: 'Payment Type',
                child: _CustomDropdownField<String>(
                  value: selectedPaymentType,
                  labelText: 'Payment Type',
                  items: paymentTypeOptions,
                  onChanged: onPaymentTypeChanged,
                  primaryBlue: _primaryBlue,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _InputGroup(
                label: 'Status',
                child: _CustomDropdownField<String>(
                  value: selectedPaymentStatus,
                  labelText: 'Payment Status',
                  items: paymentStatusOptions,
                  onChanged: onPaymentStatusChanged,
                  primaryBlue: _primaryBlue,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _InputGroup(
                label: 'Payment Mode',
                child: _CustomDropdownField<String>(
                  value: selectedPaymentOption,
                  labelText: 'Payment Mode',
                  items: paymentOptions,
                  onChanged: onPaymentOptionChanged,
                  primaryBlue: _primaryBlue,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(child: SizedBox()),
          ],
        )
      ],
    );
  }
}

/// Unit Information Section
class _UnitInformationSection extends StatelessWidget {
  final TextEditingController unitModelNumberController;
  final TextEditingController unitSrNoController;
  final TextEditingController serviceDescriptionController;
  final TextEditingController refrigerantController;

  const _UnitInformationSection({
    required this.unitModelNumberController,
    required this.unitSrNoController,
    required this.serviceDescriptionController,
    required this.refrigerantController,
  });

  @override
  Widget build(BuildContext context) {
    final Color _primaryBlue = const Color(0xFF00479b);
    return _FormSection(
      title: 'Unit Information',
      icon: Icons.device_hub,
      primaryBlue: _primaryBlue,
      children: [
        Row(
          children: [
            Expanded(
              child: _InputGroup(
                label: 'Model Number',
                child: _buildUnderlineTextFieldHelper(
                  controller: unitModelNumberController,
                  hint: 'ACX-3000',
                  readOnly: true,
                  primaryBlue: _primaryBlue,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _InputGroup(
                label: 'Serial No.',
                child: _buildUnderlineTextFieldHelper(
                  controller: unitSrNoController,
                  hint: 'SR12345',
                  readOnly: true,
                  primaryBlue: _primaryBlue,
                ),
              ),
            ),
          ],
        ),
        _InputGroup(
          label: 'Service Description',
          child: _buildUnderlineTextFieldHelper(
            controller: serviceDescriptionController,
            hint: 'Describe issue',
            maxLines: 2,
            primaryBlue: _primaryBlue,
          ),
        ),
        _InputGroup(
          label: 'Refrigerant',
          child: _buildUnderlineTextFieldHelper(
            controller: refrigerantController,
            hint: 'e.g. R-410A',
            primaryBlue: _primaryBlue,
          ),
        ),
      ],
    );
  }
}

/// Electrical Measurements Section
class _ElectricalMeasurementsSection extends StatelessWidget {
  final TextEditingController voltageController;
  final TextEditingController ampRController;
  final TextEditingController ampYController;
  final TextEditingController ampBController;

  const _ElectricalMeasurementsSection({
    required this.voltageController,
    required this.ampRController,
    required this.ampYController,
    required this.ampBController,
  });

  @override
  Widget build(BuildContext context) {
    final Color _primaryBlue = const Color(0xFF00479b);
    return _FormSection(
      title: 'Electrical Data',
      icon: Icons.electric_bolt,
      primaryBlue: _primaryBlue,
      children: [
        Row(
          children: [
            Expanded(
              child: _InputGroup(
                label: 'Voltage',
                child: _buildUnderlineTextFieldHelper(
                  controller: voltageController,
                  hint: '230',
                  primaryBlue: _primaryBlue,
                  inputType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _InputGroup(
                label: 'Amp R',
                child: _buildUnderlineTextFieldHelper(
                  controller: ampRController,
                  hint: '5.1',
                  primaryBlue: _primaryBlue,
                  inputType: TextInputType.number,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _InputGroup(
                label: 'Amp Y',
                child: _buildUnderlineTextFieldHelper(
                  controller: ampYController,
                  hint: '5.0',
                  primaryBlue: _primaryBlue,
                  inputType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _InputGroup(
                label: 'Amp B',
                child: _buildUnderlineTextFieldHelper(
                  controller: ampBController,
                  hint: '5.2',
                  primaryBlue: _primaryBlue,
                  inputType: TextInputType.number,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Pressure Measurements Section
class _PressureMeasurementsSection extends StatelessWidget {
  final TextEditingController standingPressureController;
  final TextEditingController suctionPressureController;
  final TextEditingController dischargePressureController;
  final TextEditingController suctionTempController;

  const _PressureMeasurementsSection({
    required this.standingPressureController,
    required this.suctionPressureController,
    required this.dischargePressureController,
    required this.suctionTempController,
  });

  @override
  Widget build(BuildContext context) {
    final Color _primaryBlue = const Color(0xFF00479b);
    return _FormSection(
      title: 'Pressure & Temp',
      icon: Icons.thermostat,
      primaryBlue: _primaryBlue,
      children: [
        Row(
          children: [
            Expanded(
              child: _InputGroup(
                label: 'Standing PSI',
                child: _buildUnderlineTextFieldHelper(
                  controller: standingPressureController,
                  hint: '140',
                  primaryBlue: _primaryBlue,
                  inputType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _InputGroup(
                label: 'Suction PSI',
                child: _buildUnderlineTextFieldHelper(
                  controller: suctionPressureController,
                  hint: '60',
                  primaryBlue: _primaryBlue,
                  inputType: TextInputType.number,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _InputGroup(
                label: 'Discharge PSI',
                child: _buildUnderlineTextFieldHelper(
                  controller: dischargePressureController,
                  hint: '220',
                  primaryBlue: _primaryBlue,
                  inputType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _InputGroup(
                label: 'Suction Temp',
                child: _buildUnderlineTextFieldHelper(
                  controller: suctionTempController,
                  hint: '15°C',
                  primaryBlue: _primaryBlue,
                  inputType: TextInputType.number,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Temperature Measurements Section
class _TemperatureMeasurementsSection extends StatelessWidget {
  final TextEditingController suctionTempController;
  final TextEditingController dischargeTempController;
  final TextEditingController exvOpeningController;
  final TextEditingController waterTankTempController;

  const _TemperatureMeasurementsSection({
    required this.suctionTempController,
    required this.dischargeTempController,
    required this.exvOpeningController,
    required this.waterTankTempController,
  });

  @override
  Widget build(BuildContext context) {
    final Color _primaryBlue = const Color(0xFF004a99);
    return _FormSection(
      title: 'Temperature Measurements',
      icon: Icons.thermostat,
      primaryBlue: _primaryBlue,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelTextHelper('Suction Temp', _primaryBlue),
                  const SizedBox(height: 6),
                  _buildUnderlineTextFieldHelper(
                    controller: suctionTempController,
                    hint: 'e.g., 15',
                    primaryBlue: _primaryBlue,
                    inputType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelTextHelper('Discharge Temp', _primaryBlue),
                  const SizedBox(height: 6),
                  _buildUnderlineTextFieldHelper(
                    controller: dischargeTempController,
                    hint: 'e.g., 50',
                    primaryBlue: _primaryBlue,
                    inputType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelTextHelper('EXV Opening', _primaryBlue),
                  const SizedBox(height: 6),
                  _buildUnderlineTextFieldHelper(
                    controller: exvOpeningController,
                    hint: 'e.g., 35',
                    primaryBlue: _primaryBlue,
                    inputType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelTextHelper('Water Tank Temp', _primaryBlue),
                  const SizedBox(height: 6),
                  _buildUnderlineTextFieldHelper(
                    controller: waterTankTempController,
                    hint: 'e.g., 18',
                    primaryBlue: _primaryBlue,
                    inputType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Water Measurements Section
class _WaterMeasurementsSection extends StatelessWidget {
  final TextEditingController chilledWaterInController;
  final TextEditingController chilledWaterOutController;
  final TextEditingController conWaterInController;
  final TextEditingController conWaterOutController;

  const _WaterMeasurementsSection({
    required this.chilledWaterInController,
    required this.chilledWaterOutController,
    required this.conWaterInController,
    required this.conWaterOutController,
  });

  @override
  Widget build(BuildContext context) {
    final Color _primaryBlue = const Color(0xFF004a99);
    return _FormSection(
      title: 'Water Measurements',
      icon: Icons.water_drop,
      primaryBlue: _primaryBlue,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelTextHelper('Chilled Water In', _primaryBlue),
                  const SizedBox(height: 6),
                  _buildUnderlineTextFieldHelper(
                    controller: chilledWaterInController,
                    hint: 'e.g., 12',
                    primaryBlue: _primaryBlue,
                    inputType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelTextHelper('Chilled Water Out', _primaryBlue),
                  const SizedBox(height: 6),
                  _buildUnderlineTextFieldHelper(
                    controller: chilledWaterOutController,
                    hint: 'e.g., 8',
                    primaryBlue: _primaryBlue,
                    inputType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelTextHelper('Con Water In', _primaryBlue),
                  const SizedBox(height: 6),
                  _buildUnderlineTextFieldHelper(
                    controller: conWaterInController,
                    hint: 'e.g., 30',
                    primaryBlue: _primaryBlue,
                    inputType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelTextHelper('Con Water Out', _primaryBlue),
                  const SizedBox(height: 6),
                  _buildUnderlineTextFieldHelper(
                    controller: conWaterOutController,
                    hint: 'e.g., 36',
                    primaryBlue: _primaryBlue,
                    inputType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Room Conditions Section
class _RoomConditionsSection extends StatelessWidget {
  final TextEditingController cabinetTempController;
  final TextEditingController roomTempController;
  final TextEditingController roomSupplyAirTempController;
  final TextEditingController roomReturnAirTempController;

  const _RoomConditionsSection({
    required this.cabinetTempController,
    required this.roomTempController,
    required this.roomSupplyAirTempController,
    required this.roomReturnAirTempController,
  });

  @override
  Widget build(BuildContext context) {
    final Color _primaryBlue = const Color(0xFF004a99);
    return _FormSection(
      title: 'Room Conditions',
      icon: Icons.room,
      primaryBlue: _primaryBlue,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelTextHelper('Cabinet Temp', _primaryBlue),
                  const SizedBox(height: 6),
                  _buildUnderlineTextFieldHelper(
                    controller: cabinetTempController,
                    hint: 'e.g., 20',
                    primaryBlue: _primaryBlue,
                    inputType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelTextHelper('Room Temp', _primaryBlue),
                  const SizedBox(height: 6),
                  _buildUnderlineTextFieldHelper(
                    controller: roomTempController,
                    hint: 'e.g., 24',
                    primaryBlue: _primaryBlue,
                    inputType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelTextHelper('Room Supply Air Temp', _primaryBlue),
                  const SizedBox(height: 6),
                  _buildUnderlineTextFieldHelper(
                    controller: roomSupplyAirTempController,
                    hint: 'e.g., 22',
                    primaryBlue: _primaryBlue,
                    inputType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelTextHelper('Room Return Air Temp', _primaryBlue),
                  const SizedBox(height: 6),
                  _buildUnderlineTextFieldHelper(
                    controller: roomReturnAirTempController,
                    hint: 'e.g., 25',
                    primaryBlue: _primaryBlue,
                    inputType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Room & Settings Section (Combined)
class _RoomSettingsSection extends StatelessWidget {
  final TextEditingController roomTempController;
  final TextEditingController roomReturnAirTempController;
  final TextEditingController lpSettingController;
  final TextEditingController hpSettingController;

  const _RoomSettingsSection({
    required this.roomTempController,
    required this.roomReturnAirTempController,
    required this.lpSettingController,
    required this.hpSettingController,
  });

  @override
  Widget build(BuildContext context) {
    final Color _primaryBlue = const Color(0xFF00479b);
    return _FormSection(
      title: 'Room & Settings',
      icon: Icons.settings,
      primaryBlue: _primaryBlue,
      children: [
        Row(
          children: [
            Expanded(
              child: _InputGroup(
                label: 'Room Temp',
                child: _buildUnderlineTextFieldHelper(
                  controller: roomTempController,
                  hint: '24°C',
                  primaryBlue: _primaryBlue,
                  inputType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _InputGroup(
                label: 'Return Air',
                child: _buildUnderlineTextFieldHelper(
                  controller: roomReturnAirTempController,
                  hint: '25°C',
                  primaryBlue: _primaryBlue,
                  inputType: TextInputType.number,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _InputGroup(
                label: 'LP Setting',
                child: _buildUnderlineTextFieldHelper(
                  controller: lpSettingController,
                  hint: '65',
                  primaryBlue: _primaryBlue,
                  inputType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _InputGroup(
                label: 'HP Setting',
                child: _buildUnderlineTextFieldHelper(
                  controller: hpSettingController,
                  hint: '230',
                  primaryBlue: _primaryBlue,
                  inputType: TextInputType.number,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Error Message View
class _ErrorMessageView extends StatelessWidget {
  final String errorMessage;

  const _ErrorMessageView({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.notificationRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.notificationRed.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: ThemeColors.notificationRed, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(errorMessage, style: ThemeFonts.text14(textColor: ThemeColors.notificationRed))),
        ],
      ),
    );
  }
}

/// Save Button Section
class _SaveButtonSection extends StatelessWidget {
  final VoidCallback onSave;

  const _SaveButtonSection({required this.onSave});

  @override
  Widget build(BuildContext context) {
    final Color _primaryBlue = const Color(0xFF00479b);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00479b).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0,
              ),
              child: Text(
                "SAVE SERVICE CHALLAN",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Form Section Container
class _FormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Color primaryBlue;

  const _FormSection({
    required this.title,
    required this.icon,
    required this.children,
    required this.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFeef4fc),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: primaryBlue, size: 12),
              ),
              const SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: primaryBlue,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }
}

/// Input Group Wrapper
class _InputGroup extends StatelessWidget {
  final String label;
  final Widget child;
  final Color primaryBlue;

  const _InputGroup({
    required this.label,
    required this.child,
    this.primaryBlue = const Color(0xFF00479b),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

/// Custom Dropdown Field
class _CustomDropdownField<T> extends StatelessWidget {
  final T? value;
  final String labelText;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final Color primaryBlue;

  const _CustomDropdownField({
    required this.value,
    required this.labelText,
    required this.items,
    required this.onChanged,
    required this.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        hintText: 'Select $labelText',
        hintStyle: TextStyle(color: const Color(0xFFb0b0b0), fontSize: 15, fontWeight: FontWeight.w400),
        filled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFFe0e0e0), width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFFe0e0e0), width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            item.toString(),
            style: TextStyle(color: const Color(0xFF1a1a1a), fontSize: 15),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      style: TextStyle(color: const Color(0xFF1a1a1a), fontSize: 15),
      dropdownColor: Colors.white,
      icon: Icon(Icons.arrow_drop_down, color: primaryBlue, size: 18),
    );
  }
}

/// Spares & Media Section
class _SparesMediaSection extends StatelessWidget {
  final VoidCallback onAddItem;
  final VoidCallback onAddImage;

  const _SparesMediaSection({
    required this.onAddItem,
    required this.onAddImage,
  });

  @override
  Widget build(BuildContext context) {
    final Color _primaryBlue = const Color(0xFF00479b);
    return _FormSection(
      title: 'Spares & Media',
      icon: Icons.inventory_2,
      primaryBlue: _primaryBlue,
      children: [
        Row(
          children: [
            Expanded(
              child: _DashedButton(
                text: '+ Add Item',
                onPressed: onAddItem,
                primaryBlue: _primaryBlue,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _DashedButton(
                text: '📷 Add Image',
                onPressed: onAddImage,
                primaryBlue: _primaryBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Dashed Button
class _DashedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color primaryBlue;

  const _DashedButton({
    required this.text,
    required this.onPressed,
    required this.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFf4f8ff),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomPaint(
          painter: _DashedBorderPainter(color: primaryBlue),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dashed Border Painter
class _DashedBorderPainter extends CustomPainter {
  final Color color;

  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    // Top border
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Right border
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Bottom border
    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Left border
    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
