import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:giphy_app/modules/giphy_detail/cubit/giphy_detail_cubit.dart';
import 'package:giphy_app/modules/giphy_detail/cubit/giphy_detail_state.dart';
import 'package:giphy_app/modules/giphy_detail/data/repository/giphy_detail_repository.dart';
import 'package:giphy_app/modules/giphy_detail/data/models/giphy_single_response.dart';
import 'package:giphy_app/core/common/models/giphy_data.dart';
import 'package:giphy_app/core/common/models/giphy_images.dart';
import 'package:giphy_app/core/common/models/giphy_image_data.dart';
import 'package:giphy_app/core/common/models/meta.dart';
import 'package:giphy_app/core/api_client/exceptions/api_exception.dart';

class MockGiphyDetailRepository extends Mock
    implements BaseGiphyDetailRepository {}

void main() {
  late MockGiphyDetailRepository mockRepository;

  setUp(() {
    mockRepository = MockGiphyDetailRepository();
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

  group('GiphyDetailCubit', () {
    test('initial state should be GiphyDetailInitialState', () {
      final cubit = GiphyDetailCubit(mockRepository);
      expect(cubit.state, isA<GiphyDetailInitialState>());
      cubit.close();
    });

    test(
      'loadGif should emit loading then success state on successful load',
      () async {
        final gif = createMockGif(id: '123', title: 'Test GIF');
        final response = createMockResponse(data: gif);

        when(
          () => mockRepository.getGifById('123'),
        ).thenAnswer((_) async => response);

        final cubit = GiphyDetailCubit(mockRepository);

        final states = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<GiphyDetailLoadingState>(),
            isA<GiphyDetailSuccessState>()
                .having((s) => s.gif.id, 'gif.id', '123')
                .having((s) => s.gif.title, 'gif.title', 'Test GIF'),
          ]),
        );

        await cubit.loadGif('123');
        await states;
        await cubit.close();
      },
    );

    test(
      'loadGif should emit error state when repository throws exception',
      () async {
        when(
          () => mockRepository.getGifById('123'),
        ).thenThrow(Exception('Network error'));

        final cubit = GiphyDetailCubit(mockRepository);

        expectLater(
          cubit.stream,
          emitsInOrder([
            isA<GiphyDetailLoadingState>(),
            isA<GiphyDetailErrorState>().having(
              (s) => s.message,
              'message',
              'Unknown error',
            ),
          ]),
        );

        cubit.loadGif('123');
        await cubit.close();
      },
    );

    test('loadGif should emit error state with ApiException message', () async {
      final apiException = ApiException('API Error', 'ERROR_CODE');

      when(() => mockRepository.getGifById('123')).thenThrow(apiException);

      final cubit = GiphyDetailCubit(mockRepository);

      final states = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<GiphyDetailLoadingState>(),
          isA<GiphyDetailErrorState>().having(
            (s) => s.message,
            'message',
            'API Error',
          ),
        ]),
      );

      await cubit.loadGif('123');
      await states;
      await cubit.close();
    });

    test(
      'loadGif should emit error state with default message when ApiException has no errorMessage',
      () async {
        final apiException = ApiException(null, 'ERROR_CODE');

        when(() => mockRepository.getGifById('123')).thenThrow(apiException);

        final cubit = GiphyDetailCubit(mockRepository);

        expectLater(
          cubit.stream,
          emitsInOrder([
            isA<GiphyDetailLoadingState>(),
            isA<GiphyDetailErrorState>().having(
              (s) => s.message,
              'message',
              'Api Exception',
            ),
          ]),
        );

        cubit.loadGif('123');
        await cubit.close();
      },
    );

    test('loadGif should call repository with correct gif id', () async {
      final gif = createMockGif(id: '456', title: 'Another GIF');
      final response = createMockResponse(data: gif);

      when(
        () => mockRepository.getGifById('456'),
      ).thenAnswer((_) async => response);

      final cubit = GiphyDetailCubit(mockRepository);

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<GiphyDetailLoadingState>(),
          isA<GiphyDetailSuccessState>().having(
            (s) => s.gif.id,
            'gif.id',
            '456',
          ),
        ]),
      );

      await cubit.loadGif('456');
      verify(() => mockRepository.getGifById('456')).called(1);
      await cubit.close();
    });

    test('loadGif should handle multiple consecutive calls', () async {
      final gif1 = createMockGif(id: '1', title: 'First GIF');
      final gif2 = createMockGif(id: '2', title: 'Second GIF');
      final response1 = createMockResponse(data: gif1);
      final response2 = createMockResponse(data: gif2);

      when(
        () => mockRepository.getGifById('1'),
      ).thenAnswer((_) async => response1);
      when(
        () => mockRepository.getGifById('2'),
      ).thenAnswer((_) async => response2);

      final cubit = GiphyDetailCubit(mockRepository);

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<GiphyDetailLoadingState>(),
          isA<GiphyDetailSuccessState>().having((s) => s.gif.id, 'gif.id', '1'),
          isA<GiphyDetailLoadingState>(),
          isA<GiphyDetailSuccessState>().having((s) => s.gif.id, 'gif.id', '2'),
        ]),
      );

      await cubit.loadGif('1');
      await cubit.loadGif('2');
      await cubit.close();
    });
  });
}
