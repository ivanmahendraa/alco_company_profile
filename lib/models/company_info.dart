class CompanyInfo {
  final String name;
  final String overview;
  final String businessDescription;
  final List<String> values;
  final List<String> qualityPolicies;
  final String? vision;
  final String? mission;
  final String? commitment;
  final String? address;
  final String? phone;
  final String? industry;
  final String? foundingYear;
  final String? companyType;
  final String? employeeRange;
  final String? headquarters;

  const CompanyInfo({
    required this.name,
    required this.overview,
    required this.businessDescription,
    this.values = const [],
    this.qualityPolicies = const [],
    this.vision,
    this.mission,
    this.commitment,
    this.address,
    this.phone,
    this.industry,
    this.foundingYear,
    this.companyType,
    this.employeeRange,
    this.headquarters,
  });
}
