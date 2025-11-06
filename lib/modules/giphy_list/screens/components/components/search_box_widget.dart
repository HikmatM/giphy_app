import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giphy_app/core/ui_kit/h_text_field.dart';

class SearchBoxWidget extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final Duration debounceDuration;

  const SearchBoxWidget({
    super.key,
    required this.onSearchChanged,
    this.debounceDuration = const Duration(seconds: 2),
  });

  @override
  State<SearchBoxWidget> createState() => _SearchBoxWidgetState();
}

class _SearchBoxWidgetState extends State<SearchBoxWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // _searchController.addListener(_onSearchChanged);
  }

  // void _onSearchChanged() {
  //   if (_debounceTimer?.isActive ?? false) {
  //     _debounceTimer!.cancel();
  //   }

  //   _debounceTimer = Timer(widget.debounceDuration, () {
  //     widget.onSearchChanged(_searchController.text);
  //   });
  // }

  void _onSearchChanged(String newValue) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onSearchChanged(newValue);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    // _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: HTextField(
        controller: _searchController,
        onChanged: (newValue) {
          _onSearchChanged(newValue);
        },
        focusNode: _searchFocusNode,
        hintText: 'Search GIFs...',
        labelText: 'Search',
      ),
    );
  }
}
