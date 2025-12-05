class GetLeadsModel {
  bool? status;
  String? message;
  List<Data>? data;

  GetLeadsModel({this.status, this.message, this.data});

  GetLeadsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  num? leadId;
  String? uuid;
  num? userId;
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
        this.updatedAt});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    return data;
  }
}