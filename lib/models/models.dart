class UserModel {
  String id, name, email, phone, country, city, password;
  String? avatar;
  String? avatarPath;
  String? cvName;
  String? cvPath;
  String? extraInfo;
  String createdAt;
  UserModel({required this.id, required this.name, required this.email, required this.phone, required this.country, required this.city, required this.password, this.avatar, this.avatarPath, this.cvName, this.cvPath, this.extraInfo, required this.createdAt});
  Map<String,dynamic> toJson()=>{'id':id,'name':name,'email':email,'phone':phone,'country':country,'city':city,'password':password,'avatar':avatar,'avatarPath':avatarPath,'cvName':cvName,'cvPath':cvPath,'extraInfo':extraInfo,'createdAt':createdAt};
  factory UserModel.fromJson(Map<String,dynamic> j)=>UserModel(id:j['id'],name:j['name'],email:j['email'],phone:j['phone'],country:j['country'],city:j['city'],password:j['password'],avatar:j['avatar'],avatarPath:j['avatarPath'],cvName:j['cvName'],cvPath:j['cvPath'],extraInfo:j['extraInfo'],createdAt:j['createdAt']);
}
class AgencyModel {
  String id, name, email, phone, country, city, address, password, description;
  String? logo;
  String? certificateName;
  String? certificatePath;
  double rating; int reviewsCount; String createdAt;
  AgencyModel({required this.id, required this.name, required this.email, required this.phone, required this.country, required this.city, required this.address, required this.password, required this.description, this.logo, this.certificateName, this.certificatePath, this.rating=5, this.reviewsCount=0, required this.createdAt});
  Map<String,dynamic> toJson()=>{'id':id,'name':name,'email':email,'phone':phone,'country':country,'city':city,'address':address,'password':password,'description':description,'logo':logo,'certificateName':certificateName,'certificatePath':certificatePath,'rating':rating,'reviewsCount':reviewsCount,'createdAt':createdAt};
  factory AgencyModel.fromJson(Map<String,dynamic> j)=>AgencyModel(id:j['id'],name:j['name'],email:j['email'],phone:j['phone'],country:j['country'],city:j['city'],address:j['address'],password:j['password'],description:j['description'],logo:j['logo'],certificateName:j['certificateName'],certificatePath:j['certificatePath'],rating:(j['rating'] as num).toDouble(),reviewsCount:j['reviewsCount'],createdAt:j['createdAt']);
}
class VisaModel {
  String id, agencyId, title, country, visaType, jobTitle, description, requirements, documents, ageRequired, qualification, experience, salary, currency, contractDuration, visaDuration, price, expiryDate, createdAt, status;
  int seats; List<String> images;
  VisaModel({required this.id, required this.agencyId, required this.title, required this.country, required this.visaType, required this.jobTitle, required this.description, required this.requirements, required this.documents, required this.ageRequired, required this.qualification, required this.experience, required this.salary, required this.currency, required this.contractDuration, required this.visaDuration, required this.price, required this.seats, required this.expiryDate, this.images=const [], required this.status, required this.createdAt});
  Map<String,dynamic> toJson()=>{'id':id,'agencyId':agencyId,'title':title,'country':country,'visaType':visaType,'jobTitle':jobTitle,'description':description,'requirements':requirements,'documents':documents,'ageRequired':ageRequired,'qualification':qualification,'experience':experience,'salary':salary,'currency':currency,'contractDuration':contractDuration,'visaDuration':visaDuration,'price':price,'seats':seats,'expiryDate':expiryDate,'images':images,'status':status,'createdAt':createdAt};
  factory VisaModel.fromJson(Map<String,dynamic> j)=>VisaModel(id:j['id'],agencyId:j['agencyId'],title:j['title'],country:j['country'],visaType:j['visaType'],jobTitle:j['jobTitle'],description:j['description'],requirements:j['requirements'],documents:j['documents'],ageRequired:j['ageRequired'],qualification:j['qualification'],experience:j['experience'],salary:j['salary'],currency:j['currency'],contractDuration:j['contractDuration'],visaDuration:j['visaDuration'],price:j['price'],seats:j['seats'],expiryDate:j['expiryDate'],images:List<String>.from(j['images']??[]),status:j['status'],createdAt:j['createdAt']);
}
class ApplicationModel {
  String id, visaId, agencyId, userId, userName, userPhone, userEmail, visaTitle, agencyName, status, createdAt;
  ApplicationModel({required this.id, required this.visaId, required this.agencyId, required this.userId, required this.userName, required this.userPhone, required this.userEmail, required this.visaTitle, required this.agencyName, required this.status, required this.createdAt});
  Map<String,dynamic> toJson()=>{'id':id,'visaId':visaId,'agencyId':agencyId,'userId':userId,'userName':userName,'userPhone':userPhone,'userEmail':userEmail,'visaTitle':visaTitle,'agencyName':agencyName,'status':status,'createdAt':createdAt};
  factory ApplicationModel.fromJson(Map<String,dynamic> j)=>ApplicationModel(id:j['id'],visaId:j['visaId'],agencyId:j['agencyId'],userId:j['userId'],userName:j['userName'],userPhone:j['userPhone'],userEmail:j['userEmail'],visaTitle:j['visaTitle'],agencyName:j['agencyName'],status:j['status'],createdAt:j['createdAt']);
}
class NotificationModel {
  String id, userId, role, title, body, createdAt; bool read; String? relatedId;
  NotificationModel({required this.id, required this.userId, required this.role, required this.title, required this.body, required this.createdAt, this.read=false, this.relatedId});
  Map<String,dynamic> toJson()=>{'id':id,'userId':userId,'role':role,'title':title,'body':body,'createdAt':createdAt,'read':read,'relatedId':relatedId};
  factory NotificationModel.fromJson(Map<String,dynamic> j)=>NotificationModel(id:j['id'],userId:j['userId'],role:j['role'],title:j['title'],body:j['body'],createdAt:j['createdAt'],read:j['read']??false,relatedId:j['relatedId']);
}
