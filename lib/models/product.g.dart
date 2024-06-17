// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      name: json['name'] as String,
      auksiontime: json['auksiontime'] as String? ?? '',
      categoryID: json['categoryID'] as String? ?? '',
      description: json['description'] as String? ?? '',
      endprice: json['endprice'] as int? ?? 0,
      id: json['id'] as String? ?? '',
      images: json['images'] as List<dynamic>? ?? [],
      rating: json['rating'] as int? ?? 0,
      startprice: json['startprice'] as int? ?? 0,
      categoryname: json['categoryname'] as String ? ?? '',
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.images,
      'categoryID': instance.categoryID,
      'description': instance.description,
      'startprice': instance.startprice,
      'endpruce': instance.endprice,
      'rating': instance.rating,
      'auksiontime': instance.auksiontime,
    };
