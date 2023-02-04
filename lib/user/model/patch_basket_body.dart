import 'package:json_annotation/json_annotation.dart';

part 'patch_basket_body.g.dart';

@JsonSerializable()
class PatchBasketBody {
  final String productId;
  final int count;

  PatchBasketBody({
    required this.productId,
    required this.count,
  });

  PatchBasketBody copyWith({
    String? productId,
    int? count,
  }) {
    return PatchBasketBody(
      productId: productId ?? this.productId,
      count: count ?? this.count,
    );
  }

  factory PatchBasketBody.fromJson(Map<String, dynamic> json) =>
      _$PatchBasketBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PatchBasketBodyToJson(this);
}
