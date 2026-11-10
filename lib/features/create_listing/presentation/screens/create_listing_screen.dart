import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_categories.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../../explore/domain/models/item_model.dart';
import '../../../explore/presentation/providers/items_provider.dart';

/// CreateListingScreen provides a complete, validated form to list an item
/// with category selection, condition tags, image picker, and location details.
class CreateListingScreen extends ConsumerStatefulWidget {
  final ItemModel? itemToEdit;

  const CreateListingScreen({super.key, this.itemToEdit});

  @override
  ConsumerState<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();

  String _selectedCategory = 'Electronics';
  String _selectedCondition = 'Good';
  String _selectedListingType = 'Free donation';

  final List<XFile> _pickedImages = [];
  final List<String> _existingImageUrls = [];
  bool _isSubmitting = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider);

    if (widget.itemToEdit != null) {
      final item = widget.itemToEdit!;
      _titleController.text = item.title;
      _descriptionController.text = item.description;
      _cityController.text = item.city;
      _areaController.text = item.area;
      _selectedCategory = item.category;
      _selectedCondition = item.condition;
      _selectedListingType = item.listingType;
      _existingImageUrls.addAll(item.imageUrls);
    } else {
      _cityController.text = user?.city ?? 'Bengaluru';
      _areaController.text = user?.area ?? 'Indiranagar';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _pickedImages.add(image);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick image: $e')),
        );
      }
    }
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              const Text('Add Item Photographs', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                title: const Text('Choose from Gallery / Files'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (!kIsWeb)
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                  title: const Text('Take a Photo with Camera'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pickedImages.isEmpty && _existingImageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one photograph of the item.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate upload to Firebase Storage
    await Future.delayed(const Duration(milliseconds: 1000));

    final user = ref.read(authProvider);
    final itemId = widget.itemToEdit?.itemId ?? const Uuid().v4();

    // Default sample image if test image path is local
    final finalUrls = List<String>.from(_existingImageUrls);
    if (finalUrls.isEmpty) {
      finalUrls.add('https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=800&q=80');
    }

    final newItem = ItemModel(
      itemId: itemId,
      ownerId: user?.uid ?? 'guest_user',
      ownerName: user?.displayName ?? 'Community Member',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      condition: _selectedCondition,
      listingType: _selectedListingType,
      imageUrls: finalUrls,
      city: _cityController.text.trim(),
      area: _areaController.text.trim(),
      status: 'Available',
      createdAt: widget.itemToEdit?.createdAt ?? DateTime.now(),
      isFeatured: false,
    );

    final currentItems = ref.read(itemsListProvider);
    if (widget.itemToEdit != null) {
      ref.read(itemsListProvider.notifier).setItems([
        for (final it in currentItems)
          if (it.itemId == itemId) newItem else it,
      ]);
    } else {
      ref.read(itemsListProvider.notifier).setItems([newItem, ...currentItems]);
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          content: Text(widget.itemToEdit != null ? 'Listing updated successfully!' : 'Item listed for community reuse!'),
        ),
      );
      context.go('/explore');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.itemToEdit != null ? 'Edit Listing' : 'List an Item for Reuse'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Upload Section
              const Text(
                'Item Photographs',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              const Text(
                'Add clear photos showing the current condition and any details.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),

              // Image Thumbnails Row
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Add Photo Button
                    GestureDetector(
                      onTap: _showImagePickerSheet,
                      child: Container(
                        width: 90,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 26),
                            SizedBox(height: 4),
                            Text('Add Photo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                          ],
                        ),
                      ),
                    ),

                    // Picked Image Previews
                    ..._pickedImages.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final img = entry.value;
                      return Stack(
                        children: [
                          Container(
                            width: 90,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: FutureBuilder<Uint8List>(
                              future: img.readAsBytes(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Image.memory(snapshot.data!, fit: BoxFit.cover);
                                }
                                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                              },
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 16,
                            child: GestureDetector(
                              onTap: () => setState(() => _pickedImages.removeAt(idx)),
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                child: const Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    // Existing URLs (when editing)
                    ..._existingImageUrls.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final url = entry.value;
                      return Stack(
                        children: [
                          Container(
                            width: 90,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(url, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 4,
                            right: 16,
                            child: GestureDetector(
                              onTap: () => setState(() => _existingImageUrls.removeAt(idx)),
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                child: const Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Item Title
              const Text('Item Name / Title', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'e.g. Ergonomic Office Chair'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter an item name' : null,
              ),
              const SizedBox(height: 18),

              // Category Selector
              const Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(),
                items: AppCategories.list
                    .where((c) => c.id != 'all')
                    .map((cat) => DropdownMenuItem(value: cat.name, child: Text(cat.name)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 18),

              // Condition Chips
              const Text('Condition', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: AppCategories.conditions
                    .where((c) => c != 'All Conditions')
                    .map((cond) {
                  final isSelected = _selectedCondition == cond;
                  return ChoiceChip(
                    label: Text(cond),
                    selected: isSelected,
                    selectedColor: AppColors.secondaryLight.withValues(alpha: 0.35),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                    ),
                    backgroundColor: AppColors.surface,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCondition = cond);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // Listing Type
              const Text('Listing Purpose', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Column(
                children: AppCategories.listingTypes.map((type) {
                  final isSelected = _selectedListingType == type;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.surfaceVariant : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                    ),
                    child: InkWell(
                      onTap: () => setState(() => _selectedListingType = type),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSelected ? AppColors.primary : AppColors.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                type,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // Description
              const Text('Detailed Description', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe how long you owned it, any functional notes, and why it is great for reuse...',
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please add a short description' : null,
              ),
              const SizedBox(height: 18),

              // Location Row
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('City', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(hintText: 'City'),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Neighborhood / Area', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _areaController,
                          decoration: const InputDecoration(hintText: 'e.g. Indiranagar'),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitListing,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline_rounded),
                  label: Text(
                    _isSubmitting
                        ? 'Publishing Listing...'
                        : (widget.itemToEdit != null ? 'Save Changes' : 'Publish for Reuse'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
