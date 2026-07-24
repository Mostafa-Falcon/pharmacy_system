import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';

/// مكون أوتوكومبليت عام وبحت (Generic AppAutocomplete&lt;T&gt;) ينتمي للـ Core UI.
/// يتيح البحث والربط بأي نوع بيانات بدون التزامات أو تبعيات للـ Business Logic.
class AppAutocomplete<T> extends StatefulWidget {
  final FutureOr<List<T>> Function(String query) searchProvider;
  final Widget Function(BuildContext context, T item, bool isSelected)
  itemBuilder;
  final ValueChanged<T> onSelected;
  final T? Function(String query, List<T> items)? exactMatchEvaluator;
  final Widget? emptyWidget;
  final String? label;
  final String hint;
  final bool autofocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool clearOnSelect;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? maxOverlayHeight;

  const AppAutocomplete({
    super.key,
    required this.searchProvider,
    required this.itemBuilder,
    required this.onSelected,
    this.exactMatchEvaluator,
    this.emptyWidget,
    this.label,
    this.hint = GeneralStrings.searchHint,
    this.autofocus = false,
    this.controller,
    this.focusNode,
    this.clearOnSelect = true,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.maxOverlayHeight,
  });

  @override
  State<AppAutocomplete<T>> createState() => _AppAutocompleteState<T>();
}

class _AppAutocompleteState<T> extends State<AppAutocomplete<T>> {
  final LayerLink _layerLink = LayerLink();
  FocusNode? _internalFocusNode;
  late final TextEditingController _controller;
  OverlayEntry? _overlayEntry;
  List<T> _results = [];
  int _selectedIndex = -1;
  bool _isOverlayOpen = false;
  bool _isLoading = false;
  Timer? _debounceTimer;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _internalFocusNode?.dispose();
    if (widget.controller == null) _controller.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    if (_isOverlayOpen) {
      _overlayEntry?.markNeedsBuild();
      return;
    }

    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    if (mounted) {
      setState(() => _isOverlayOpen = true);
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOverlayOpen = false;
    _selectedIndex = -1;
    if (mounted) {
      setState(() {});
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(AppRadius.md.r),
            clipBehavior: Clip.antiAlias,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: widget.maxOverlayHeight ?? 350.h,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: _isLoading
                  ? Padding(
                      padding: EdgeInsets.all(16.w),
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    )
                  : _results.isEmpty
                  ? (widget.emptyWidget ??
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: const Center(
                            child: AppText(GeneralStrings.searchNoResults),
                          ),
                        ))
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _results.length,
                      separatorBuilder: (_, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _results[index];
                        final isSelected = index == _selectedIndex;
                        return InkWell(
                          onTap: () => _selectItem(item),
                          child: widget.itemBuilder(context, item, isSelected),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectItem(T item) {
    widget.onSelected(item);
    if (widget.clearOnSelect) {
      _controller.clear();
      widget.onChanged?.call('');
    }
    _hideOverlay();
    _focusNode.requestFocus();
  }

  void _onChanged(String value) {
    widget.onChanged?.call(value);
    final query = value.trim();
    if (query.isEmpty) {
      _results = [];
      _hideOverlay();
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 150), () async {
      if (!mounted) return;
      setState(() => _isLoading = true);

      try {
        final items = await widget.searchProvider(query);
        if (!mounted) return;

        _results = items;

        if (widget.exactMatchEvaluator != null) {
          final exactMatch = widget.exactMatchEvaluator!(query, _results);
          if (exactMatch != null) {
            _selectItem(exactMatch);
            return;
          }
        }

        _selectedIndex = _results.isNotEmpty ? 0 : -1;
        _showOverlay();
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    });
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_results.isNotEmpty) {
        setState(() {
          _selectedIndex = (_selectedIndex + 1) % _results.length;
        });
        _overlayEntry?.markNeedsBuild();
        return KeyEventResult.handled;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_results.isNotEmpty) {
        setState(() {
          _selectedIndex =
              (_selectedIndex - 1 + _results.length) % _results.length;
        });
        _overlayEntry?.markNeedsBuild();
        return KeyEventResult.handled;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (_selectedIndex >= 0 && _selectedIndex < _results.length) {
        _selectItem(_results[_selectedIndex]);
        return KeyEventResult.handled;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      _hideOverlay();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        onKeyEvent: _onKeyEvent,
        child: AppInput(
          controller: _controller,
          focusNode: _focusNode,
          label: widget.label,
          hint: widget.hint,
          autofocus: widget.autofocus,
          onChanged: _onChanged,
          prefixIcon: widget.prefixIcon ?? const Icon(Icons.search_rounded),
          suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }
}
