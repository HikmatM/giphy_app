import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:giphy_app/modules/giphy_list/cubit/giphy_list_cubit.dart';
import 'package:giphy_app/modules/giphy_list/cubit/giphy_list_state.dart';
import 'package:giphy_app/modules/giphy_list/data/repository/giphy_list_repository.dart';
import 'package:giphy_app/modules/giphy_list/data/models/giphy_response.dart';
import 'package:giphy_app/core/common/models/giphy_data.dart';
import 'package:giphy_app/core/common/models/giphy_images.dart';
import 'package:giphy_app/core/common/models/giphy_image_data.dart';
import 'package:giphy_app/core/common/models/meta.dart';
import 'package:giphy_app/core/api_client/exceptions/api_exception.dart';

class MockGiphyListRepository extends Mock implements BaseGiphyListRepository {}

void main() {
  late MockGiphyListRepository mockRepository;

  setUp(() {
    mockRepository = MockGiphyListRepository();
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
    int offset = 0,
  }) {
    return GiphyResponse(
      data: data,
      pagination: hasMore
          ? Pagination(totalCount: 100, count: data.length, offset: offset)
          : null,
      meta: const Meta(status: 200, msg: 'OK'),
    );
  }

  group('GiphyListCubit', () {
    test('initial state should be GiphyListInitialState', () {
      final cubit = GiphyListCubit(mockRepository);

      expect(cubit.state, isA<GiphyListInitialState>());
      cubit.close();
    });

    test(
      'searchGifs should emit loading then success state on successful search',
      () async {
        final gifs = [
          createMockGif(id: '1', title: 'Test GIF 1'),
          createMockGif(id: '2', title: 'Test GIF 2'),
        ];
        final response = createMockResponse(data: gifs);

        when(
          () => mockRepository.searchGifs(
            query: 'test',
            limit: 25,
            offset: 0,
            rating: null,
            lang: null,
            bundle: null,
          ),
        ).thenAnswer((_) async => response);

        final cubit = GiphyListCubit(mockRepository);

        final states = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<GiphyListLoadingState>(),
            isA<GiphyListSuccessState>()
                .having((s) => s.gifs.length, 'gifs.length', 2)
                .having((s) => s.gifs[0].id, 'gifs[0].id', '1')
                .having((s) => s.gifs[1].id, 'gifs[1].id', '2')
                .having((s) => s.searchQuery, 'searchQuery', 'test')
                .having((s) => s.hasMore, 'hasMore', false),
          ]),
        );

        await cubit.searchGifs('test');
        await states;
        await cubit.close();
      },
    );

    test(
      'searchGifs should emit error state when repository throws exception',
      () async {
        when(
          () => mockRepository.searchGifs(
            query: 'test',
            limit: 25,
            offset: 0,
            rating: null,
            lang: null,
            bundle: null,
          ),
        ).thenThrow(Exception('Network error'));

        final cubit = GiphyListCubit(mockRepository);

        final states = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<GiphyListLoadingState>(),
            isA<GiphyListErrorState>().having(
              (s) => s.message,
              'message',
              'Unknown exception',
            ),
          ]),
        );

        await cubit.searchGifs('test');
        await states;
        await cubit.close();
      },
    );

    test(
      'searchGifs should emit error state with ApiException message',
      () async {
        final apiException = ApiException('API Error', 'ERROR_CODE');

        when(
          () => mockRepository.searchGifs(
            query: 'test',
            limit: 25,
            offset: 0,
            rating: null,
            lang: null,
            bundle: null,
          ),
        ).thenThrow(apiException);

        final cubit = GiphyListCubit(mockRepository);

        final states = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<GiphyListLoadingState>(),
            isA<GiphyListErrorState>().having(
              (s) => s.message,
              'message',
              'API Error',
            ),
          ]),
        );

        await cubit.searchGifs('test');
        await states;
        await cubit.close();
      },
    );

    test('searchGifs should handle empty query', () async {
      final response = createMockResponse(data: []);

      when(
        () => mockRepository.searchGifs(
          query: '',
          limit: 25,
          offset: 0,
          rating: null,
          lang: null,
          bundle: null,
        ),
      ).thenAnswer((_) async => response);

      final cubit = GiphyListCubit(mockRepository);

      final states = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<GiphyListLoadingState>(),
          isA<GiphyListSuccessState>()
              .having((s) => s.gifs.length, 'gifs.length', 0)
              .having((s) => s.searchQuery, 'searchQuery', isNull),
        ]),
      );

      await cubit.searchGifs('');
      await states;
      await cubit.close();
    });

    test(
      'searchGifs should pass rating, lang, and bundle parameters',
      () async {
        final gifs = [createMockGif(id: '1', title: 'Test GIF')];
        final response = createMockResponse(data: gifs);

        when(
          () => mockRepository.searchGifs(
            query: 'test',
            limit: 25,
            offset: 0,
            rating: 'g',
            lang: 'en',
            bundle: 'messaging_non_clips',
          ),
        ).thenAnswer((_) async => response);

        final cubit = GiphyListCubit(mockRepository);

        final states = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<GiphyListLoadingState>(),
            isA<GiphyListSuccessState>()
                .having((s) => s.rating, 'rating', 'g')
                .having((s) => s.lang, 'lang', 'en')
                .having((s) => s.bundle, 'bundle', 'messaging_non_clips'),
          ]),
        );

        await cubit.searchGifs(
          'test',
          rating: 'g',
          lang: 'en',
          bundle: 'messaging_non_clips',
        );
        await states;
        await cubit.close();
      },
    );

    test(
      'searchGifs should calculate hasMore correctly when pagination exists',
      () async {
        final gifs = [
          createMockGif(id: '1', title: 'GIF 1'),
          createMockGif(id: '2', title: 'GIF 2'),
        ];
        final response = createMockResponse(data: gifs, hasMore: true);

        when(
          () => mockRepository.searchGifs(
            query: 'test',
            limit: 25,
            offset: 0,
            rating: null,
            lang: null,
            bundle: null,
          ),
        ).thenAnswer((_) async => response);

        final cubit = GiphyListCubit(mockRepository);

        final states = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<GiphyListLoadingState>(),
            isA<GiphyListSuccessState>().having(
              (s) => s.hasMore,
              'hasMore',
              true,
            ),
          ]),
        );

        await cubit.searchGifs('test');
        await states;
        await cubit.close();
      },
    );

    test(
      'searchGifs should not emit loading state when isNewSearch is false',
      () async {
        final initialGifs = [createMockGif(id: '1', title: 'GIF 1')];
        final initialResponse = createMockResponse(
          data: initialGifs,
          hasMore: true,
        );
        final moreGifs = [createMockGif(id: '2', title: 'GIF 2')];
        final moreResponse = createMockResponse(
          data: moreGifs,
          hasMore: false,
          offset: 25,
        );

        when(
          () => mockRepository.searchGifs(
            query: 'test',
            limit: 25,
            offset: 0,
            rating: null,
            lang: null,
            bundle: null,
          ),
        ).thenAnswer((_) async => initialResponse);

        when(
          () => mockRepository.searchGifs(
            query: 'test',
            limit: 25,
            offset: 1,
            rating: null,
            lang: null,
            bundle: null,
          ),
        ).thenAnswer((_) async => moreResponse);

        final cubit = GiphyListCubit(mockRepository);

        final states = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<GiphyListLoadingState>(),
            isA<GiphyListSuccessState>()
                .having((s) => s.gifs.length, 'gifs.length', 1)
                .having((s) => s.currentOffset, 'currentOffset', 1),
            isA<GiphyListSuccessState>()
                .having((s) => s.gifs.length, 'gifs.length', 2)
                .having((s) => s.currentOffset, 'currentOffset', 2),
          ]),
        );

        await cubit.searchGifs('test', isNewSearch: true);
        await cubit.searchGifs('test', isNewSearch: false);
        await states;
        await cubit.close();
      },
    );

    test(
      'loadMoreGifs should load more when hasMore is true and not loading',
      () async {
        final initialGifs = [createMockGif(id: '1', title: 'GIF 1')];
        final initialResponse = createMockResponse(
          data: initialGifs,
          hasMore: true,
        );
        final moreGifs = [createMockGif(id: '2', title: 'GIF 2')];
        final moreResponse = createMockResponse(
          data: moreGifs,
          hasMore: false,
          offset: 25,
        );

        when(
          () => mockRepository.searchGifs(
            query: 'test',
            limit: 25,
            offset: 0,
            rating: null,
            lang: null,
            bundle: null,
          ),
        ).thenAnswer((_) async => initialResponse);

        when(
          () => mockRepository.searchGifs(
            query: 'test',
            limit: 25,
            offset: 1,
            rating: null,
            lang: null,
            bundle: null,
          ),
        ).thenAnswer((_) async => moreResponse);

        final cubit = GiphyListCubit(mockRepository);

        final states = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<GiphyListLoadingState>(),
            isA<GiphyListSuccessState>()
                .having((s) => s.gifs.length, 'gifs.length', 1)
                .having((s) => s.hasMore, 'hasMore', true),
            isA<GiphyListSuccessState>()
                .having((s) => s.gifs.length, 'gifs.length', 2)
                .having((s) => s.hasMore, 'hasMore', false),
          ]),
        );

        await cubit.searchGifs('test');
        await cubit.loadMoreGifs();
        await states;
        await cubit.close();
      },
    );

    test('loadMoreGifs should not load when hasMore is false', () async {
      final gifs = [createMockGif(id: '1', title: 'GIF 1')];
      final response = createMockResponse(data: gifs, hasMore: false);

      when(
        () => mockRepository.searchGifs(
          query: 'test',
          limit: 25,
          offset: 0,
          rating: null,
          lang: null,
          bundle: null,
        ),
      ).thenAnswer((_) async => response);

      final cubit = GiphyListCubit(mockRepository);

      final states = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<GiphyListLoadingState>(),
          isA<GiphyListSuccessState>().having(
            (s) => s.hasMore,
            'hasMore',
            false,
          ),
        ]),
      );

      await cubit.searchGifs('test');
      await cubit.loadMoreGifs();
      await states;
      await cubit.close();

      verify(
        () => mockRepository.searchGifs(
          query: 'test',
          limit: 25,
          offset: 0,
          rating: null,
          lang: null,
          bundle: null,
        ),
      ).called(1);
    });

    test(
      'loadMoreGifs should preserve rating, lang, and bundle from previous search',
      () async {
        final initialGifs = [createMockGif(id: '1', title: 'GIF 1')];
        final initialResponse = createMockResponse(
          data: initialGifs,
          hasMore: true,
        );
        final moreGifs = [createMockGif(id: '2', title: 'GIF 2')];
        final moreResponse = createMockResponse(
          data: moreGifs,
          hasMore: false,
          offset: 25,
        );

        when(
          () => mockRepository.searchGifs(
            query: 'test',
            limit: 25,
            offset: 0,
            rating: 'g',
            lang: 'en',
            bundle: 'messaging_non_clips',
          ),
        ).thenAnswer((_) async => initialResponse);

        when(
          () => mockRepository.searchGifs(
            query: 'test',
            limit: 25,
            offset: 1,
            rating: 'g',
            lang: 'en',
            bundle: 'messaging_non_clips',
          ),
        ).thenAnswer((_) async => moreResponse);

        final cubit = GiphyListCubit(mockRepository);

        final states = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<GiphyListLoadingState>(),
            isA<GiphyListSuccessState>(),
            isA<GiphyListSuccessState>(),
          ]),
        );

        await cubit.searchGifs(
          'test',
          rating: 'g',
          lang: 'en',
          bundle: 'messaging_non_clips',
        );
        await cubit.loadMoreGifs();
        await states;
        await cubit.close();
      },
    );
  });
}
