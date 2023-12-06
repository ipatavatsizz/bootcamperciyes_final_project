import 'package:bootcamperciyes_final_project/product/constant/field_mask_constant.dart';

extension IterableFieldMaskExtensions on Iterable<FieldMask> {
  String get parameter => map((e) => e.parameter).join(',');
}
