class BuyerDocuments {
  final String? governmentId;
  final String? businessLicence;
  final String? proofOfAddress;

  BuyerDocuments({
    this.governmentId,
    this.businessLicence,
    this.proofOfAddress,
  });

  factory BuyerDocuments.fromJson(Map<String, dynamic> json) {
    return BuyerDocuments(
      governmentId: json['government_id'],
      businessLicence: json['business_licence'],
      proofOfAddress: json['proof_of_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'government_id': governmentId,
      'business_licence': businessLicence,
      'proof_of_address': proofOfAddress,
    };
  }

  bool get areAllNull =>
      governmentId == null && businessLicence == null && proofOfAddress == null;
}
