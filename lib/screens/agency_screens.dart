import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../widgets/common.dart';
import '../services/app_provider.dart';
import '../models/models.dart';

// Wrapper with bottom nav for agency
class AgencyShell extends StatefulWidget { const AgencyShell({super.key}); @override State<AgencyShell> createState()=>_AgencyShellState();}
class _AgencyShellState extends State<AgencyShell>{
  int idx=0;
  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>();
    if(p.currentAgency==null) return const Scaffold(body: Center(child: Text('غير مسجل')));
    final pages=[const AgencyDashboard(), const AgencyVisasScreen(), const AgencyAddVisaScreen(), const AgencyApplicationsScreen(), const AgencyProfileScreen()];
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(currentIndex: idx, onTap:(i)=> setState(()=> idx=i), type: BottomNavigationBarType.fixed, selectedItemColor: AppColors.accent, unselectedItemColor: AppColors.textLight, items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label:'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label:'العروض'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle), label:'إضافة'),
        BottomNavigationBarItem(icon: Icon(Icons.inbox), label:'الطلبات'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label:'حسابي'),
      ]),
    );
  }
}

class AgencyDashboard extends StatelessWidget {
  const AgencyDashboard({super.key});
  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>();
    final ag=p.currentAgency!;
    final visas=p.visas.where((v)=>v.agencyId==ag.id).toList();
    final apps=p.applications.where((a)=>a.agencyId==ag.id).toList();
    return Scaffold(backgroundColor: AppColors.bg, appBar: AppBar(title: const Text('لوحة تحكم الوكالة'), actions:[IconButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const AgencyNotificationsScreen())), icon: const Icon(Icons.notifications_none)), IconButton(onPressed: ()async{ await p.logout(); Navigator.pushNamedAndRemoveUntil(context,'/',(r)=>false);}, icon: const Icon(Icons.logout))]),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children:[
        Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)), child: Column(children:[
          Container(width:64,height:64, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)), child: Center(child: Text(ag.name.substring(0,2), style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)))),
          const SizedBox(height:10), Text(ag.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize:18)),
          Text('${ag.city} - ${ag.country} • ${ag.email}', style: const TextStyle(color: Color(0xFFBFDBFE), fontSize:12)),
        ])),
        const SizedBox(height:12),
        Row(children:[
          _stat('${visas.length}','العروض', const Color(0xFFEFF6FF)),
          const SizedBox(width:8),
          _stat('${apps.where((a)=>a.status=="جديد").length}','طلبات جديدة', const Color(0xFFFEF3C7)),
          const SizedBox(width:8),
          _stat('${apps.length}','إجمالي الطلبات', const Color(0xFFECFDF5)),
        ]),
        const SizedBox(height:12),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){
          final shell=context.findAncestorStateOfType<_AgencyShellState>(); shell?.setState(()=> shell.idx=2);
        }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical:14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('+ إضافة تأشيرة / فرصة', style: TextStyle(color:Colors.white, fontWeight: FontWeight.w900)))),
        const SizedBox(height:12),
        Row(children:[
          _gridBtn(context,'📋','إدارة العروض', ()=> context.findAncestorStateOfType<_AgencyShellState>()?.setState(()=> context.findAncestorStateOfType<_AgencyShellState>()!.idx=1)),
          const SizedBox(width:8),
          _gridBtn(context,'📥','الطلبات', ()=> context.findAncestorStateOfType<_AgencyShellState>()?.setState(()=> context.findAncestorStateOfType<_AgencyShellState>()!.idx=3)),
        ]),
        Row(children:[
          _gridBtn(context,'🔔','الإشعارات', ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const AgencyNotificationsScreen()))),
          const SizedBox(width:8),
          _gridBtn(context,'⚙️','الملف الشخصي', ()=> context.findAncestorStateOfType<_AgencyShellState>()?.setState(()=> context.findAncestorStateOfType<_AgencyShellState>()!.idx=4)),
        ]),
        const SizedBox(height:12),
        AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
          const Text('العروض الحالية', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)),
          const SizedBox(height:8),
          if(visas.isEmpty) const Padding(padding: EdgeInsets.all(20), child: Center(child: Text('لا توجد عروض بعد. أضف أول عرض لك.', style: TextStyle(color: AppColors.textLight)))),
          ...visas.take(4).map((v)=> InkWell(onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> AgencyVisaDetailScreen(visa: v))), child: Container(margin: const EdgeInsets.only(bottom:8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: Row(children:[
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
              Text(v.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize:13, color: AppColors.primary)),
              Text('${v.country} • ${v.jobTitle} • ${v.salary} ${v.currency}', style: const TextStyle(color: AppColors.textLight, fontSize:11)),
              const SizedBox(height:6),
              Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:2), decoration: BoxDecoration(color: v.status=='active'? AppColors.success: v.status=='paused'? AppColors.warning: AppColors.danger, borderRadius: BorderRadius.circular(8)), child: Text(v.status=='active'?'نشط': v.status=='paused'?'متوقف':'منتهي', style: const TextStyle(color:Colors.white, fontSize:10, fontWeight: FontWeight.w800))),
            ])),
            const Icon(Icons.chevron_left, color: AppColors.accent),
          ])))),
        ])),
        const Footer(),
      ])),
    );
  }
  Widget _stat(String num,String label, Color bg)=> Expanded(child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)), child: Column(children:[Text(num, style: const TextStyle(fontSize:20, fontWeight: FontWeight.w900, color: AppColors.primary)), Text(label, style: const TextStyle(fontSize:11, color: AppColors.textLight))])) );
  Widget _gridBtn(BuildContext c,String icon,String label, VoidCallback onTap)=> Expanded(child: InkWell(onTap:onTap, child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)), child: Column(children:[Text(icon, style: const TextStyle(fontSize:24)), const SizedBox(height:6), Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize:12))]))));
}

class AgencyVisasScreen extends StatelessWidget {
  const AgencyVisasScreen({super.key});
  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>();
    final ag=p.currentAgency!;
    final list=p.visas.where((v)=>v.agencyId==ag.id).toList();
    return Scaffold(appBar: AppBar(title: const Text('إدارة العروض')), body: list.isEmpty? const Center(child: Text('لا توجد عروض', style: TextStyle(color: AppColors.textLight))) : ListView.builder(padding: const EdgeInsets.all(16), itemCount: list.length, itemBuilder: (_,i){
      final v=list[i];
      return AppCard(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        Row(children:[Expanded(child: Text(v.title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary))), Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:4), decoration: BoxDecoration(color: v.status=='active'?AppColors.success: v.status=='paused'?AppColors.warning:AppColors.danger, borderRadius: BorderRadius.circular(8)), child: Text(v.status, style: const TextStyle(color:Colors.white, fontSize:10)))]),
        const SizedBox(height:4), Text('${v.country} • ${v.jobTitle} • ${v.salary} ${v.currency} • ${v.seats} مقاعد', style: const TextStyle(color: AppColors.textLight, fontSize:12)),
        const SizedBox(height:8),
        Row(children:[
          Expanded(child: OutlinedButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> AgencyVisaDetailScreen(visa: v))), child: const Text('عرض'))),
          const SizedBox(width:6),
          Expanded(child: ElevatedButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> AgencyAddVisaScreen(editVisa: v))), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary), child: const Text('تعديل', style: TextStyle(color:Colors.white)))),
          const SizedBox(width:6),
          IconButton(onPressed: (){
            showDialog(context: context, builder: (_)=> AlertDialog(title: const Text('حذف العرض'), content: const Text('هل أنت متأكد؟'), actions:[TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('إلغاء')), TextButton(onPressed: (){p.deleteVisa(v.id); Navigator.pop(context);}, child: const Text('حذف', style: TextStyle(color: AppColors.danger))) ]));
          }, icon: const Icon(Icons.delete, color: AppColors.danger)),
          PopupMenuButton<String>(onSelected: (val){ p.updateVisa(v.id, VisaModel(id:v.id, agencyId:v.agencyId, title:v.title, country:v.country, visaType:v.visaType, jobTitle:v.jobTitle, description:v.description, requirements:v.requirements, documents:v.documents, ageRequired:v.ageRequired, qualification:v.qualification, experience:v.experience, salary:v.salary, currency:v.currency, contractDuration:v.contractDuration, visaDuration:v.visaDuration, price:v.price, seats:v.seats, expiryDate:v.expiryDate, images:v.images, status:val, createdAt:v.createdAt)); }, itemBuilder: (_)=> const [PopupMenuItem(value:'active', child: Text('تفعيل')), PopupMenuItem(value:'paused', child: Text('إيقاف مؤقت')), PopupMenuItem(value:'expired', child: Text('إنهاء'))]),
        ]),
      ]));
    }));
  }
}

class AgencyAddVisaScreen extends StatefulWidget {
  final VisaModel? editVisa;
  const AgencyAddVisaScreen({super.key, this.editVisa});
  @override State<AgencyAddVisaScreen> createState()=>_AddVisaState();
}
class _AddVisaState extends State<AgencyAddVisaScreen>{
  late TextEditingController title, jobTitle, desc, req, docs, age, qual, exp, salary, contract, visaDur, price, seats, expiry;
  String country='السعودية', visaType='عمل', currency='SAR';
  @override void initState(){
    super.initState();
    final v=widget.editVisa;
    title=TextEditingController(text: v?.title??''); jobTitle=TextEditingController(text: v?.jobTitle??''); desc=TextEditingController(text: v?.description??''); req=TextEditingController(text: v?.requirements??''); docs=TextEditingController(text: v?.documents??''); age=TextEditingController(text: v?.ageRequired??'25-45'); qual=TextEditingController(text: v?.qualification??'بدون مؤهل'); exp=TextEditingController(text: v?.experience??'سنتان'); salary=TextEditingController(text: v?.salary??''); contract=TextEditingController(text: v?.contractDuration??'سنتان'); visaDur=TextEditingController(text: v?.visaDuration??'سنتان'); price=TextEditingController(text: v?.price??''); seats=TextEditingController(text: v?.seats.toString()??'5'); expiry=TextEditingController(text: v?.expiryDate??'');
    if(v!=null){ country=v.country; visaType=v.visaType; currency=v.currency; }
  }
  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>();
    final isEdit=widget.editVisa!=null;
    return Scaffold(appBar: AppBar(title: Text(isEdit?'تعديل العرض':'إضافة عرض جديد')), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children:[
      AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children:[
        const FieldLabel('اسم التأشيرة *'), TextField(controller:title, decoration: fieldDecoration('تأشيرة عمل سائق - السعودية')),
        const FieldLabel('الدولة *'), Wrap(spacing:6, children: countries.map((c)=> ChoiceChip(label: Text(c, style: const TextStyle(fontSize:11)), selected: country==c, onSelected: (_)=> setState(()=>country=c), selectedColor: AppColors.accent, labelStyle: TextStyle(color: country==c? Colors.white: AppColors.textLight))).toList()),
        const FieldLabel('نوع التأشيرة'), Wrap(spacing:6, children: visaTypes.map((c)=> ChoiceChip(label: Text(c, style: const TextStyle(fontSize:11)), selected: visaType==c, onSelected: (_)=> setState(()=>visaType=c))).toList()),
        const FieldLabel('اسم الوظيفة *'), TextField(controller:jobTitle, decoration: fieldDecoration('سائق، ممرض...')),
        const FieldLabel('وصف العرض'), TextField(controller:desc, decoration: fieldDecoration('تفاصيل العرض...'), maxLines:3),
        const FieldLabel('المتطلبات'), TextField(controller:req, decoration: fieldDecoration('الشروط...')),
        const FieldLabel('المستندات المطلوبة'), TextField(controller:docs, decoration: fieldDecoration('جواز سفر - شهادة...')),
        Row(children:[Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const FieldLabel('العمر'), TextField(controller:age, decoration: fieldDecoration('25-45'))])), const SizedBox(width:8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const FieldLabel('المؤهل'), TextField(controller:qual, decoration: fieldDecoration('بكالوريوس'))]))]),
        Row(children:[Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const FieldLabel('الخبرة'), TextField(controller:exp, decoration: fieldDecoration('سنتان'))])), const SizedBox(width:8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const FieldLabel('مدة العقد'), TextField(controller:contract, decoration: fieldDecoration('سنتان'))]))]),
        Row(children:[Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const FieldLabel('الراتب *'), TextField(controller:salary, decoration: fieldDecoration('2500'), keyboardType: TextInputType.number)])), const SizedBox(width:8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const FieldLabel('العملة'), Wrap(spacing:4, children: currencies.take(4).map((c)=> ChoiceChip(label: Text(c, style: const TextStyle(fontSize:10)), selected: currency==c, onSelected: (_)=> setState(()=>currency=c))).toList())]))]),
        Row(children:[Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const FieldLabel('السعر *'), TextField(controller:price, decoration: fieldDecoration('15000'), keyboardType: TextInputType.number)])), const SizedBox(width:8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const FieldLabel('المقاعد'), TextField(controller:seats, decoration: fieldDecoration('5'), keyboardType: TextInputType.number)]))]),
        const FieldLabel('مدة التأشيرة'), TextField(controller:visaDur, decoration: fieldDecoration('سنتان')),
        const SizedBox(height:16),
        ElevatedButton(onPressed: (){
          if(title.text.isEmpty|| jobTitle.text.isEmpty|| salary.text.isEmpty|| price.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أكمل الحقول المطلوبة'))); return;}
          if(isEdit){
            final v=widget.editVisa!;
            p.updateVisa(v.id, VisaModel(id:v.id, agencyId:v.agencyId, title:title.text, country:country, visaType:visaType, jobTitle:jobTitle.text, description:desc.text, requirements:req.text, documents:docs.text, ageRequired:age.text, qualification:qual.text, experience:exp.text, salary:salary.text, currency:currency, contractDuration:contract.text, visaDuration:visaDur.text, price:price.text, seats:int.tryParse(seats.text)??1, expiryDate: DateTime.now().add(const Duration(days:30)).toIso8601String(), status:v.status, createdAt:v.createdAt));
          } else {
            final ag=p.currentAgency!;
            p.addVisa(VisaModel(id: genId(), agencyId:ag.id, title:title.text, country:country, visaType:visaType, jobTitle:jobTitle.text, description:desc.text, requirements:req.text, documents:docs.text, ageRequired:age.text, qualification:qual.text, experience:exp.text, salary:salary.text, currency:currency, contractDuration:contract.text, visaDuration:visaDur.text, price:price.text, seats:int.tryParse(seats.text)??1, expiryDate: DateTime.now().add(const Duration(days:30)).toIso8601String(), status:'active', createdAt:DateTime.now().toIso8601String()));
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEdit?'تم التعديل':'تمت الإضافة')));
          Navigator.pop(context);
        }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical:14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(isEdit?'حفظ التعديلات':'إضافة العرض', style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w900))),
      ])),
      const Footer(),
    ])));
  }
}

class AgencyVisaDetailScreen extends StatelessWidget {
  final VisaModel visa;
  const AgencyVisaDetailScreen({super.key, required this.visa});
  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>();
    final ag=p.agencies.firstWhere((a)=>a.id==visa.agencyId);
    return Scaffold(appBar: AppBar(title: const Text('تفاصيل العرض')), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
      AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        Text(visa.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize:18, color: AppColors.primary)),
        const SizedBox(height:6), Text('${visa.country} • ${visa.visaType} • ${ag.name}', style: const TextStyle(color: AppColors.textLight)),
        const SizedBox(height:12),
        Wrap(spacing:8, runSpacing:8, children:[
          _chip('💼 ${visa.jobTitle}'), _chip('💰 ${visa.salary} ${visa.currency}'), _chip('💳 ${visa.price} ${visa.currency}'), _chip('🪑 ${visa.seats} مقاعد'), _chip('⏳ ${visa.contractDuration}'), _chip('📅 ${visa.visaDuration}'),
        ]),
        const SizedBox(height:12),
        _row('العمر المطلوب', visa.ageRequired), _row('المؤهل', visa.qualification), _row('الخبرة', visa.experience), _row('مدة العقد', visa.contractDuration), _row('مدة التأشيرة', visa.visaDuration),
        const Divider(height:24),
        const Text('وصف العرض', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height:4), Text(visa.description, style: const TextStyle(color: AppColors.textLight, height:1.6)),
        const SizedBox(height:8), const Text('المتطلبات', style: TextStyle(fontWeight: FontWeight.w800)), Text(visa.requirements, style: const TextStyle(color: AppColors.textLight)),
        const SizedBox(height:8), const Text('المستندات المطلوبة', style: TextStyle(fontWeight: FontWeight.w800)), Text(visa.documents, style: const TextStyle(color: AppColors.textLight)),
      ])),
      const SizedBox(height:12),
      const Footer(),
    ])));
  }
  Widget _chip(String t)=> Container(padding: const EdgeInsets.symmetric(horizontal:10, vertical:6), decoration: BoxDecoration(color: AppColors.muted, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)), child: Text(t, style: const TextStyle(fontSize:12, fontWeight: FontWeight.w700)));
  Widget _row(String k,String v)=> Padding(padding: const EdgeInsets.symmetric(vertical:4), child: Row(children:[Text('$k: ', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)), Expanded(child: Text(v, style: const TextStyle(color: AppColors.textLight)))]));
}

class AgencyApplicationsScreen extends StatelessWidget {
  const AgencyApplicationsScreen({super.key});
  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>();
    final ag=p.currentAgency!;
    final apps=p.applications.where((a)=>a.agencyId==ag.id).toList();
    return Scaffold(appBar: AppBar(title: const Text('طلبات المستخدمين')), body: apps.isEmpty? const Center(child: Text('لا توجد طلبات بعد')): ListView.builder(padding: const EdgeInsets.all(16), itemCount: apps.length, itemBuilder: (_,i){
      final a=apps[i];
      return AppCard(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        Text(a.visaTitle, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
        const SizedBox(height:4), Text('المتقدم: ${a.userName} • ${a.userPhone}', style: const TextStyle(color: AppColors.textLight, fontSize:12)),
        Text('البريد: ${a.userEmail} • ${a.createdAt.substring(0,10)}', style: const TextStyle(color: AppColors.textLight, fontSize:11)),
        const SizedBox(height:6),
        Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:4), decoration: BoxDecoration(color: a.status=="جديد"? const Color(0xFFEFF6FF): a.status=="قيد المراجعة"? const Color(0xFFFEF3C7): a.status=="مقبول"? const Color(0xFFECFDF5): const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)), child: Text(a.status, style: const TextStyle(fontSize:12, fontWeight: FontWeight.w800))),
        const SizedBox(height:8),
        Row(children:[
          Expanded(child: ElevatedButton(onPressed: ()=> p.updateApplicationStatus(a.id,"مقبول"), style: ElevatedButton.styleFrom(backgroundColor: AppColors.success), child: const Text('قبول', style: TextStyle(color:Colors.white)))),
          const SizedBox(width:6),
          Expanded(child: ElevatedButton(onPressed: ()=> p.updateApplicationStatus(a.id,"مرفوض"), style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger), child: const Text('رفض', style: TextStyle(color:Colors.white)))),
          const SizedBox(width:6),
          Expanded(child: OutlinedButton(onPressed: ()=> p.updateApplicationStatus(a.id,"قيد المراجعة"), child: const Text('مراجعة'))),
        ]),
      ]));
    }));
  }
}

class AgencyProfileScreen extends StatefulWidget { const AgencyProfileScreen({super.key}); @override State<AgencyProfileScreen> createState()=>_AgProfState();}
class _AgProfState extends State<AgencyProfileScreen>{
  late TextEditingController name, phone, city, address, desc;
  String? logoPath;
  bool isEditing = false;
  @override void initState(){ super.initState(); final ag=context.read<AppProvider>().currentAgency!; name=TextEditingController(text:ag.name); phone=TextEditingController(text:ag.phone); city=TextEditingController(text:ag.city); address=TextEditingController(text:ag.address); desc=TextEditingController(text:ag.description); logoPath=ag.logo; isEditing=false; }
  Future<void> _pickLogo() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
    if(res!=null && res.files.isNotEmpty){
      final path = res.files.single.path ?? res.files.single.name;
      setState(()=> logoPath=path);
      // حفظ فوري حتى لو في وضع العرض
      if(!isEditing){
        context.read<AppProvider>().updateAgencyProfile({'logo': path});
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث الشعار'), backgroundColor: AppColors.success));
      }
    }
  }
  Widget _infoRow(String label, String value, IconData icon)=> Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal:12, vertical:14), margin: const EdgeInsets.only(bottom:8), decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: Row(children:[Icon(icon, size:16, color: AppColors.accent), const SizedBox(width:8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(label, style: const TextStyle(color: AppColors.textLight, fontSize:10)), const SizedBox(height:2), Text(value.isEmpty ? '—' : value, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize:13))]))]));
  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>(); final ag=p.currentAgency!;
    final displayLogo = logoPath ?? ag.logo;
    final displayName = isEditing ? (name.text.isEmpty ? ag.name : name.text) : ag.name;
    return Scaffold(appBar: AppBar(title: const Text('الملف الشخصي')), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children:[
      AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        Center(child: InkWell(onTap: _pickLogo, borderRadius: BorderRadius.circular(40), child: Stack(alignment: Alignment.bottomRight, children:[
          Container(width:88,height:88, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(44), border: Border.all(color: AppColors.border, width:2)),
            child: displayLogo!=null && displayLogo.isNotEmpty && displayLogo.startsWith('/')
              ? ClipRRect(borderRadius: BorderRadius.circular(44), child: Image.file(File(displayLogo), fit: BoxFit.cover, errorBuilder: (_,__,___)=> Center(child: Text(displayName.substring(0,2), style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w900, fontSize:22)))))
              : Center(child: Text(displayName.substring(0,2), style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w900, fontSize:22))),
          ),
          Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, color: Colors.white, size:14)),
        ]))),
        const SizedBox(height:8), Center(child: Text(displayName, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize:14))), const Center(child: Text('اضغط على الصورة لتغييرها', style: TextStyle(color: AppColors.textLight, fontSize:11))),
        const SizedBox(height:4), Center(child: Text(ag.email, style: const TextStyle(color: AppColors.textLight, fontSize:12))),
        const SizedBox(height:12),
        if(!isEditing) ...[
          _infoRow('اسم الوكالة', ag.name, Icons.business),
          _infoRow('رقم الهاتف', ag.phone, Icons.phone),
          _infoRow('المدينة', ag.city, Icons.location_city),
          _infoRow('العنوان', ag.address, Icons.location_on),
          Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Row(children:[const Icon(Icons.info, size:16, color: AppColors.accent), const SizedBox(width:6), const Text('الوصف', style: TextStyle(color: AppColors.textLight, fontSize:10))]), const SizedBox(height:6), Text(ag.description.isEmpty ? '—' : ag.description, style: const TextStyle(color: AppColors.primary, fontSize:13, height:1.5)) ])),
          const SizedBox(height:8),
          const FieldLabel('شهادة الوكالة'),
          Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: ag.certificateName!=null ? const Color(0xFFECFDF5) : AppColors.muted, borderRadius: BorderRadius.circular(12), border: Border.all(color: ag.certificateName!=null ? AppColors.success : AppColors.border)),
            child: Row(children:[
              Icon(ag.certificateName!=null && ag.certificateName!.toLowerCase().endsWith('.pdf') ? Icons.picture_as_pdf : Icons.verified, color: ag.certificateName!=null ? AppColors.success : AppColors.textLight),
              const SizedBox(width:8),
              Expanded(child: Text(ag.certificateName ?? 'لا توجد شهادة مرفوعة', style: TextStyle(color: ag.certificateName!=null ? AppColors.success : AppColors.textLight, fontWeight: FontWeight.w600, fontSize: 12))),
            ])),
        ] else ...[
          const FieldLabel('اسم الوكالة'), TextField(controller:name, decoration: fieldDecoration('اسم الوكالة')),
          const FieldLabel('رقم الهاتف'), TextField(controller:phone, decoration: fieldDecoration('الهاتف')),
          const FieldLabel('المدينة'), TextField(controller:city, decoration: fieldDecoration('المدينة')),
          const FieldLabel('العنوان'), TextField(controller:address, decoration: fieldDecoration('العنوان')),
          const FieldLabel('الوصف'), TextField(controller:desc, decoration: fieldDecoration('الوصف'), maxLines:3),
          const FieldLabel('شهادة الوكالة'),
          Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: ag.certificateName!=null ? const Color(0xFFECFDF5) : AppColors.muted, borderRadius: BorderRadius.circular(12), border: Border.all(color: ag.certificateName!=null ? AppColors.success : AppColors.border)),
            child: Row(children:[
              Icon(ag.certificateName!=null && ag.certificateName!.toLowerCase().endsWith('.pdf') ? Icons.picture_as_pdf : Icons.verified, color: ag.certificateName!=null ? AppColors.success : AppColors.textLight),
              const SizedBox(width:8),
              Expanded(child: Text(ag.certificateName ?? 'لا توجد شهادة مرفوعة', style: TextStyle(color: ag.certificateName!=null ? AppColors.success : AppColors.textLight, fontWeight: FontWeight.w600, fontSize: 12))),
            ])),
        ],
        const SizedBox(height:12),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){
          if(isEditing){
            p.updateAgencyProfile({'name':name.text,'phone':phone.text,'city':city.text,'address':address.text,'description':desc.text,'logo':logoPath ?? ''});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التعديلات'), backgroundColor: AppColors.success));
            setState(()=> isEditing=false);
          } else {
            // refresh controllers with latest ag data before editing
            name.text=ag.name; phone.text=ag.phone; city.text=ag.city; address.text=ag.address; desc.text=ag.description;
            setState(()=> isEditing=true);
          }
        }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical:14)), child: Text(isEditing ? 'حفظ التعديلات' : 'تعديل البروفايل', style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w800)))),
        if(!isEditing) ...[
          const SizedBox(height:8),
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: ()async{ await p.logout(); Navigator.pushNamedAndRemoveUntil(context,'/',(r)=>false);}, child: const Text('تسجيل خروج', style: TextStyle(color: AppColors.danger)))),
        ],
      ])),
      const Footer(),
    ])));
  }
}

class AgencyNotificationsScreen extends StatelessWidget { const AgencyNotificationsScreen({super.key}); @override Widget build(BuildContext context){
  final p=context.watch<AppProvider>(); final ag=p.currentAgency; final list=p.notifications.where((n)=> n.role=='agency' && n.userId==ag?.id).toList();
  return Scaffold(appBar: AppBar(title: const Text('الإشعارات')), body: list.isEmpty? const Center(child: Text('لا توجد إشعارات')): ListView.builder(padding: const EdgeInsets.all(16), itemCount: list.length, itemBuilder: (_,i){
    final n=list[i]; return InkWell(onTap: ()=> p.markRead(n.id), child: AppCard(child: Row(children:[Container(width:8,height:8, decoration: BoxDecoration(color: n.read? Colors.grey: AppColors.accent, shape: BoxShape.circle)), const SizedBox(width:10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(n.title, style: const TextStyle(fontWeight: FontWeight.w800)), Text(n.body, style: const TextStyle(color: AppColors.textLight, fontSize:12)), Text(n.createdAt.substring(0,16), style: const TextStyle(color: AppColors.textLight, fontSize:10))]))])) );
  }));
}}
