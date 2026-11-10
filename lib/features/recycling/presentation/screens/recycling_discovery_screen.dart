import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class RecyclingFacility {
  final String name;
  final List<String> materials;
  final String area;
  final String contact;
  final String hours;
  final String verificationStatus;

  const RecyclingFacility({
    required this.name,
    required this.materials,
    required this.area,
    required this.contact,
    required this.hours,
    this.verificationStatus = 'Certified Facility',
  });
}

/// RecyclingDiscoveryScreen helps users divert unusable items into certified
/// responsible recycling streams.
class RecyclingDiscoveryScreen extends StatefulWidget {
  const RecyclingDiscoveryScreen({super.key});

  @override
  State<RecyclingDiscoveryScreen> createState() => _RecyclingDiscoveryScreenState();
}

class _RecyclingDiscoveryScreenState extends State<RecyclingDiscoveryScreen> {
  String _selectedMaterial = 'All';

  final List<String> _materials = [
    'All',
    'E-Waste',
    'Paper',
    'Plastic',
    'Metal',
    'Clothing & Textiles',
    'Batteries',
  ];

  final List<RecyclingFacility> _facilities = const [
    RecyclingFacility(
      name: 'EcoE-Waste Safe Recyclers',
      materials: ['E-Waste', 'Batteries', 'Metal'],
      area: 'Whitefield Industrial Area, Bengaluru',
      contact: '080 2841 0099',
      hours: 'Mon-Sat: 9:00 AM - 6:00 PM',
      verificationStatus: 'KSPCB Certified',
    ),
    RecyclingFacility(
      name: 'CleanLoop Material Recovery Center',
      materials: ['Paper', 'Plastic', 'Metal'],
      area: 'Koramangala 8th Block, Bengaluru',
      contact: '+91 80 4123 4567',
      hours: 'Mon-Sun: 8:00 AM - 7:00 PM',
      verificationStatus: 'Municipal Certified',
    ),
    RecyclingFacility(
      name: 'ThreadCycle Textile Reclamation',
      materials: ['Clothing & Textiles'],
      area: 'HSR Layout Sector 1, Bengaluru',
      contact: '+91 99887 76655',
      hours: 'Tue-Sun: 10:00 AM - 5:00 PM',
      verificationStatus: 'Community Certified',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedMaterial == 'All'
        ? _facilities
        : _facilities.where((f) => f.materials.contains(_selectedMaterial)).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Recycling Facilities'),
      ),
      body: Column(
        children: [
          // Banner
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.recycling_rounded, color: AppColors.primary, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'When an item cannot be reused or repaired, recycling keeps raw materials out of landfills.',
                    style: TextStyle(fontSize: 12, color: AppColors.primaryDark, height: 1.35),
                  ),
                ),
              ],
            ),
          ),

          // Material Filter Chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              itemCount: _materials.length,
              itemBuilder: (context, index) {
                final mat = _materials[index];
                final isSelected = _selectedMaterial == mat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(mat),
                    selected: isSelected,
                    selectedColor: AppColors.secondaryLight.withValues(alpha: 0.35),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                    ),
                    backgroundColor: AppColors.surface,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedMaterial = mat);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Facilities List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final facility = filtered[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                facility.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                facility.verificationStatus,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(facility.area, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(facility.hours, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          children: facility.materials
                              .map(
                                (m) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(m, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              facility.contact,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Contacting ${facility.name}')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                              icon: const Icon(Icons.navigation_outlined, size: 14),
                              label: const Text('Get Directions'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
