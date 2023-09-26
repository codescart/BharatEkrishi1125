class OrderModel {
  dynamic id;
  String? agentname;
  String? agentmobile;
  String? ownername;
  String? ownermobile;
  String? agentId;
  String? ownerId;
  String? statusname;
  String? totalamount;
  String? vehiclename;
  String? vehicleNo;
  String? customerid;
  String? custmobile;
  String? custname;
  String? advance;
  String? remaining;
  String? createdAt;
  String? updatedAt;
  String? date;
  String? rate;
  String? quantity;
  String? longs;
  String? lat;
  String? rateType;
  String? areaCalculationId;
  String? implement;
  String? address;
  String? orderid;
  String? vehiclecategory;
  String? vehiclecompany;
  String? vehiclemodel;
  String? time_reminder;
  dynamic latlongStatus;
  dynamic orderLatLong;
  dynamic vehicalId;
  dynamic imei;

  OrderModel(
      {this.id,
      this.agentname,
      this.agentmobile,
      this.ownername,
      this.ownermobile,
      this.agentId,
      this.ownerId,
      this.statusname,
      this.totalamount,
      this.vehiclename,
      this.vehicleNo,
      this.customerid,
      this.custmobile,
      this.custname,
      this.advance,
      this.remaining,
      this.createdAt,
      this.updatedAt,
      this.date,
      this.rate,
      this.quantity,
      this.longs,
      this.lat,
      this.rateType,
      this.areaCalculationId,
      this.implement,
      this.address,
      this.orderid,
      this.vehiclecategory,
      this.vehiclecompany,
      this.vehiclemodel,
      this.time_reminder,
      this.latlongStatus,
      this.orderLatLong,
      this.vehicalId,
      this.imei});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      agentname: json['agentname'],
      agentmobile: json['agentmobile'],
      ownername: json['ownername'],
      ownermobile: json['ownermobile'],
      agentId: json['agent_id'],
      ownerId: json['owner_id'],
      statusname: json['statusname'],
      totalamount: json['totalamount'],
      vehiclename: json['vehiclename'],
      vehicleNo: json['vehicle_no'],
      customerid: json['customerid'],
      custmobile: json['custmobile'],
      custname: json['custname'],
      advance: json['advance'],
      remaining: json['remaining'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      date: json['date'],
      rate: json['rate'],
      quantity: json['quantity'],
      longs: json['longs'],
      lat: json['lat'],
      rateType: json['rate_type'],
      areaCalculationId: json['area_calculation_id'],
      implement: json['implement'],
      address: json['address'],
      orderid: json['orderid'],
      vehiclecategory: json['vehiclecategory'],
      vehiclecompany: json['vehiclecompany'],
      vehiclemodel: json['vehiclemodel'],
      time_reminder: json['time_reminder'],
      latlongStatus: json['latlong_status'],
      orderLatLong: json['orderlat_long'],
      vehicalId: json['vehicle_id'],
      imei: json['imei'],
    );
  }
}
