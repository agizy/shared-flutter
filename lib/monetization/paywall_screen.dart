import 'package:flutter/material.dart';
import 'premium_repository.dart';

/// Reusable Paywall Screen
/// Customize title, features, and price per app
class PaywallScreen extends StatefulWidget {
  final String appName;
  final String? tagline;
  final List<String> features;
  final String productId;
  final VoidCallback? onPremiumActivated;

  const PaywallScreen({
    super.key,
    required this.appName,
    this.tagline,
    required this.features,
    required this.productId,
    this.onPremiumActivated,
  });

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  final PremiumRepository _premiumRepo = PremiumRepository();
  bool _isLoading = true;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _premiumRepo.initialize(widget.productId);
    setState(() => _isLoading = false);
  }

  Future<void> _purchase() async {
    setState(() => _isPurchasing = true);
    await _premiumRepo.purchasePremium();
    setState(() => _isPurchasing = false);

    if (_premiumRepo.isPremium && mounted) {
      widget.onPremiumActivated?.call();
      Navigator.pop(context, true);
    }
  }

  Future<void> _restore() async {
    setState(() => _isPurchasing = true);
    final restored = await _premiumRepo.restorePurchases();
    setState(() => _isPurchasing = false);

    if (restored && mounted) {
      widget.onPremiumActivated?.call();
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No previous purchases found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${widget.appName} Premium',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (widget.tagline != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.tagline!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Features
              Text(
                'Premium Features:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ...widget.features.map((feature) => _buildFeatureItem(feature)),
              const Spacer(),

              // Price and CTA
              if (_premiumRepo.price != null)
                Center(
                  child: Text(
                    'Only ${_premiumRepo.price}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              const SizedBox(height: 16),

              // Purchase button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isPurchasing ? null : _purchase,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isPurchasing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Upgrade Now'),
                ),
              ),
              const SizedBox(height: 12),

              // Restore button
              Center(
                child: TextButton(
                  onPressed: _isPurchasing ? null : _restore,
                  child: const Text('Restore Purchases'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(feature),
          ),
        ],
      ),
    );
  }
}
