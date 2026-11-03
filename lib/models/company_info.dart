class CompanyInfo {
  final String name;
  final String overview;
  final String businessDescription;
  final String? vision;
  final String? mission;
  final String? contactDetails;

  const CompanyInfo({
    required this.name,
    required this.overview,
    required this.businessDescription,
    this.vision,
    this.mission,
    this.contactDetails,
  });
}
