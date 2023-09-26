class UserModel {
  int? id;
  String? name;
  String? mobile;
  String? role;
  String? staus;
  String? otp;
  String? city;
  String? address;
  String? verified;
  String? photo;
  String? dealerId;
  String? createdAt;
  String? updatedAt;
  String? state;
  String? lat;
  String? long;
  String? tractor;
  String? harvester;
  String? sname;

  UserModel(
      {this.id,
      this.name,
      this.mobile,
      this.role,
      this.staus,
      this.otp,
      this.city,
      this.address,
      this.verified,
      this.photo,
      this.dealerId,
      this.createdAt,
      this.updatedAt,
      this.state,
      this.lat,
      this.long,
      this.tractor,
      this.harvester,
        this.sname
      });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
      role: json['role'],
      staus: json['staus'],
      otp: json['otp'],
      city: json['city'],
      address: json['address'],
      verified: json['verified'],
      photo: json['photo'],
      dealerId: json['dealer_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      state: json['state'],
      lat: json['lat'],
      long: json['long'],
      tractor: json['tractor'],
      harvester: json['harvester'],
      sname: json['s_name'],
    );
  }
}
