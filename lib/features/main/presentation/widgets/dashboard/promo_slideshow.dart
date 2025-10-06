import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PromoSlideshow extends StatefulWidget {
  const PromoSlideshow({super.key});

  @override
  State<PromoSlideshow> createState() => _PromoSlideshowState();
}

class _PromoSlideshowState extends State<PromoSlideshow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  final List<Map<String, dynamic>> _promoCards = [
    {
      'title': 'Need Help Getting Started?',
      'description': 'Watch our tutorial videos and get started in minutes!',
      'icon': Icons.play_circle_outline,
      'buttonText': 'Watch Tutorials',
      'color': const Color(0xFF4E73DF),
    },
    {
      'title': 'Boost Your Balance',
      'description': 'Add funds to your wallet and unlock all features!',
      'icon': Icons.account_balance_wallet_outlined,
      'buttonText': 'Add Funds Now',
      'color': const Color(0xFF1CC88A),
    },
    {
      'title': 'Get Your First Number',
      'description': 'Rent a number and start receiving SMS instantly!',
      'icon': Icons.phone_android_outlined,
      'buttonText': 'Rent Now',
      'color': const Color(0xFFF6C23E),
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll the carousel
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        int nextPage = _currentPage + 1;
        if (nextPage >= _totalPages) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140, // Reduced height for the carousel
          child: PageView.builder(
            controller: _pageController,
            itemCount: _promoCards.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final card = _promoCards[index];
              return _buildPromoCard(
                context,
                title: card['title'],
                description: card['description'],
                icon: card['icon'],
                buttonText: card['buttonText'],
                color: card['color'],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _pageController,
          count: _promoCards.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Theme.of(context).primaryColor,
            dotColor: Theme.of(context).dividerColor,
          ),
          onDotClicked: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ],
    );
  }

  Widget _buildPromoCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String buttonText,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                // Handle button press
                // You can add navigation or other actions here
              },
              style: TextButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
