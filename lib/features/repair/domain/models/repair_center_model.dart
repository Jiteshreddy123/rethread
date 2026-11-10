/// RepairCenterModel represents a local repair shop or certified repair professional.
class RepairCenterModel {
  final String centreId;
  final String name;
  final String description;
  final String category; // Electronics | Appliances | Clothing | Shoes & Bags | Furniture
  final String city;
  final String area;
  final String contact;
  final String address;
  final List<String> servicesOffered;
  final String verificationStatus; // Verified | Community Recommended

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
