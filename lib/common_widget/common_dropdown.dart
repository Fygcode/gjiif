// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
//
// import '../core/res/colors.dart';
//
// class CommonDropdown<T> extends StatelessWidget {
//   final List<T> items;
//   final T? selectedItem;
//   final String? labelText;
//   final String? hintText;
//   final ValueChanged<T?>? onChanged;
//   final FormFieldValidator<T>? validator;
//   final bool isRequired;
//   final bool isSearchable;
//
//   const CommonDropdown({
//     super.key,
//     required this.items,
//     this.selectedItem,
//     this.labelText,
//     this.hintText,
//     this.onChanged,
//     this.validator,
//     this.isRequired = false,
//     this.isSearchable = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownSearch<T>(
//       key: key,
//       selectedItem: selectedItem,
//       items: (filter, infiniteScrollProps) => items,
//       popupProps:
//           isSearchable
//               ? PopupProps.menu(
//                 showSearchBox: true,
//                 searchFieldProps: TextFieldProps(
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: 12,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4.0),
//                       borderSide: const BorderSide(
//                         color: AppColor.divider,
//                         width: 1.5,
//                       ),
//                     ),
//                     hintText: 'Search...',
//                   ),
//                 ),
//               )
//               : PopupProps.menu(),
//
//       decoratorProps: DropDownDecoratorProps(
//         decoration: InputDecoration(
//           fillColor: Colors.white,
//           filled: true,
//           contentPadding: const EdgeInsets.symmetric(
//             vertical: 12,
//             horizontal: 12,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(4.0),
//             borderSide: const BorderSide(color: AppColor.divider, width: 1.5),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(4.0),
//             borderSide: const BorderSide(color: AppColor.divider, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(4.0),
//             borderSide: const BorderSide(color: AppColor.primary, width: 1),
//           ),
//           labelText: isRequired ? '${labelText ?? ''} *' : labelText,
//           hintText: hintText,
//           labelStyle: const TextStyle(color: Colors.black45, fontSize: 14),
//         ),
//       ),
//
//       onChanged: onChanged,
//       validator: validator,
//     );
//   }
// }


import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/res/colors.dart';

class CommonDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String? labelText;
  final String? hintText;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final bool isRequired;
  final bool isSearchable;


  final String Function(T)? itemAsString;
  final bool Function(T, T)? compareFn;

  const CommonDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.validator,
    this.isRequired = false,
    this.isSearchable = false,
    this.itemAsString,
    this.compareFn,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      key: key,
      selectedItem: selectedItem,
      items: (filter, _) => items,

      itemAsString: itemAsString,
      compareFn: compareFn,

      popupProps: isSearchable
          ? PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide:
              const BorderSide(color: AppColor.divider, width: 1.5),
            ),
            hintText: 'Search...',
          ),
        ),
      )
          : PopupProps.menu(),

      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(color: AppColor.divider, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(color: AppColor.divider, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(color: AppColor.primary, width: 1),
          ),
      //    labelText: isRequired ? '${labelText ?? ''} *' : labelText,
          hintText: hintText ,
          labelStyle: const TextStyle(color: Colors.black45, fontSize: 14),
        ),
      ),

      onChanged: onChanged,
      validator: validator,
    );
  }
}
