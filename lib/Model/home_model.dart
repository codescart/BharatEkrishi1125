class HomeModel {
  String? newdistance;
  String? lastlocation;
  // String? iCCID2;
  String? imei;
  // String? priority;
  // String? sat;
  // String? event;
  dynamic ignition;
  // dynamic motion;
  // String? dataMode;
  // String? rssi;
  // String? sleep;
  String? gNSSStatus;
  // dynamic out1;
  // dynamic digitalInput1;
  String? batteryLevel;
  // String? pdop;
  // String? hdop;
  String? power;
  String? battery;
  // String? batteryCurrent;
  // dynamic analogInput1;
  // String? iCCID1;
  // String? totalDistance;
  // String? hours;
  // String? protocol;
  // String? latitude;
  // String? longitude;
  // String? altitude;
  String? vehicleNo;
  // String? vehicleName;
  // String? overspeeding;
  // String? overheathing;
  // String? initialEngine;
  String? usersId;
  String? vehicleCatId;
  // String? vehicleCompanyId;
  // String? vehicleModelId;
  // String? rc;
  String? speed;
  // String? devicetime;
  // String? servertime;
  // String? fixtime;
  // String? valid;
  // String? course;
  // dynamic address;
  // String? accuracy;
  String? network;
  // String? deviceid;
  String? vehicleId;
  dynamic temprature;
  String? fuel;
  String? todayamount;
  String? todayjobarea;
  String? today_engine_hours;
  String? lastupdate;
  String? message;
  dynamic speedvalue;
  dynamic fuelvalue;
  String? areaUnit;
  dynamic unitValue;

  HomeModel(
      {this.newdistance,
      this.lastlocation,
      // this.iCCID2,
      this.imei,
      // this.priority,
      // this.sat,
      // this.event,
      this.ignition,
      // this.motion,
      // this.dataMode,
      // this.rssi,
      // this.sleep,
      this.gNSSStatus,
      // this.out1,
      // this.digitalInput1,
      // this.batteryLevel,
      // this.pdop,
      // this.hdop,
      this.power,
      this.battery,
      // this.batteryCurrent,
      // this.analogInput1,
      // this.iCCID1,
      // this.totalDistance,
      // this.hours,
      // this.protocol,
      // this.latitude,
      // this.longitude,
      // this.altitude,
      this.vehicleNo,
      // this.vehicleName,
      // this.overspeeding,
      // this.overheathing,
      // this.initialEngine,
      this.usersId,
      this.vehicleCatId,
      // this.vehicleCompanyId,
      // this.vehicleModelId,
      // this.rc,
      this.speed,
      // this.devicetime,
      // this.servertime,
      // this.fixtime,
      // this.valid,
      // this.course,
      // this.address,
      // this.accuracy,
      this.network,
      // this.deviceid,
      this.vehicleId,
      this.temprature,
      this.fuel,
      this.todayamount,
      this.todayjobarea,
      this.today_engine_hours,
      this.lastupdate,
      this.message,
      this.speedvalue,
      this.fuelvalue,
      this.areaUnit,
      this.unitValue});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      newdistance: json['newdistance'],
      lastlocation: json['lastlocation'],
      // iCCID2: json['iCCID2'],
      imei: json['imei'],
      // priority: json['priority'],
      // sat: json['sat'],
      // event: json['event'],
      ignition: json['ignition'],
      // motion: json['motion'],
      // dataMode: json['dataMode'],
      // rssi: json['rssi'],
      // sleep: json['sleep'],
      gNSSStatus: json['GNSSStatus'],
      // out1: json['out1'],
      // digitalInput1: json['digitalInput1'],
      // batteryLevel: json['BatteryLevel'],
      // pdop: json['pdop'],
      // hdop: json['hdop'],
      power: json['power'],
      battery: json['battery'],
      // batteryCurrent: json['batteryCurrent'],
      // analogInput1: json['analogInput1'],
      // iCCID1: json['iCCID1'],
      // totalDistance: json['totalDistance'],
      // hours: json['hours'],
      // protocol: json['protocol'],
      // latitude: json['latitude'],
      // longitude: json['longitude'],
      // altitude: json['altitude'],
      vehicleNo: json['vehicle_no'],
      // vehicleName: json['vehicle_name'],
      // overspeeding: json['overspeeding'],
      // overheathing: json['overheathing'],
      // initialEngine: json['initial_engine'],
      usersId: json['users_id'],
      vehicleCatId: json['vehicle_cat_id'],
      // vehicleCompanyId: json['vehicle_company_id'],
      // vehicleModelId: json['vehicle_model_id'],
      // rc: json['rc'],
      speed: json['speed'],
      // devicetime: json['devicetime'],
      // servertime: json['servertime'],
      // fixtime: json['fixtime'],
      // valid: json['valid'],
      // course: json['course'],
      // address: json['address'],
      // accuracy: json['accuracy'],
      network: json['network'],
      // deviceid: json['deviceid'],
      vehicleId: json['vehicle_id'],
      temprature: json['temprature'],
      fuel: json['fuel'],
      todayamount: json['todayamount'],
      todayjobarea: json['todayjobarea'],
      today_engine_hours: json['today_engine_hours'],
      lastupdate: json['lastupdate'],
      message: json['message'],
      speedvalue: json['speedvalue'],
      fuelvalue: json['fuelvalue'],
      areaUnit: json['prefarea_name'],
      unitValue: json['pref_area_calculation'],
    );
  }
}
