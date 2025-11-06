import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:giphy_app/modules/giphy_list/data/models/giphy_response.dart';
import 'package:giphy_app/modules/giphy_list/data/repository/giphy_list_repository.dart';
import 'package:giphy_app/modules/giphy_list/data/service/giphy_api_service.dart';
import 'package:giphy_app/core/common/models/giphy_data.dart';
import 'package:giphy_app/core/common/models/giphy_images.dart';
import 'package:giphy_app/core/common/models/giphy_image_data.dart';
import 'package:giphy_app/core/common/models/meta.dart';

class MockGiphyApiService extends Mock implements GiphyApiService {}

void main() {
  late GiphyListRepository repository;
  late MockGiphyApiService mockApiService;

  setUp(() {
    mockApiService = MockGiphyApiService();
    repository = GiphyListRepository(mockApiService);
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

  GiphyResponse createMockResponse({
    required List<GiphyData> data,
    bool hasMore = false,
  }) {
    return GiphyResponse(
      data: data,
      pagination: hasMore
          ? Pagination(totalCount: 100, count: data.length, offset: 0)
          : null,
      meta: const Meta(status: 200, msg: 'OK'),
    );
  }

  group('GiphyListRepository', () {
    test(
      'searchGifs should return GiphyResponse when API call succeeds',
      () async {
        final query = 'test';
        final gifs = [
          createMockGif(id: '1', title: 'Test GIF 1'),
          createMockGif(id: '2', title: 'Test GIF 2'),
        ];
        final expectedResponse = createMockResponse(data: gifs);

        when(
          () => mockApiService.searchGifs(
            query: query,
            limit: 25,
            offset: 0,
            rating: null,
            lang: null,
            bundle: null,
          ),
        ).thenAnswer((_) async => expectedResponse);

        final result = await repository.searchGifs(query: query);

        expect(result, equals(expectedResponse));
        expect(result.data.length, equals(2));
        expect(result.data[0].id, equals('1'));
        expect(result.data[1].id, equals('2'));
        verify(
          () => mockApiService.searchGifs(
            query: query,
            limit: 25,
            offset: 0,
            rating: null,
            lang: null,
            bundle: null,
          ),
        ).called(1);
      },
    );

    test('searchGifs should pass correct parameters to API service', () async {
      final query = 'love';
      final limit = 50;
      final offset = 10;
      final rating = 'g';
      final lang = 'en';
      final bundle = 'messaging_non_clips';
      final gifs = [createMockGif(id: '1', title: 'Love GIF')];
      final expectedResponse = createMockResponse(data: gifs);

      when(
        () => mockApiService.searchGifs(
          query: query,
          limit: limit,
          offset: offset,
          rating: rating,
          lang: lang,
          bundle: bundle,
        ),
      ).thenAnswer((_) async => expectedResponse);

      final result = await repository.searchGifs(
        query: query,
        limit: limit,
        offset: offset,
        rating: rating,
        lang: lang,
        bundle: bundle,
      );

      expect(result, equals(expectedResponse));
      verify(
        () => mockApiService.searchGifs(
          query: query,
          limit: limit,
          offset: offset,
          rating: rating,
          lang: lang,
          bundle: bundle,
        ),
      ).called(1);
    });

    test('searchGifs should handle empty results', () async {
      final query = 'nonexistent';
      final expectedResponse = createMockResponse(data: []);

      when(
        () => mockApiService.searchGifs(
          query: query,
          limit: 25,
          offset: 0,
          rating: null,
          lang: null,
          bundle: null,
        ),
      ).thenAnswer((_) async => expectedResponse);

      final result = await repository.searchGifs(query: query);

      expect(result.data, isEmpty);
      verify(
        () => mockApiService.searchGifs(
          query: query,
          limit: 25,
          offset: 0,
          rating: null,
          lang: null,
          bundle: null,
        ),
      ).called(1);
    });

    test('searchGifs should propagate exceptions from API service', () async {
      final query = 'test';
      final exception = Exception('Network error');

      when(
        () => mockApiService.searchGifs(
          query: query,
          limit: 25,
          offset: 0,
          rating: null,
          lang: null,
          bundle: null,
        ),
      ).thenThrow(exception);

      expect(
        () => repository.searchGifs(query: query),
        throwsA(isA<Exception>()),
      );
      verify(
        () => mockApiService.searchGifs(
          query: query,
          limit: 25,
          offset: 0,
          rating: null,
          lang: null,
          bundle: null,
        ),
      ).called(1);
    });

    test(
      'searchGifs should use default values when optional parameters are not provided',
      () async {
        final query = 'test';
        final gifs = [createMockGif(id: '1', title: 'Test GIF')];
        final expectedResponse = createMockResponse(data: gifs);

        when(
          () => mockApiService.searchGifs(
            query: query,
            limit: 25,
            offset: 0,
            rating: null,
            lang: null,
            bundle: null,
          ),
        ).thenAnswer((_) async => expectedResponse);

        await repository.searchGifs(query: query);

        verify(
          () => mockApiService.searchGifs(
            query: query,
            limit: 25,
            offset: 0,
            rating: null,
            lang: null,
            bundle: null,
          ),
        ).called(1);
      },
    );

    test('searchGifs should handle pagination correctly', () async {
      final query = 'test';
      final gifs = [
        createMockGif(id: '1', title: 'GIF 1'),
        createMockGif(id: '2', title: 'GIF 2'),
      ];
      final expectedResponse = createMockResponse(data: gifs, hasMore: true);

      when(
        () => mockApiService.searchGifs(
          query: query,
          limit: 25,
          offset: 0,
          rating: null,
          lang: null,
          bundle: null,
        ),
      ).thenAnswer((_) async => expectedResponse);

      final result = await repository.searchGifs(query: query);

      expect(result.pagination, isNotNull);
      expect(result.pagination?.totalCount, equals(100));
      expect(result.pagination?.count, equals(2));
      expect(result.pagination?.offset, equals(0));
    });
  });
}
