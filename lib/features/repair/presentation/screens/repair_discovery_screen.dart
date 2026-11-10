import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// RepairCenterModel represents a local repair workshop or technician.
class RepairCenterModel {
  final String centreId;
  final String name;
  final String description;
  final String category;
  final String city;
  final String area;
  final String contact;
  final String address;
  final List<String> servicesOffered;
  final String verificationStatus;

  const RepairCenterModel({
    required this.centreId,
    required this.name,
    required this.description,
    required this.category,
    required this.city,
    required this.area,
    required this.contact,
    required this.address,
    required this.servicesOffered,
    this.verificationStatus = 'Verified',
  });
}

/// RepairDiscoveryScreen helps community members find local repair workshops
/// to fix items instead of discarding them.
class RepairDiscoveryScreen extends StatefulWidget {
  const RepairDiscoveryScreen({super.key});

  @override
  State<RepairDiscoveryScreen> createState() => _RepairDiscoveryScreenState();
}

class _RepairDiscoveryScreenState extends State<RepairDiscoveryScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = const [
    'All',
    'Electronics',
    'Appliances',
    'Clothing',
    'Shoes & Bags',
    'Furniture',
  ];

  final List<RepairCenterModel> _centers = const [
    RepairCenterModel(
      centreId: 'rep_1',
      name: 'TechFix Audio & Laptop Labs',
      description: 'Specializes in headphone recabling, laptop battery replacement, and motherboard soldering.',
      category: 'Electronics',
      city: 'Bengaluru',
      area: 'Indiranagar 12th Main',
      contact: '+91 98450 12345',
      address: 'Shop 14, 12th Main Rd, HAL 2nd Stage, Indiranagar',
      servicesOffered: ['Headphone Rewiring', 'Laptop Battery Replacement', 'Screen Repair', 'Port Soldering'],
      verificationStatus: 'Verified',
    ),
    RepairCenterModel(
      centreId: 'rep_2',
      name: 'GreenSpark Home Appliance Repair',
      description: 'Mixer grinders, blenders, electric kettles, and toaster motor rewinding.',
      category: 'Appliances',
      city: 'Bengaluru',
      area: 'Koramangala 5th Block',
      contact: '+91 98765 43210',
      address: 'Near Jyoti Nivas College Road, Koramangala',
      servicesOffered: ['Mixer Jar Coupler Replacement', 'Motor Rewinding', 'Cord Replacement', 'Switch Repair'],
      verificationStatus: 'Verified',
    ),
    RepairCenterModel(
      centreId: 'rep_3',
      name: 'ReStitch Tailoring & Alteration Studio',
      description: 'Clothing alterations, zipper replacements, heavy denim repairs, and upcycling consultations.',
      category: 'Clothing',
      city: 'Bengaluru',
      area: 'HSR Layout Sector 4',
      contact: '+91 97420 54321',
      address: '17th Cross, Sector 4, HSR Layout',
      servicesOffered: ['Zipper Replacement', 'Garment Resizing', 'Patch Repair', 'Fabric Mending'],
      verificationStatus: 'Community Recommended',
    ),
    RepairCenterModel(
      centreId: 'rep_4',
      name: 'Master Craft Furniture Care',
      description: 'Office chair pneumatic cylinder replacement, mesh re-tightening, and wooden joint gluing.',
      category: 'Furniture',
      city: 'Bengaluru',
      area: 'BTM Layout 2nd Stage',
      contact: '+91 99001 88223',
      address: '7th Main, 2nd Stage, BTM Layout',
      servicesOffered: ['Hydraulic Lift Repair', 'Chair Caster Wheel Replacement', 'Cushion Reupholstery'],
      verificationStatus: 'Verified',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'All'
        ? _centers
        : _centers.where((c) => c.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Local Repair Directory'),
      ),
      body: Column(
        children: [
          // Banner Notice
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
                Icon(Icons.build_circle_rounded, color: AppColors.primary, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Repairing an object uses 85% less energy than manufacturing a replacement. Support neighborhood repair technicians!',
                    style: TextStyle(fontSize: 12, color: AppColors.primaryDark, height: 1.35),
                  ),
                ),
              ],
            ),
          ),

          // Category Chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.secondaryLight.withValues(alpha: 0.35),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                    ),
                    backgroundColor: AppColors.surface,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = cat);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Directory List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final center = filtered[index];
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
                                center.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified_rounded, size: 12, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    center.verificationStatus,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              center.area,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          center.description,
                          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.35),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: center.servicesOffered
                              .map(
                                (s) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(s, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
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
                              center.contact,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Contacting ${center.name}: ${center.contact}')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                              icon: const Icon(Icons.call_outlined, size: 14),
                              label: const Text('Contact Workshop'),
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
