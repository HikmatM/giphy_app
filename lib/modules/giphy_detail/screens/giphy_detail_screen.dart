import 'package:auto_route/annotations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_app/core/di/injection.dart';
import 'package:giphy_app/modules/giphy_detail/cubit/giphy_detail_cubit.dart';
import 'package:giphy_app/modules/giphy_detail/cubit/giphy_detail_state.dart';
import 'package:giphy_app/core/common/models/giphy_data.dart';
import 'package:giphy_app/core/common/widgets/error_widget.dart';
import 'package:giphy_app/core/common/widgets/loading_indicator.dart';

@RoutePage()
class GiphyDetailScreen extends StatefulWidget {
  final String gifId;

  const GiphyDetailScreen({super.key, required this.gifId});

  @override
  State<GiphyDetailScreen> createState() => _GiphyDetailScreenState();
}

class _GiphyDetailScreenState extends State<GiphyDetailScreen> {
  final GiphyDetailCubit _cubit = getIt<GiphyDetailCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.loadGif(widget.gifId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('GIF Details'), elevation: 2),
        body: BlocBuilder<GiphyDetailCubit, GiphyDetailState>(
          builder: (context, state) {
            if (state is GiphyDetailLoadingState) {
              return const LoadingIndicator();
            }

            if (state is GiphyDetailErrorState) {
              return ErrorDisplayWidget(message: state.message);
            }

            if (state is GiphyDetailSuccessState) {
              final gif = state.gif;
              final imageUrl =
                  gif.images.original?.url ??
                  gif.images.fixedHeight?.url ??
                  gif.images.downsizedLarge?.url ??
                  '';

              return OrientationBuilder(
                builder: (context, orientation) {
                  final isPortrait = orientation == Orientation.portrait;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(isPortrait ? 16.0 : 24.0),
                      child: isPortrait
                          ? _PortraitLayout(gif: gif, imageUrl: imageUrl)
                          : _LandscapeLayout(gif: gif, imageUrl: imageUrl),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _PortraitLayout extends StatelessWidget {
  final GiphyData gif;
  final String imageUrl;

  const _PortraitLayout({required this.gif, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imageUrl.isNotEmpty)
          Center(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 64),
            ),
          )
        else
          const Center(child: Icon(Icons.image_not_supported, size: 64)),
        const SizedBox(height: 24),
        Text(gif.title, style: Theme.of(context).textTheme.headlineSmall),
        if (gif.username != null) ...[
          const SizedBox(height: 8),
          Text(
            'By: ${gif.username}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
        if (gif.rating != null) ...[
          const SizedBox(height: 8),
          Chip(label: Text('Rating: ${gif.rating?.toUpperCase()}')),
        ],
        if (gif.source != null) ...[
          const SizedBox(height: 16),
          Text('Source:', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(gif.source!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    );
  }
}

class _LandscapeLayout extends StatelessWidget {
  final GiphyData gif;
  final String imageUrl;

  const _LandscapeLayout({required this.gif, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image on the left
        Expanded(
          flex: 2,
          child: Column(
            children: [
              if (imageUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 64),
                )
              else
                const Center(child: Icon(Icons.image_not_supported, size: 64)),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Details on the right
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(gif.title, style: Theme.of(context).textTheme.headlineSmall),
              if (gif.username != null) ...[
                const SizedBox(height: 8),
                Text(
                  'By: ${gif.username}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
              if (gif.rating != null) ...[
                const SizedBox(height: 8),
                Chip(label: Text('Rating: ${gif.rating?.toUpperCase()}')),
              ],
              if (gif.source != null) ...[
                const SizedBox(height: 16),
                Text('Source:', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  gif.source!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
