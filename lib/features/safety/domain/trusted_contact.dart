/// Purpose: Represent trusted contact information for quick support actions.
class TrustedContact {
  const TrustedContact({
    required this.id,
    required this.name,
    required this.relation,
    required this.phone,
    required this.isPrimary,
    required this.sortOrder,
  });

  final int id;
  final String name;
  final String relation;
  final String phone;
  final bool isPrimary;
  final int sortOrder;
}
