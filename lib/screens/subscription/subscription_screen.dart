import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/subscription_provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().fetchSubscription();
    });
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '-';
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '-';
    }
  }

  Future<void> _confirmUpgrade() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Upgrade ke Premium?'),
        content: const Text('Nikmati fitur lengkap NadiMax selama 30 hari.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await context
          .read<SubscriptionProvider>()
          .upgradeToPremium();
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil upgrade ke Premium!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _confirmDowngrade() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Downgrade ke Free?'),
        content: const Text('Anda akan kehilangan akses fitur Premium.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Downgrade', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await context
          .read<SubscriptionProvider>()
          .downgradeToFree();
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil downgrade ke Free.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Langganan Saya')),
      body: SafeArea(
        child: Consumer<SubscriptionProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.subscription == null) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFE53950)),
              );
            }

            final isPremium = provider.isPremium;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Card Status Saat Ini
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isPremium
                            ? [Colors.orange[400]!, Colors.orange[700]!]
                            : [Colors.grey[400]!, Colors.grey[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isPremium
                              ? Icons.workspace_premium
                              : Icons.star_outline,
                          color: Colors.white,
                          size: 36,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isPremium ? 'Plan Premium' : 'Plan Free',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isPremium
                              ? 'Berlaku sampai ${_formatDate(provider.subscription?.expiredAt)}'
                              : 'Upgrade untuk fitur lebih lengkap',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Daftar Fitur
                  const Text(
                    'Fitur Premium',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem('History BPM tanpa batas'),
                  _buildFeatureItem('Analytics & Training Zone lengkap'),
                  _buildFeatureItem('Export laporan kesehatan'),
                  _buildFeatureItem('Prioritas dukungan pelanggan'),
                  const SizedBox(height: 32),

                  // Tombol Aksi
                  if (!isPremium)
                    ElevatedButton.icon(
                      onPressed: provider.isLoading ? null : _confirmUpgrade,
                      icon: const Icon(Icons.workspace_premium),
                      label: const Text('Upgrade ke Premium'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    )
                  else
                    OutlinedButton(
                      onPressed: provider.isLoading ? null : _confirmDowngrade,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Downgrade ke Free'),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
