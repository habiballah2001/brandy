class AddressModel {
  String city;
  String st;
  String other;
  String addressId;
  AddressModel({
    required this.city,
    required this.st,
    required this.other,
    required this.addressId,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'city': city,
      'st': st,
      'other': other,
      'addressId': addressId,
    };
  }

  factory AddressModel.fromFirestore(doc) {
    return AddressModel(
      city: doc['city'],
      st: doc['st'],
      other: doc['other'],
      addressId: doc['addressId'],
    );
  }
}
