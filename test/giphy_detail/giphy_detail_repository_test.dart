import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:giphy_app/modules/giphy_detail/data/models/giphy_single_response.dart';
import 'package:giphy_app/modules/giphy_detail/data/repository/giphy_detail_repository.dart';
import 'package:giphy_app/modules/giphy_detail/data/service/giphy_detail_api_service.dart';
import 'package:giphy_app/core/common/models/giphy_data.dart';
import 'package:giphy_app/core/common/models/giphy_images.dart';
import 'package:giphy_app/core/common/models/giphy_image_data.dart';
import 'package:giphy_app/core/common/models/meta.dart';

class MockGiphyDetailApiService extends Mock implements GiphyDetailApiService {}

void main() {
  late GiphyDetailRepository repository;
  late MockGiphyDetailApiService mockApiService;

  setUp(() {
    mockApiService = MockGiphyDetailApiService();
    repository = GiphyDetailRepository(mockApiService);
  });

  GiphyImageData createMockImageData({
    String url = 'https://example.com/image.gif',
    String? width,
    String? height,
  }) {
    return GiphyImageData(
      url: url,
      width: width ?? '200',
      height: height ?? '200',
      size: '1000',
    );
  }

  GiphyImages createMockImages() {
    return GiphyImages(
      original: createMockImageData(),
      fixedHeight: createMockImageData(),
      downsizedLarge: createMockImageData(),
    );
  }

  GiphyData createMockGif({
    String id = '1',
    String title = 'Test GIF',
    String? rating,
  }) {
    return GiphyData(
      id: id,
      title: title,
      type: 'gif',
      rating: rating,
      images: createMockImages(),
    );
  }

  GiphySingleResponse createMockResponse({required GiphyData data}) {
    return GiphySingleResponse(
      data: data,
      meta: const Meta(status: 200, msg: 'OK'),
    );
  }

  group('GiphyDetailRepository', () {
    test(
      'getGifById should return GiphySingleResponse when API call succeeds',
      () async {
        final gifId = '123';
        final gif = createMockGif(id: gifId, title: 'Test GIF');
        final expectedResponse = createMockResponse(data: gif);

        when(
          () => mockApiService.getGifById(gifId),
        ).thenAnswer((_) async => expectedResponse);

        final result = await repository.getGifById(gifId);

        expect(result, equals(expectedResponse));
        expect(result.data.id, equals(gifId));
        expect(result.data.title, equals('Test GIF'));
        verify(() => mockApiService.getGifById(gifId)).called(1);
      },
    );

    test('getGifById should pass rating parameter to API service', () async {
      final gifId = '123';
      final rating = 'g';
      final gif = createMockGif(id: gifId, title: 'Test GIF', rating: rating);
      final expectedResponse = createMockResponse(data: gif);

      when(
        () => mockApiService.getGifById(gifId, rating: rating),
      ).thenAnswer((_) async => expectedResponse);

      final result = await repository.getGifById(gifId, rating: rating);

      expect(result, equals(expectedResponse));
      verify(() => mockApiService.getGifById(gifId, rating: rating)).called(1);
    });

    test('getGifById should not pass rating when it is null', () async {
      final gifId = '123';
      final gif = createMockGif(id: gifId, title: 'Test GIF');
      final expectedResponse = createMockResponse(data: gif);

      when(
        () => mockApiService.getGifById(gifId),
      ).thenAnswer((_) async => expectedResponse);

      final result = await repository.getGifById(gifId);

      expect(result, equals(expectedResponse));
      verify(() => mockApiService.getGifById(gifId)).called(1);
      verifyNever(
        () => mockApiService.getGifById(gifId, rating: any(named: 'rating')),
      );
    });

    test('getGifById should propagate exceptions from API service', () async {
      final gifId = '123';
      final exception = Exception('Network error');

      when(() => mockApiService.getGifById(gifId)).thenThrow(exception);

      expect(() => repository.getGifById(gifId), throwsA(isA<Exception>()));
      verify(() => mockApiService.getGifById(gifId)).called(1);
    });

    test('getGifById should handle different gif ids correctly', () async {
      final gifId1 = '123';
      final gifId2 = '456';
      final gif1 = createMockGif(id: gifId1, title: 'First GIF');
      final gif2 = createMockGif(id: gifId2, title: 'Second GIF');
      final response1 = createMockResponse(data: gif1);
      final response2 = createMockResponse(data: gif2);

      when(
        () => mockApiService.getGifById(gifId1),
      ).thenAnswer((_) async => response1);
      when(
        () => mockApiService.getGifById(gifId2),
      ).thenAnswer((_) async => response2);

      final result1 = await repository.getGifById(gifId1);
      final result2 = await repository.getGifById(gifId2);

      expect(result1.data.id, equals(gifId1));
      expect(result2.data.id, equals(gifId2));
      verify(() => mockApiService.getGifById(gifId1)).called(1);
      verify(() => mockApiService.getGifById(gifId2)).called(1);
    });

    test('getGifById should return response with meta information', () async {
      final gifId = '123';
      final gif = createMockGif(id: gifId, title: 'Test GIF');
      final expectedResponse = createMockResponse(data: gif);

      when(
        () => mockApiService.getGifById(gifId),
      ).thenAnswer((_) async => expectedResponse);

      final result = await repository.getGifById(gifId);

      expect(result.meta, isNotNull);
      expect(result.meta?.status, equals(200));
      expect(result.meta?.msg, equals('OK'));
      verify(() => mockApiService.getGifById(gifId)).called(1);
    });
  });
}
