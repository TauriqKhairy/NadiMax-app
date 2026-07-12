import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Saya')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar & Nama
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: const Color(0xFFFDECEE),
                      child: Text(
                        user?.name.isNotEmpty == true
                            ? user!.name[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE53950),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.name ?? '-',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?.email ?? '-',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Info Fisik
              const Text(
                'Data Fisik',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildInfoCard([
                _InfoItem(
                  Icons.cake_outlined,
                  'Umur',
                  user?.age != null ? '${user!.age} tahun' : '-',
                ),
                _InfoItem(
                  Icons.height,
                  'Tinggi',
                  user?.height != null ? '${user!.height} cm' : '-',
                ),
                _InfoItem(
                  Icons.monitor_weight_outlined,
                  'Berat',
                  user?.weight != null ? '${user!.weight} kg' : '-',
                ),
                _InfoItem(
                  Icons.wc_outlined,
                  'Gender',
                  user?.gender == 'male'
                      ? 'Laki-laki'
                      : (user?.gender == 'female' ? 'Perempuan' : '-'),
                ),
              ]),
              const SizedBox(height: 24),

              // Subscription
              const Text(
                'Status Langganan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                color: user?.activeSubscription?.isPremium == true
                    ? const Color(0xFFFFF4E5)
                    : const Color(0xFFF0F0F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    user?.activeSubscription?.isPremium == true
                        ? Icons.workspace_premium
                        : Icons.star_outline,
                    color: user?.activeSubscription?.isPremium == true
                        ? Colors.orange
                        : Colors.grey[600],
                  ),
                  title: Text(
                    user?.activeSubscription?.isPremium == true
                        ? 'Premium'
                        : 'Free',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    user?.activeSubscription?.isPremium == true
                        ? 'Berlaku sampai ${_formatDate(user?.activeSubscription?.expiredAt)}'
                        : 'Upgrade untuk fitur lebih lengkap',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Edit Profile (placeholder, bisa dikembangkan nanti)
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur edit profile segera hadir'),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profile'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFFE53950)),
                  foregroundColor: const Color(0xFFE53950),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<_InfoItem> items) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: items.map((item) {
          final isLast = items.last == item;
          return Column(
            children: [
              ListTile(
                leading: Icon(item.icon, color: const Color(0xFFE53950)),
                title: Text(item.label),
                trailing: Text(
                  item.value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (!isLast) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
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
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  _InfoItem(this.icon, this.label, this.value);
}
