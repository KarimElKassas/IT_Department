class LandPlotModel{

  int? landPlotID;
  String? landPlotName;
  int? landPlotFK;
  int? landPlotLevel;
  int? implementingCompany;
  String? depth;
  String? uWater;
  String? waterColumn;
  String? drainingWater;
  String? salinity;
  String? pumpCapacity;
  String? phasesPump;
  int? companyPumps;
  String? dataDischarge;
  String? deviceType;
  String? deviceTowers;
  String? devicePlanes;
  String? deviceSpaceTotal;
  int? maintenanceAgent;
  String? deviceCategory;
  String? landPlotRecModify;
  String? deviceSpaceValid;
  String? deviceSpaceNotValid;
  String? deviceSpaceNotValidReason;
  String? landPlotNotes;
  String? landPlotLatitude;
  String? landPlotLongitude;

  LandPlotModel(
      this.landPlotID,
      this.landPlotName,
      this.landPlotFK,
      this.landPlotLevel,
      this.implementingCompany,
      this.depth,
      this.uWater,
      this.waterColumn,
      this.drainingWater,
      this.salinity,
      this.pumpCapacity,
      this.phasesPump,
      this.companyPumps,
      this.dataDischarge,
      this.deviceType,
      this.deviceTowers,
      this.devicePlanes,
      this.deviceSpaceTotal,
      this.maintenanceAgent,
      this.deviceCategory,
      this.landPlotRecModify,
      this.deviceSpaceValid,
      this.deviceSpaceNotValid,
      this.deviceSpaceNotValidReason,
      this.landPlotNotes,
      this.landPlotLatitude,
      this.landPlotLongitude);
}
class LandPlotDeviceHistoryModel{
  String? type;
  String? name;
  String? space;
  String? from;
  String? to;

  LandPlotDeviceHistoryModel(
      this.type, this.name, this.space, this.from, this.to);
}