import 'dart:async';
import 'package:flutter/material.dart';

class CarouselWidget extends StatefulWidget {
  final List<Widget> children;
  final double height;
  final double viewportFraction;
  final Duration autoScrollDuration;
  final Duration animationDuration;
  final bool autoScroll;
  final EdgeInsets padding;

  const CarouselWidget({
    super.key,
    required this.children,
    this.height = 220,
    this.viewportFraction = 0.8,
    this.autoScrollDuration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 500),
    this.autoScroll = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 5),
  });

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: widget.children.length,
    );
    _currentPage = widget.children.length;
    if (widget.autoScroll) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(widget.autoScrollDuration, (timer) {
      if (_pageController.hasClients) {
        _currentPage++;

        // Если достигли конца, переходим к началу
        if (_currentPage >= widget.children.length * 3) {
          _currentPage = widget.children.length;
          _pageController.jumpToPage(_currentPage);
        } else {
          _pageController.animateToPage(
            _currentPage,
            duration: widget.animationDuration,
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });

          // Если достигли конца, переходим к началу
          if (index >= widget.children.length * 3 - 1) {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (_pageController.hasClients) {
                _pageController.jumpToPage(widget.children.length);
                setState(() {
                  _currentPage = widget.children.length;
                });
              }
            });
          }
        },
        itemCount: widget.children.length * 3, // Дублируем элементы 3 раза
        itemBuilder: (context, index) {
          final actualIndex = index % widget.children.length; // Получаем реальный индекс

          return Padding(
            padding: widget.padding,
            child: widget.children[actualIndex],
          );
        },
      ),
    );
  }
}
