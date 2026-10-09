import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

String hash(String p) => 'hashed_$p';
String genId()=> DateTime.now().millisecondsSinceEpoch.toString() + (1000+ ( DateTime.now().microsecond%9000)).toString();

class AppProvider extends ChangeNotifier {
  bool initialized=false;
  UserModel? currentUser;
  AgencyModel? currentAgency;
  String? role; // user / agency
  List<UserModel> users=[];
  List<AgencyModel> agencies=[];
  List<VisaModel> visas=[];
  List<ApplicationModel> applications=[];
  List<NotificationModel> notifications=[];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('job_opportunity_v3');
    if(raw!=null){
      try{
        final d=jsonDecode(raw);
        users=(d['users'] as List).map((e)=>UserModel.fromJson(e)).toList();
        agencies=(d['agencies'] as List).map((e)=>AgencyModel.fromJson(e)).toList();
        visas=(d['visas'] as List).map((e)=>VisaModel.fromJson(e)).toList();
        applications=(d['applications'] as List).map((e)=>ApplicationModel.fromJson(e)).toList();
        notifications=(d['notifications'] as List).map((e)=>NotificationModel.fromJson(e)).toList();
        if(d['currentUser']!=null) currentUser=UserModel.fromJson(d['currentUser']);
        if(d['currentAgency']!=null) currentAgency=AgencyModel.fromJson(d['currentAgency']);
        role=d['role'];
      }catch(e){ await _seed();}
    } else {
      await _seed();
    }
    initialized=true; notifyListeners();
  }

  Future<void> _seed() async {
    users=[UserModel(id:'u1', name:'أحمد محمد', email:'user@test.com', phone:'+201111111111', country:'مصر', city:'القاهرة', password:hash('123456'), createdAt:DateTime.now().toIso8601String())];
    agencies=[
      AgencyModel(id:'ag1', name:'وكالة النخبة للتوظيف', email:'agency@test.com', phone:'+966500000001', country:'السعودية', city:'الرياض', address:'الرياض - العليا', password:hash('123456'), description:'وكالة رائدة في توفير فرص العمل والخدمات والتأشيرات لدول الخليج وأوروبا.', rating:4.8, reviewsCount:124, createdAt:DateTime.now().toIso8601String()),
      AgencyModel(id:'ag2', name:'وكالة السفر الذهبي', email:'gold@test.com', phone:'+971500000002', country:'الإمارات', city:'دبي', address:'دبي - ديرة', password:hash('123456'), description:'متخصصون في تأشيرات العمل والسياحة.', rating:4.6, reviewsCount:89, createdAt:DateTime.now().toIso8601String()),
      AgencyModel(id:'ag3', name:'وكالة المستقبل', email:'future@test.com', phone:'+201000000003', country:'مصر', city:'القاهرة', address:'القاهرة - وسط البلد', password:hash('123456'), description:'نخدم الباحثين عن فرص عمل بالخارج منذ 2010.', rating:4.5, reviewsCount:67, createdAt:DateTime.now().toIso8601String()),
    ];
    visas=[
      VisaModel(id:'v1', agencyId:'ag1', title:'تأشيرة عمل سائق خاص - السعودية', country:'السعودية', visaType:'عمل', jobTitle:'سائق', description:'فرصة عمل مميزة كسائق خاص لعائلة سعودية براتب مجزي وسكن وتأمين صحي وإجازة سنوية.', requirements:'رخصة قيادة سارية، حسن السير والسلوك، خبرة سنتين', documents:'جواز سفر - صورة شخصية - رخصة - فيش جنائي', ageRequired:'25-45', qualification:'بدون مؤهل', experience:'سنتان', salary:'2500', currency:'SAR', contractDuration:'سنتان', visaDuration:'سنتان', price:'15000', seats:5, expiryDate:DateTime.now().add(const Duration(days:30)).toIso8601String(), status:'active', createdAt:DateTime.now().toIso8601String()),
      VisaModel(id:'v2', agencyId:'ag1', title:'مطلوب ممرضين للعمل بالرياض', country:'السعودية', visaType:'عمل', jobTitle:'ممرض', description:'مستشفى خاص بالرياض يطلب ممرضين بمرتبات عالية وسكن.', requirements:'بكالوريوس تمريض + مزاولة', documents:'شهادة - مزاولة - جواز سفر', ageRequired:'23-40', qualification:'بكالوريوس', experience:'3 سنوات', salary:'5000', currency:'SAR', contractDuration:'سنتان', visaDuration:'سنتان', price:'8000', seats:10, expiryDate:DateTime.now().add(const Duration(days:45)).toIso8601String(), status:'active', createdAt:DateTime.now().toIso8601String()),
      VisaModel(id:'v3', agencyId:'ag2', title:'تأشيرة سياحة الإمارات 30 يوم', country:'الإمارات', visaType:'سياحة', jobTitle:'سياحة', description:'تأشيرة سياحة سريعة للإمارات خلال 48 ساعة.', requirements:'جواز سفر صالح 6 أشهر', documents:'جواز سفر + صورة', ageRequired:'18-60', qualification:'بدون مؤهل', experience:'بدون', salary:'-', currency:'AED', contractDuration:'-', visaDuration:'30 يوم', price:'1500', seats:50, expiryDate:DateTime.now().add(const Duration(days:20)).toIso8601String(), status:'active', createdAt:DateTime.now().toIso8601String()),
      VisaModel(id:'v4', agencyId:'ag2', title:'فرصة عمل مهندس مدني - دبي', country:'الإمارات', visaType:'عمل', jobTitle:'مهندس مدني', description:'شركة مقاولات كبرى بدبي تطلب مهندسين.', requirements:'خبرة 5 سنوات - أوتوكاد', documents:'سيرة ذاتية - شهادات', ageRequired:'28-45', qualification:'بكالوريوس', experience:'5 سنوات', salary:'8000', currency:'AED', contractDuration:'3 سنوات', visaDuration:'سنتان', price:'12000', seats:3, expiryDate:DateTime.now().add(const Duration(days:60)).toIso8601String(), status:'active', createdAt:DateTime.now().toIso8601String()),
      VisaModel(id:'v5', agencyId:'ag3', title:'تأشيرة عمل إيطاليا - عامل زراعي', country:'إيطاليا', visaType:'عمل', jobTitle:'عامل زراعي', description:'موسم حصاد بإيطاليا براتب مميز.', requirements:'لياقة بدنية', documents:'جواز سفر - فيش', ageRequired:'22-45', qualification:'بدون مؤهل', experience:'سنة', salary:'1200', currency:'EUR', contractDuration:'9 أشهر', visaDuration:'9 أشهر', price:'25000', seats:20, expiryDate:DateTime.now().add(const Duration(days:25)).toIso8601String(), status:'active', createdAt:DateTime.now().toIso8601String()),
    ];
    applications=[]; notifications=[]; await persist();
  }

  Future<void> persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('job_opportunity_v3', jsonEncode({
      'users': users.map((e)=>e.toJson()).toList(),
      'agencies': agencies.map((e)=>e.toJson()).toList(),
      'visas': visas.map((e)=>e.toJson()).toList(),
      'applications': applications.map((e)=>e.toJson()).toList(),
      'notifications': notifications.map((e)=>e.toJson()).toList(),
      'currentUser': currentUser?.toJson(),
      'currentAgency': currentAgency?.toJson(),
      'role': role,
    }));
  }

  // Auth
  String? loginUser(String email,String pass){
    try{ final u=users.firstWhere((x)=>x.email.toLowerCase()==email.toLowerCase()); if(u.password!=hash(pass)) return 'كلمة المرور غير صحيحة'; currentUser=u; currentAgency=null; role='user'; persist(); notifyListeners(); return null; }catch(e){return 'البريد غير مسجل';}
  }
  String? loginAgency(String email,String pass){
    try{ final a=agencies.firstWhere((x)=>x.email.toLowerCase()==email.toLowerCase()); if(a.password!=hash(pass)) return 'كلمة المرور غير صحيحة'; currentAgency=a; currentUser=null; role='agency'; persist(); notifyListeners(); return null; }catch(e){return 'البريد غير مسجل';}
  }
  String? registerUser(Map<String,String> d){
    if(users.any((u)=>u.email.toLowerCase()==d['email']!.toLowerCase())|| agencies.any((a)=>a.email.toLowerCase()==d['email']!.toLowerCase())) return 'البريد مسجل مسبقاً';
    final u=UserModel(id:genId(), name:d['name']!, email:d['email']!, phone:d['phone']!, country:d['country']!, city:d['city']!, password:hash(d['password']!), createdAt:DateTime.now().toIso8601String());
    users.add(u); currentUser=u; role='user'; currentAgency=null; persist(); notifyListeners(); return null;
  }
  String? registerAgency(Map<String,String> d){
    if(agencies.any((a)=>a.email.toLowerCase()==d['email']!.toLowerCase())|| users.any((u)=>u.email.toLowerCase()==d['email']!.toLowerCase())) return 'البريد مسجل مسبقاً';
    final a=AgencyModel(id:genId(), name:d['name']!, email:d['email']!, phone:d['phone']!, country:d['country']??'غير محدد', city:d['city']!, address:d['address']!, password:hash(d['password']!), description:d['description']??'', certificateName:d['certificateName'], certificatePath:d['certificatePath'], rating:5, reviewsCount:0, createdAt:DateTime.now().toIso8601String());
    agencies.add(a); currentAgency=a; role='agency'; currentUser=null; persist(); notifyListeners(); return null;
  }
  Future<void> logout() async { currentUser=null; currentAgency=null; role=null; await persist(); notifyListeners(); }

  // Visas
  void addVisa(VisaModel v){ visas.insert(0, v); persist(); notifyListeners(); }
  void updateVisa(String id, VisaModel updated){ final i=visas.indexWhere((e)=>e.id==id); if(i!=-1){visas[i]=updated; persist(); notifyListeners();}}
  void deleteVisa(String id){ visas.removeWhere((e)=>e.id==id); persist(); notifyListeners();}
  // Applications
  String? applyToVisa(String visaId){
    if(currentUser==null) return 'سجل دخول أولاً';
    if(applications.any((a)=>a.visaId==visaId && a.userId==currentUser!.id)) return 'لقد تقدمت لهذا العرض مسبقاً';
    final visa=visas.firstWhere((v)=>v.id==visaId);
    final ag=agencies.firstWhere((a)=>a.id==visa.agencyId);
    final app=ApplicationModel(id:genId(), visaId:visaId, agencyId:visa.agencyId, userId:currentUser!.id, userName:currentUser!.name, userPhone:currentUser!.phone, userEmail:currentUser!.email, visaTitle:visa.title, agencyName:ag.name, status:'جديد', createdAt:DateTime.now().toIso8601String());
    applications.insert(0, app);
    addNotification(NotificationModel(id:genId(), userId:visa.agencyId, role:'agency', title:'طلب جديد', body:'تقدم ${currentUser!.name} على عرض ${visa.title}', createdAt:DateTime.now().toIso8601String()));
    persist(); notifyListeners(); return null;
  }
  void updateApplicationStatus(String appId,String status){
    final idx=applications.indexWhere((a)=>a.id==appId); if(idx==-1) return;
    applications[idx]=ApplicationModel(id:applications[idx].id, visaId:applications[idx].visaId, agencyId:applications[idx].agencyId, userId:applications[idx].userId, userName:applications[idx].userName, userPhone:applications[idx].userPhone, userEmail:applications[idx].userEmail, visaTitle:applications[idx].visaTitle, agencyName:applications[idx].agencyName, status:status, createdAt:applications[idx].createdAt);
    final app=applications[idx];
    addNotification(NotificationModel(id:genId(), userId:app.userId, role:'user', title: status=='مقبول'?'تم قبول طلبك': status=='مرفوض'?'تم رفض طلبك':'تحديث الطلب', body:'حالة طلبك لعرض ${app.visaTitle} أصبحت: $status', createdAt:DateTime.now().toIso8601String()));
    persist(); notifyListeners();
  }
  void addNotification(NotificationModel n){ notifications.insert(0,n); persist(); notifyListeners();}
  void markRead(String id){ final i=notifications.indexWhere((e)=>e.id==id); if(i!=-1){notifications[i].read=true; persist(); notifyListeners();}}
  void updateUserProfile(Map<String,String> d){ if(currentUser==null) return; currentUser!.name=d['name']??currentUser!.name; currentUser!.phone=d['phone']??currentUser!.phone; currentUser!.city=d['city']??currentUser!.city; if(d['country']!=null) currentUser!.country=d['country']!; if(d['avatarPath']!=null) currentUser!.avatarPath=d['avatarPath']; if(d['cvName']!=null) currentUser!.cvName=d['cvName']; if(d['cvPath']!=null) currentUser!.cvPath=d['cvPath']; if(d['extraInfo']!=null) currentUser!.extraInfo=d['extraInfo']; final idx=users.indexWhere((u)=>u.id==currentUser!.id); if(idx!=-1) users[idx]=currentUser!; persist(); notifyListeners();}
  void updateAgencyProfile(Map<String,String> d){ if(currentAgency==null) return; currentAgency!.name=d['name']??currentAgency!.name; currentAgency!.phone=d['phone']??currentAgency!.phone; currentAgency!.city=d['city']??currentAgency!.city; currentAgency!.address=d['address']??currentAgency!.address; currentAgency!.description=d['description']??currentAgency!.description; if(d['logo']!=null && d['logo']!.isNotEmpty) currentAgency!.logo=d['logo']; final idx=agencies.indexWhere((a)=>a.id==currentAgency!.id); if(idx!=-1) agencies[idx]=currentAgency!; persist(); notifyListeners();}

  List<VisaModel> searchVisas(String query, {String? country, String? visaType, String? sort}){
    var list = visas.where((v)=>v.status=='active').toList();
    if(query.isNotEmpty){
      final q=query.toLowerCase();
      list=list.where((v){
        final ag=agencies.firstWhere((a)=>a.id==v.agencyId, orElse:()=>agencies.first);
        return v.title.toLowerCase().contains(q) || v.country.toLowerCase().contains(q) || v.jobTitle.toLowerCase().contains(q) || ag.name.toLowerCase().contains(q);
      }).toList();
    }
    if(country!=null && country.isNotEmpty && country!='الكل') list=list.where((v)=>v.country==country).toList();
    if(visaType!=null && visaType.isNotEmpty && visaType!='الكل') list=list.where((v)=>v.visaType==visaType).toList();
    if(sort=='الأحدث') list.sort((a,b)=>b.createdAt.compareTo(a.createdAt));
    else if(sort=='الأقل سعرًا') list.sort((a,b)=> int.parse(a.price.replaceAll(RegExp(r'[^0-9]'),'') ).compareTo(int.parse(b.price.replaceAll(RegExp(r'[^0-9]'),''))));
    else if(sort=='الأعلى راتبًا') list.sort((a,b)=> int.parse(b.salary.replaceAll(RegExp(r'[^0-9]'),'') ).compareTo(int.parse(a.salary.replaceAll(RegExp(r'[^0-9]'),''))));
    return list;
  }
}
