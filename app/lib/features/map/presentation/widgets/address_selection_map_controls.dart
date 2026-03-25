import 'package:flutter/material.dart';

/// Плавающие контролы карты: зум (+/-) и кнопка «Моё местоположение»
class AddressSelectionMapControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onLocate;

  const AddressSelectionMapControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onLocate,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.95, -0.3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildZoomContainer(context),
          const SizedBox(height: 16),
          _buildLocationButton(context),
        ],
      ),
    );
  }

  Widget _buildZoomContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87),
            onPressed: onZoomIn,
            iconSize: 28,
            padding: const EdgeInsets.all(12),
          ),
          Container(height: 1, width: 40, color: Colors.grey[300]),
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.black87),
            onPressed: onZoomOut,
            iconSize: 28,
            padding: const EdgeInsets.all(12),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.navigation_outlined, color: Colors.black87),
        onPressed: onLocate,
        iconSize: 28,
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
