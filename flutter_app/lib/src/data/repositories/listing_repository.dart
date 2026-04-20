import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:food_waste_exchange/src/core/providers/dio_provider.dart';
import 'package:food_waste_exchange/src/domain/entities/listing.dart';

part 'listing_repository.g.dart';

class ListingRepository {
  final Dio _dio;

  ListingRepository(this._dio);

  Future<List<Listing>> getNearby(double lat, double lng, {double radius = 20}) async {
    final response = await _dio.get('/listings/nearby', queryParameters: {
      'lat': lat,
      'lng': lng,
      'radius': radius,
    });

    final List<dynamic> data = response.data;
    return data.map((json) => Listing.fromJson(json)).toList();
  }

  Future<Listing> createListing(Map<String, dynamic> data) async {
    final response = await _dio.post('/listings', data: data);
    return Listing.fromJson(response.data);
  }

  Future<Map<String, dynamic>> analyzeSpoilage(String imageUrl, String itemType) async {
    final response = await _dio.post('/ai/predict-spoilage', data: {
      'imageUrl': imageUrl,
      'itemType': itemType,
    });
    return response.data;
  }
}

@riverpod
ListingRepository listingRepository(ListingRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return ListingRepository(dio);
}
