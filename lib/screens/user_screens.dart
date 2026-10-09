import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../widgets/common.dart';
import '../services/app_provider.dart';
import '../models/models.dart';

class UserShell extends StatefulWidget { const UserShell({super.key}); @override State<UserShell> createState()=>_UserShellState();}
class _UserShellState extends State<UserShell>{
  int idx=0;
  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>();
    if(p.currentUser==null) return const Scaffold(body: Center(child: Text('غير مسجل')));
    final pages=[const UserHomeScreen(), const UserSearchScreen(), const UserAgenciesScreen(), const UserApplicationsScreen(), const UserProfileScreen()];
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(currentIndex: idx, onTap:(i)=> setState(()=> idx=i), type: BottomNavigationBarType.fixed, selectedItemColor: AppColors.accent, unselectedItemColor: AppColors.textLight, items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label:'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label:'البحث'),
        BottomNavigationBarItem(icon: Icon(Icons.business), label:'الوكالات'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label:'طلباتي'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label:'حسابي'),
      ]),
    );
  }
}

// helpers for visa detail
Widget chipWidget(String t)=> Container(padding: const EdgeInsets.symmetric(horizontal:10, vertical:6), decoration: BoxDecoration(color: AppColors.muted, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)), child: Text(t, style: const TextStyle(fontSize:12, fontWeight: FontWeight.w700)));
Widget rowWidget(String k,String v)=> Padding(padding: const EdgeInsets.symmetric(vertical:4), child: Row(children:[Text('$k: ', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)), Expanded(child: Text(v, style: const TextStyle(color: AppColors.textLight)))]));

class UserHomeScreen extends StatefulWidget { const UserHomeScreen({super.key}); @override State<UserHomeScreen> createState()=>_HomeState();}
class _HomeState extends State<UserHomeScreen>{
  String query=''; String country='الكل'; String visaType='الكل'; String sort='الأحدث';
  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>();
    final visas=p.searchVisas(query, country:country, visaType:visaType, sort:sort);
    return Scaffold(backgroundColor: AppColors.bg, appBar: AppBar(title: const Text('Job Opportunity'), actions:[IconButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const UserNotificationsScreen())), icon: const Icon(Icons.notifications_none))]),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        TextField(onChanged:(v)=> setState(()=> query=v), decoration: fieldDecoration('ابحث عن تأشيرة أو وظيفة...').copyWith(prefixIcon: const Icon(Icons.search), filled:true)),
        const SizedBox(height:10),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children:[
          _filterChip('الدولة: $country', ()=> _pickCountry()),
          const SizedBox(width:6),
          _filterChip('النوع: $visaType', ()=> _pickType()),
          const SizedBox(width:6),
          _filterChip('ترتيب: $sort', ()=> _pickSort()),
        ])),
        const SizedBox(height:12),
        Row(children:[const Text('العروض المتاحة', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)), const Spacer(), Text('${visas.length} عرض', style: const TextStyle(color: AppColors.textLight, fontSize:12))]),
        const SizedBox(height:8),
        if(visas.isEmpty) const Padding(padding: EdgeInsets.all(30), child: Center(child: Text('لا توجد نتائج', style: TextStyle(color: AppColors.textLight)))),
        ...visas.map((v){
          final ag=p.agencies.firstWhere((a)=>a.id==v.agencyId);
          return InkWell(onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> UserVisaDetailScreen(visa: v))), child: AppCard(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
            Row(children:[
              Container(width:44,height:44, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)), child: Center(child: Text(ag.name.substring(0,2), style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w800, fontSize:12)))),
              const SizedBox(width:10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
                Text(v.title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize:13)),
                Text('${ag.name} • ${v.country}', style: const TextStyle(color: AppColors.textLight, fontSize:11)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:4), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)), child: Text(v.visaType, style: const TextStyle(fontSize:11, color: AppColors.accent, fontWeight: FontWeight.w700))),
            ]),
            const SizedBox(height:10),
            Text(v.description, maxLines:2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textLight, fontSize:12, height:1.5)),
            const SizedBox(height:10),
            Wrap(spacing:6, runSpacing:6, children:[
              _badge('💼 ${v.jobTitle}'), _badge('💰 ${v.salary} ${v.currency}'), _badge('💳 ${v.price} ${v.currency}'), _badge('🪑 ${v.seats}'),
            ]),
          ])));
        }),
        const SizedBox(height:12),
        const Text('الوكالات المميزة', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)),
        const SizedBox(height:8),
        SizedBox(
          height: 182,
          child: ListView(scrollDirection: Axis.horizontal, children: p.agencies.take(5).map((ag)=> InkWell(onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> AgencyDetailScreen(agency: ag))), child: Container(width:160, margin: const EdgeInsets.only(left:8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)), child: Column(mainAxisSize: MainAxisSize.min, children:[
            Container(width:48,height:48, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)), child: Center(child: Text(ag.name.substring(0,2), style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w800)))),
            const SizedBox(height:6), Text(ag.name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize:12)), Text('${ag.city} • ${ag.country}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textLight, fontSize:10)), const SizedBox(height:4), Row(mainAxisAlignment: MainAxisAlignment.center, children:[const Icon(Icons.star, size:12, color: Colors.amber), Text(' ${ag.rating}', style: const TextStyle(fontSize:11, fontWeight: FontWeight.w700)), Text(' (${ag.reviewsCount})', style: const TextStyle(fontSize:10, color: AppColors.textLight))]),
            const SizedBox(height:8), Container(padding: const EdgeInsets.symmetric(horizontal:10, vertical:6), decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(8)), child: const Text('عرض الوكالة', style: TextStyle(color:Colors.white, fontSize:10, fontWeight: FontWeight.w800))),
          ])))).toList()),
        ),
        const Footer(),
      ])),
    );
  }
  Widget _filterChip(String t, VoidCallback onTap)=> InkWell(onTap:onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal:12, vertical:8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)), child: Text(t, style: const TextStyle(fontSize:12, fontWeight: FontWeight.w600))));
  Widget _badge(String t)=> Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:4), decoration: BoxDecoration(color: AppColors.muted, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)), child: Text(t, style: const TextStyle(fontSize:11, fontWeight: FontWeight.w600)));
  void _pickCountry(){ showModalBottomSheet(context: context, builder: (_)=> ListView(children: ['الكل',...countries].map((c)=> ListTile(title: Text(c), onTap: (){ setState(()=> country=c); Navigator.pop(context);})).toList()));}
  void _pickType(){ showModalBottomSheet(context: context, builder: (_)=> ListView(children: ['الكل',...visaTypes].map((c)=> ListTile(title: Text(c), onTap: (){ setState(()=> visaType=c); Navigator.pop(context);})).toList()));}
  void _pickSort(){ showModalBottomSheet(context: context, builder: (_)=> ListView(children: ['الأحدث','الأقل سعرًا','الأعلى راتبًا'].map((c)=> ListTile(title: Text(c), onTap: (){ setState(()=> sort=c); Navigator.pop(context);})).toList()));}
}

class UserSearchScreen extends StatefulWidget { const UserSearchScreen({super.key}); @override State<UserSearchScreen> createState()=>_SearchState();}
class _SearchState extends State<UserSearchScreen>{
  String query=''; String country='الكل'; String visaType='الكل'; String sort='الأحدث';
  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>();
    final visas=p.searchVisas(query, country:country, visaType:visaType, sort:sort);
    return Scaffold(appBar: AppBar(title: const Text('البحث والفلترة')), body: Column(children:[
      Padding(padding: const EdgeInsets.all(16), child: Column(children:[
        TextField(onChanged:(v)=> setState(()=> query=v), decoration: fieldDecoration('ابحث باسم التأشيرة، الدولة، الوظيفة، الوكالة').copyWith(prefixIcon: const Icon(Icons.search))),
        const SizedBox(height:10),
        Row(children:[
          Expanded(child: DropdownButtonFormField(value: country, decoration: fieldDecoration('الدولة'), items: ['الكل',...countries].map((e)=> DropdownMenuItem(value:e, child: Text(e, style: const TextStyle(fontSize:13)))).toList(), onChanged:(v)=> setState(()=> country=v!))),
          const SizedBox(width:8),
          Expanded(child: DropdownButtonFormField(value: visaType, decoration: fieldDecoration('النوع'), items: ['الكل',...visaTypes].map((e)=> DropdownMenuItem(value:e, child: Text(e))).toList(), onChanged:(v)=> setState(()=> visaType=v!))),
        ]),
        const SizedBox(height:8),
        DropdownButtonFormField(value: sort, decoration: fieldDecoration('الترتيب'), items: const [DropdownMenuItem(value:'الأحدث', child: Text('الأحدث')), DropdownMenuItem(value:'الأقل سعرًا', child: Text('الأقل سعرًا')), DropdownMenuItem(value:'الأعلى راتبًا', child: Text('الأعلى راتبًا'))], onChanged:(v)=> setState(()=> sort=v!)),
      ])),
      Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal:16), itemCount: visas.length, itemBuilder: (_,i){
        final v=visas[i]; final ag=p.agencies.firstWhere((a)=>a.id==v.agencyId);
        return InkWell(onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> UserVisaDetailScreen(visa: v))), child: AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(v.title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)), Text('${ag.name} • ${v.country} • ${v.jobTitle}', style: const TextStyle(color: AppColors.textLight, fontSize:12)), const SizedBox(height:6), Text('${v.salary} ${v.currency} • ${v.price} ${v.currency}', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.accent, fontSize:12))])) );
      })),
    ]));
  }
}

class UserAgenciesScreen extends StatelessWidget { const UserAgenciesScreen({super.key}); @override Widget build(BuildContext context){
  final p=context.watch<AppProvider>();
  return Scaffold(appBar: AppBar(title: const Text('الوكالات')), body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: p.agencies.length, itemBuilder: (_,i){
    final ag=p.agencies[i]; final count=p.visas.where((v)=>v.agencyId==ag.id).length;
    return AppCard(child: Column(children:[
      Row(children:[
        Container(width:52,height:52, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)), child: Center(child: Text(ag.name.substring(0,2), style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w900)))),
        const SizedBox(width:12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
          Text(ag.name, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
          Text('${ag.country} • ${ag.city}', style: const TextStyle(color: AppColors.textLight, fontSize:12)),
          Row(children:[const Icon(Icons.star, size:14, color: Colors.amber), Text(' ${ag.rating} (${ag.reviewsCount}) • $count عروض', style: const TextStyle(fontSize:11, color: AppColors.textLight))]),
        ])),
      ]),
      const SizedBox(height:8), Text(ag.description, maxLines:2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textLight, fontSize:12)),
      const SizedBox(height:10),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> AgencyDetailScreen(agency: ag))), style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent), child: const Text('عرض الوكالة', style: TextStyle(color:Colors.white)))),
    ]));
  }));
}}

class AgencyDetailScreen extends StatelessWidget { final AgencyModel agency; const AgencyDetailScreen({super.key, required this.agency}); @override Widget build(BuildContext context){
  final p=context.watch<AppProvider>(); final visas=p.visas.where((v)=>v.agencyId==agency.id).toList();
  return Scaffold(appBar: AppBar(title: Text(agency.name)), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
    AppCard(child: Column(children:[
      Container(width:72,height:72, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)), child: Center(child: Text(agency.name.substring(0,2), style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w900, fontSize:20)))),
      const SizedBox(height:10), Text(agency.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize:18, color: AppColors.primary)),
      Text('${agency.country} • ${agency.city}', style: const TextStyle(color: AppColors.textLight)),
      const SizedBox(height:6), Row(mainAxisAlignment: MainAxisAlignment.center, children:[const Icon(Icons.star, color: Colors.amber, size:18), Text(' ${agency.rating} (${agency.reviewsCount} تقييم)', style: const TextStyle(fontWeight: FontWeight.w700))]),
      const SizedBox(height:8), Text(agency.description, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textLight, height:1.5)),
      const SizedBox(height:12), Row(children:[Expanded(child: _info(Icons.phone, agency.phone)), Expanded(child: _info(Icons.email, agency.email))]),
    ])),
    const SizedBox(height:12),
    const Text('العروض المتاحة', style: TextStyle(fontWeight: FontWeight.w900, fontSize:16, color: AppColors.primary)),
    const SizedBox(height:8),
    ...visas.map((v)=> InkWell(onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> UserVisaDetailScreen(visa: v))), child: AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(v.title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)), Text('${v.country} • ${v.jobTitle} • ${v.salary} ${v.currency}', style: const TextStyle(color: AppColors.textLight, fontSize:12)), const SizedBox(height:6), Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:4), decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(8)), child: const Text('عرض التفاصيل', style: TextStyle(color:Colors.white, fontSize:11)))])))),
    if(visas.isEmpty) const Padding(padding: EdgeInsets.all(20), child: Center(child: Text('لا توجد عروض حالياً'))),
    const Footer(),
  ])));
}
  Widget _info(IconData icon,String t)=> Row(mainAxisAlignment: MainAxisAlignment.center, children:[Icon(icon, size:14, color: AppColors.accent), const SizedBox(width:4), Flexible(child: Text(t, style: const TextStyle(fontSize:11), overflow: TextOverflow.ellipsis))]);
}

class UserVisaDetailScreen extends StatelessWidget { final VisaModel visa; const UserVisaDetailScreen({super.key, required this.visa}); @override Widget build(BuildContext context){
  final p=context.watch<AppProvider>(); final ag=p.agencies.firstWhere((a)=>a.id==visa.agencyId);
  return Scaffold(appBar: AppBar(title: const Text('تفاصيل العرض')), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
    AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
      Text(visa.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize:18, color: AppColors.primary)),
      const SizedBox(height:6), Text('${visa.country} • ${ag.name} • ${visa.visaType}', style: const TextStyle(color: AppColors.textLight)),
      const SizedBox(height:12),
      Wrap(spacing:8, runSpacing:8, children:[
        chipWidget('💼 ${visa.jobTitle}'), chipWidget('💰 ${visa.salary} ${visa.currency}'), chipWidget('💳 ${visa.price} ${visa.currency}'), chipWidget('🪑 ${visa.seats} مقاعد'), chipWidget('⏳ ${visa.contractDuration}'), chipWidget('📅 ${visa.visaDuration}'),
      ]),
      const SizedBox(height:14),
      rowWidget('العمر المطلوب', visa.ageRequired), rowWidget('المؤهل', visa.qualification), rowWidget('الخبرة', visa.experience), rowWidget('مدة العقد', visa.contractDuration), rowWidget('مدة التأشيرة', visa.visaDuration), rowWidget('عدد المقاعد', '${visa.seats}'), rowWidget('تاريخ الانتهاء', visa.expiryDate.substring(0,10)),
      const Divider(height:24),
      const Text('وصف العرض', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height:4), Text(visa.description, style: const TextStyle(color: AppColors.textLight, height:1.6)),
      const SizedBox(height:8), const Text('المتطلبات', style: TextStyle(fontWeight: FontWeight.w800)), Text(visa.requirements, style: const TextStyle(color: AppColors.textLight)),
      const SizedBox(height:8), const Text('المستندات المطلوبة', style: TextStyle(fontWeight: FontWeight.w800)), Text(visa.documents, style: const TextStyle(color: AppColors.textLight)),
      const SizedBox(height:8), const Text('الوكالة', style: TextStyle(fontWeight: FontWeight.w800)), Text('${ag.name} - ${ag.phone} - ${ag.email}', style: const TextStyle(color: AppColors.textLight)),
    ])),
    const SizedBox(height:12),
    SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){
      final err=p.applyToVisa(visa.id);
      if(err!=null){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err), backgroundColor: AppColors.danger)); } else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال طلبك بنجاح'), backgroundColor: AppColors.success)); }
    }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical:16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('التقديم على العرض', style: TextStyle(color:Colors.white, fontWeight: FontWeight.w900, fontSize:16)))),
    const SizedBox(height:8),
    SizedBox(width: double.infinity, child: OutlinedButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> AgencyDetailScreen(agency: ag))), child: const Text('عرض صفحة الوكالة'))),
    const Footer(),
  ])));
}}

class UserApplicationsScreen extends StatelessWidget { const UserApplicationsScreen({super.key}); @override Widget build(BuildContext context){
  final p=context.watch<AppProvider>(); final user=p.currentUser!; final apps=p.applications.where((a)=>a.userId==user.id).toList();
  return Scaffold(appBar: AppBar(title: const Text('طلباتي')), body: apps.isEmpty? const Center(child: Text('لم تقدم على أي عرض بعد')): ListView.builder(padding: const EdgeInsets.all(16), itemCount: apps.length, itemBuilder: (_,i){
    final a=apps[i];
    return AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
      Text(a.visaTitle, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
      Text(a.agencyName, style: const TextStyle(color: AppColors.textLight, fontSize:12)),
      const SizedBox(height:6),
      Row(children:[
        Container(padding: const EdgeInsets.symmetric(horizontal:10, vertical:4), decoration: BoxDecoration(color: a.status=="جديد"? const Color(0xFFEFF6FF): a.status=="قيد المراجعة"? const Color(0xFFFEF3C7): a.status=="مقبول"? const Color(0xFFECFDF5): const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(8)), child: Text(a.status, style: const TextStyle(fontWeight: FontWeight.w800, fontSize:12))),
        const Spacer(), Text(a.createdAt.substring(0,10), style: const TextStyle(color: AppColors.textLight, fontSize:11)),
      ]),
    ]));
  }));
}}

class UserProfileScreen extends StatefulWidget { const UserProfileScreen({super.key}); @override State<UserProfileScreen> createState()=>_UserProfState();}
class _UserProfState extends State<UserProfileScreen>{
  late TextEditingController name, phone, city, extraInfo;
  String? avatarPath;
  String? cvName;
  String? cvPath;
  bool isEditing = false;

  @override void initState(){
    super.initState();
    final u=context.read<AppProvider>().currentUser!;
    name=TextEditingController(text:u.name);
    phone=TextEditingController(text:u.phone);
    city=TextEditingController(text:u.city);
    extraInfo=TextEditingController(text:u.extraInfo??'');
    avatarPath=u.avatarPath;
    cvName=u.cvName;
    cvPath=u.cvPath;
    isEditing = false;
  }

  Future<void> _pickAvatar() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
    if(res!=null && res.files.isNotEmpty){
      final path = res.files.single.path ?? res.files.single.name;
      setState(()=> avatarPath=path);
      if(!isEditing){
        context.read<AppProvider>().updateUserProfile({'avatarPath': path});
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث الصورة'), backgroundColor: AppColors.success));
      }
    }
  }
  Future<void> _pickCv() async {
    if(!isEditing) return;
    final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf','doc','docx','jpg','png'], allowMultiple: false);
    if(res!=null && res.files.isNotEmpty){
      setState(()=> {cvName=res.files.single.name, cvPath=res.files.single.path ?? res.files.single.name});
    }
  }

  Widget _infoRow(String label, String value, IconData icon)=> Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal:12, vertical:14), margin: const EdgeInsets.only(bottom:8), decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: Row(children:[Icon(icon, size:16, color: AppColors.accent), const SizedBox(width:8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(label, style: const TextStyle(color: AppColors.textLight, fontSize:10)), const SizedBox(height:2), Text(value.isEmpty ? '—' : value, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize:13))]))]));

  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>(); final u=p.currentUser!;
    final displayName = name.text.isEmpty ? u.name : name.text;
    return Scaffold(appBar: AppBar(title: const Text('حسابي'), actions:[IconButton(onPressed: ()async{ await p.logout(); Navigator.pushNamedAndRemoveUntil(context,'/',(r)=>false);}, icon: const Icon(Icons.logout))]), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children:[
      AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        Center(child: InkWell(onTap: _pickAvatar, borderRadius: BorderRadius.circular(44), child: Stack(alignment: Alignment.bottomRight, children:[
          Container(width:88,height:88, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(44), border: Border.all(color: AppColors.border, width:2)),
            child: avatarPath!=null && avatarPath!.isNotEmpty
              ? ClipRRect(borderRadius: BorderRadius.circular(44), child: avatarPath!.startsWith('/') ? Image.file(File(avatarPath!), fit: BoxFit.cover, errorBuilder: (_,__,___)=> Center(child: Text(displayName.substring(0,1), style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w900, fontSize:26)))) : Center(child: Text(displayName.substring(0,1), style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w900, fontSize:26))))
              : Center(child: Text(displayName.substring(0,1), style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w900, fontSize:26))),
          ),
          Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, color: Colors.white, size: 14)),
        ]))),
        const SizedBox(height:8), Center(child: Text(displayName, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 15))), const Center(child: Text('اضغط على الصورة لتغييرها', style: TextStyle(color: AppColors.textLight, fontSize: 11))),
        const SizedBox(height:12),
        if(!isEditing) ...[
          _infoRow('الاسم الكامل', name.text, Icons.person),
          _infoRow('رقم الهاتف', phone.text, Icons.phone),
          _infoRow('المدينة', city.text, Icons.location_city),
          _infoRow('السيرة الذاتية', cvName ?? 'لم يتم الرفع', Icons.description),
          Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Row(children:[const Icon(Icons.info, size:16, color: AppColors.accent), const SizedBox(width:6), const Text('معلومات إضافية', style: TextStyle(color: AppColors.textLight, fontSize:10))]), const SizedBox(height:6), Text(extraInfo.text.isEmpty ? '—' : extraInfo.text, style: const TextStyle(color: AppColors.primary, fontSize:13, height:1.5)) ])),
        ] else ...[
          const FieldLabel('الاسم الكامل'), TextField(controller:name, decoration: fieldDecoration('الاسم'), onChanged: (_)=> setState((){})),
          const FieldLabel('رقم الهاتف'), TextField(controller:phone, decoration: fieldDecoration('الهاتف')),
          const FieldLabel('المدينة'), TextField(controller:city, decoration: fieldDecoration('المدينة')),
          const FieldLabel('السيرة الذاتية (PDF / صورة)'),
          InkWell(onTap: _pickCv, child: Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: cvName!=null ? AppColors.success : AppColors.border, width: cvName!=null ? 1.5 : 1)), child: Row(children:[
            Icon(cvName!=null ? Icons.description : Icons.upload_file, color: cvName!=null ? AppColors.success : AppColors.textLight),
            const SizedBox(width:8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
              Text(cvName ?? 'اضغط لرفع السيرة الذاتية', style: TextStyle(color: cvName!=null ? AppColors.success : AppColors.textLight, fontWeight: FontWeight.w600, fontSize: 12)),
              if(cvPath!=null) Text(cvPath!, style: const TextStyle(color: AppColors.textLight, fontSize: 9), maxLines:1, overflow: TextOverflow.ellipsis),
            ])),
            if(cvName!=null) IconButton(onPressed: ()=> setState(()=> {cvName=null, cvPath=null}), icon: const Icon(Icons.close, size:16, color: AppColors.danger)),
          ]))),
          const FieldLabel('معلومات إضافية'), TextField(controller:extraInfo, decoration: fieldDecoration('اكتب نبذة عن خبراتك، مهاراتك، أو أي معلومات تريد إضافتها...'), maxLines: 4, minLines: 3),
        ],
        const SizedBox(height:12),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){
          if(isEditing){
            p.updateUserProfile({'name':name.text,'phone':phone.text,'city':city.text,'avatarPath':avatarPath??'','cvName':cvName??'','cvPath':cvPath??'','extraInfo':extraInfo.text});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التعديلات'), backgroundColor: AppColors.success));
            setState(()=> isEditing=false);
          } else {
            setState(()=> isEditing=true);
          }
        }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical:14)), child: Text(isEditing ? 'حفظ التعديلات' : 'تعديل البروفايل', style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w800)))),
      ])),
      const Footer(),
    ])));
  }
}

class UserNotificationsScreen extends StatelessWidget { const UserNotificationsScreen({super.key}); @override Widget build(BuildContext context){
  final p=context.watch<AppProvider>(); final u=p.currentUser; final list=p.notifications.where((n)=> n.role=='user' && n.userId==u?.id).toList();
  return Scaffold(appBar: AppBar(title: const Text('الإشعارات')), body: list.isEmpty? const Center(child: Text('لا توجد إشعارات')): ListView.builder(padding: const EdgeInsets.all(16), itemCount: list.length, itemBuilder: (_,i){
    final n=list[i]; return InkWell(onTap: ()=> p.markRead(n.id), child: AppCard(child: Row(children:[Container(width:8,height:8, decoration: BoxDecoration(color: n.read? Colors.grey: AppColors.accent, shape: BoxShape.circle)), const SizedBox(width:10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(n.title, style: const TextStyle(fontWeight: FontWeight.w800)), Text(n.body, style: const TextStyle(color: AppColors.textLight, fontSize:12)), Text(n.createdAt.substring(0,16), style: const TextStyle(color: AppColors.textLight, fontSize:10))]))])) );
  }));
}}
