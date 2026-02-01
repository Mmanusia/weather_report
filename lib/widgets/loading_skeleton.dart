import 'package:flutter/material.dart';

/// Loading skeleton shimmer effect
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const ShimmerLoading({
    Key? key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  }) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey[300]!,
                Colors.grey[200]!,
                Colors.grey[300]!,
              ],
              stops: [
                _animationController.value - 0.3,
                _animationController.value,
                _animationController.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Loading skeleton untuk dashboard
class DashboardLoadingSkeleton extends StatelessWidget {
  const DashboardLoadingSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header skeleton
        const ShimmerLoading(height: 30, width: 200),
        const SizedBox(height: 8),
        const ShimmerLoading(height: 20, width: 150),
        const SizedBox(height: 24),

        // Current weather card skeleton
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[100],
          ),
          child: Column(
            children: [
              const ShimmerLoading(height: 60, width: 60),
              const SizedBox(height: 16),
              const ShimmerLoading(height: 40, width: 150),
              const SizedBox(height: 12),
              const ShimmerLoading(height: 20, width: 200),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  3,
                  (index) => Column(
                    children: [
                      const ShimmerLoading(height: 20, width: 60),
                      const SizedBox(height: 8),
                      const ShimmerLoading(height: 20, width: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Hourly skeleton
        const ShimmerLoading(height: 24, width: 150),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) => Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerLoading(height: 16, width: 40),
                  ShimmerLoading(height: 30, width: 30),
                  ShimmerLoading(height: 16, width: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
