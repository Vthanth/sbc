// import 'package:flutter/material.dart';
//
// class ExpenseFormPage extends StatefulWidget {
//   final bool isEdit;
//   const ExpenseFormPage({super.key, this.isEdit = false});
//
//   @override
//   State<ExpenseFormPage> createState() => _ExpenseFormPageState();
// }
//
// class _ExpenseFormPageState extends State<ExpenseFormPage> {
//   final _amountController = TextEditingController();
//   final _dateController = TextEditingController();
//   final _detailsController = TextEditingController();
//   final Color _primaryBlue = const Color(0xFF00479b);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(widget.isEdit ? 'EDIT EXPENSE' : 'ADD EXPENSE',
//             style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 children: [
//                   _FormSection(
//                     title: "Expense Details",
//                     icon: Icons.receipt_long,
//                     primaryBlue: _primaryBlue,
//                     children: [
//                       _InputGroup(
//                         label: "Amount",
//                         child: _buildUnderlineTextFieldHelper(
//                           controller: _amountController,
//                           hint: "0.00",
//                           inputType: TextInputType.number,
//                           primaryBlue: _primaryBlue,
//                         ),
//                       ),
//                       _InputGroup(
//                         label: "Date",
//                         // child: _buildUnderlineTextFieldHelper(
//                           controller: _dateController,
//                           hint: "YYYY-MM-DD",
//                           primaryBlue: _primaryBlue,
//                         ),
//                       ),
//                       _InputGroup(
//                         label: "Details / Description",
//                         child: _buildUnderlineTextFieldHelper(
//                           controller: _detailsController,
//                           hint: "What was this expense for?",
//                           maxLines: 3,
//                           primaryBlue: _primaryBlue,
//                         ),
//                       ),
//                     ],
//                   ),
//                   _FormSection(
//                     title: "Proof of Expense",
//                     icon: Icons.camera_alt,
//                     primaryBlue: _primaryBlue,
//                     children: [
//                       _DashedButton(
//                         text: "Upload Receipt Image",
//                         onPressed: () {}, // Trigger image picker
//                         primaryBlue: _primaryBlue,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           _SaveButtonSection(
//             onSave: () {
//               // Handle POST if !widget.isEdit
//               // Handle PUT if widget.isEdit
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }