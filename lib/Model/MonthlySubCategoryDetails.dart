class MonthlySubCategoryDetails {
  bool? status;
  String? message;
  List<Data>? data;

  MonthlySubCategoryDetails({this.status, this.message, this.data});

  MonthlySubCategoryDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sfid;
  String? name;

  Data({this.sfid, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    sfid = json['sfid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sfid'] = this.sfid;
    data['name'] = this.name;
    return data;
  }
}

class SubCategory {
  final String? sfid;
  final String? name;

  SubCategory({this.sfid, this.name});
}