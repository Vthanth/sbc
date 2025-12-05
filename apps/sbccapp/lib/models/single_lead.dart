class GetSingleLeadModel {
  bool? status;
  String? message;
  Data? data;

  GetSingleLeadModel({this.status, this.message, this.data});

  GetSingleLeadModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? leadId;
  String? uuid;
  int? userId;
  String? name;
  String? source;
  String? industry;
  String? companyName;
  String? address;
  String? country;
  String? state;
  String? city;
  String? area;
  String? pincode;
  String? email;
  String? contact;
  String? whatsappNumber;
  String? createdAt;
  String? updatedAt;
  List<VisitLogs>? visitLogs;

  Data(
      {this.leadId,
        this.uuid,
        this.userId,
        this.name,
        this.source,
        this.industry,
        this.companyName,
        this.address,
        this.country,
        this.state,
        this.city,
        this.area,
        this.pincode,
        this.email,
        this.contact,
        this.whatsappNumber,
        this.createdAt,
        this.updatedAt,
        this.visitLogs});

  Data.fromJson(Map<String, dynamic> json) {
    leadId = json['lead_id'];
    uuid = json['uuid'];
    userId = json['user_id'];
    name = json['name'];
    source = json['source'];
    industry = json['industry'];
    companyName = json['company_name'];
    address = json['address'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    area = json['area'];
    pincode = json['pincode'];
    email = json['email'];
    contact = json['contact'];
    whatsappNumber = json['whatsapp_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['visit_logs'] != null) {
      visitLogs = <VisitLogs>[];
      json['visit_logs'].forEach((v) {
        visitLogs!.add(new VisitLogs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lead_id'] = leadId;
    data['uuid'] = uuid;
    data['user_id'] = userId;
    data['name'] = name;
    data['source'] = source;
    data['industry'] = industry;
    data['company_name'] = companyName;
    data['address'] = address;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['area'] = area;
    data['pincode'] = pincode;
    data['email'] = email;
    data['contact'] = contact;
    data['whatsapp_number'] = whatsappNumber;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (visitLogs != null) {
      data['visit_logs'] = visitLogs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VisitLogs {
  int? id;
  String? uuid;
  int? leadId;
  int? userId;
  String? leadType;
  String? rating;
  String? visitDate;
  String? visitStartTime;
  String? visitStartLatitude;
  String? visitStartLongitude;
  String? visitStartLocationName;
  String? visitEndTime;
  String? visitEndLatitude;
  String? visitEndLongitude;
  String? visitEndLocationName;
  String? notes;
  String? presentedProducts;
  String? createdAt;
  String? updatedAt;
  List<Null>? images;

  VisitLogs(
      {this.id,
        this.uuid,
        this.leadId,
        this.userId,
        this.leadType,
        this.rating,
        this.visitDate,
        this.visitStartTime,
        this.visitStartLatitude,
        this.visitStartLongitude,
        this.visitStartLocationName,
        this.visitEndTime,
        this.visitEndLatitude,
        this.visitEndLongitude,
        this.visitEndLocationName,
        this.notes,
        this.presentedProducts,
        this.createdAt,
        this.updatedAt,
        this.images});

  VisitLogs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    leadId = json['lead_id'];
    userId = json['user_id'];
    leadType = json['lead_type'];
    rating = json['rating'];
    visitDate = json['visit_date'];
    visitStartTime = json['visit_start_time'];
    visitStartLatitude = json['visit_start_latitude'];
    visitStartLongitude = json['visit_start_longitude'];
    visitStartLocationName = json['visit_start_location_name'];
    visitEndTime = json['visit_end_time'];
    visitEndLatitude = json['visit_end_latitude'];
    visitEndLongitude = json['visit_end_longitude'];
    visitEndLocationName = json['visit_end_location_name'];
    notes = json['notes'];
    presentedProducts = json['presented_products'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // if (json['images'] != null) {
    //   images = <Null>[];
    //   json['images'].forEach((v) {
    //     images!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['uuid'] = uuid;
    data['lead_id'] = leadId;
    data['user_id'] = userId;
    data['lead_type'] = leadType;
    data['rating'] = rating;
    data['visit_date'] = visitDate;
    data['visit_start_time'] = visitStartTime;
    data['visit_start_latitude'] = visitStartLatitude;
    data['visit_start_longitude'] = visitStartLongitude;
    data['visit_start_location_name'] = visitStartLocationName;
    data['visit_end_time'] = visitEndTime;
    data['visit_end_latitude'] = visitEndLatitude;
    data['visit_end_longitude'] = visitEndLongitude;
    data['visit_end_location_name'] = visitEndLocationName;
    data['notes'] = notes;
    data['presented_products'] = presentedProducts;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    // if (this.images != null) {
    //   data['images'] = this.images!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
