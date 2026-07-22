import 'package:flutter/material.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

class ReusablePaginatedListView<T> extends StatefulWidget {
  final Future<List<T>> Function(int page, int pageSize) pageLoader;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int pageSize;
  final Widget? emptyState;
  final Widget? loadingWidget;
  final Widget Function(dynamic error, VoidCallback retry)? errorBuilder;
  final double? itemExtent;
  final ScrollController? scrollController;
  final EdgeInsets? padding;

  const ReusablePaginatedListView({
    super.key,
    required this.pageLoader,
    required this.itemBuilder,
    this.pageSize = 50,
    this.emptyState,
    this.loadingWidget,
    this.errorBuilder,
    this.itemExtent,
    this.scrollController,
    this.padding,
  });

  @override
  State<ReusablePaginatedListView<T>> createState() =>
      _ReusablePaginatedListViewState<T>();
}

class _ReusablePaginatedListViewState<T>
    extends State<ReusablePaginatedListView<T>> {
  late final ScrollController _scrollController;

  final List<T> _items = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 0;
  dynamic _error;
  bool _initialLoadDone = false;

  @override
  void initState() {
    super.initState();
    _scrollController =
        widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
    _loadPage();
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadPage() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final items = await widget.pageLoader(0, widget.pageSize);
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(items);
        _currentPage = 0;
        _hasMore = items.length >= widget.pageSize;
        _isLoading = false;
        _initialLoadDone = true;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _initialLoadDone = true;
        _error = e;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    try {
      final nextPage = _currentPage + 1;
      final items = await widget.pageLoader(nextPage, widget.pageSize);
      if (!mounted) return;
      setState(() {
        _items.addAll(items);
        _currentPage = nextPage;
        _hasMore = items.length >= widget.pageSize;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _refresh() async {
    await _loadPage();
  }

  Widget _buildFooter() {
    if (_isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (!_hasMore && _items.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
            child: Text(
              AppStrings.paginationLoadedAll,
              style: AppTextStyles.caption(context).copyWith(color: Colors.grey[500]),
            ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _items.isEmpty) {
      return widget.loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _items.isEmpty) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_error, _refresh);
      }
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: AppIconSize.xl.value, color: Colors.red[300]),
            const SizedBox(height: 12),
            Text(
              AppStrings.loadFailed,
              style: AppTextStyles.body(context).copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.refresh),
            ),
          ],
        ),
      );
    }

    if (_initialLoadDone && _items.isEmpty) {
      return widget.emptyState ??
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            Icon(Icons.inbox_outlined, size: AppIconSize.xl.value, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              AppStrings.noItems,
              style: AppTextStyles.body(context).copyWith(color: Colors.grey[500]),
            ),
              ],
            ),
          );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: widget.padding ?? EdgeInsets.zero,
        itemExtent: widget.itemExtent,
        itemCount: _items.length + 1,
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return _buildFooter();
          }
          return widget.itemBuilder(context, _items[index], index);
        },
      ),
    );
  }
}

