import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../widgets/common.dart';
import '../services/app_provider.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});
  @override State<LoginScreen> createState()=>_LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  late final String role; final email=TextEditingController(), pass=TextEditingController();
  @override void initState(){ super.initState(); role=widget.role; email.text= role=='agency'?'agency@test.com':'user@test.com'; pass.text='123456';}
  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>();
    final isAgency = role=='agency';
    return Scaffold(backgroundColor: AppColors.bg, appBar: AppBar(title: Text(isAgency ? 'تسجيل دخول الوكالة' : 'تسجيل دخول المستخدم')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children:[
        Container(width:64,height:64,decoration:BoxDecoration(color: isAgency ? AppColors.primary : AppColors.accent, borderRadius: BorderRadius.circular(18)), child: Center(child: Text('JO', style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w900, fontSize:22)))),
        const SizedBox(height:12), Text(isAgency ? 'مرحباً بعودتك - وكالة' : 'مرحباً بعودتك - مستخدم', style: const TextStyle(fontWeight: FontWeight.w900, fontSize:20, color: AppColors.primary)), const SizedBox(height:4), Text(isAgency ? 'سجل دخولك كوكالة إلى Job Opportunity' : 'سجل دخولك كمستخدم إلى Job Opportunity', style: const TextStyle(color: AppColors.textLight), textAlign: TextAlign.center),
        const SizedBox(height:16),
        Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical:12, horizontal:16), decoration: BoxDecoration(color: isAgency ? AppColors.primary : AppColors.accent, borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children:[Icon(isAgency ? Icons.business : Icons.person, color: Colors.white, size: 20), const SizedBox(width:8), Text(isAgency ? 'الدخول كوكالة' : 'الدخول كمستخدم', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14))])),
        const SizedBox(height:16),
        AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children:[
          const FieldLabel('البريد الإلكتروني'), TextField(controller: email, decoration: fieldDecoration('example@mail.com'), keyboardType: TextInputType.emailAddress),
          const FieldLabel('كلمة المرور'), TextField(controller: pass, decoration: fieldDecoration('••••••••'), obscureText:true),
          const SizedBox(height:16),
          ElevatedButton(onPressed: (){
            String? err = role=='agency'? p.loginAgency(email.text.trim(), pass.text) : p.loginUser(email.text.trim(), pass.text);
            if(err!=null){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err), backgroundColor: AppColors.danger)); return; }
            if(role=='agency') Navigator.pushReplacementNamed(context,'/agency');
            else Navigator.pushReplacementNamed(context,'/user');
          }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical:14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('تسجيل الدخول', style: TextStyle(color:Colors.white, fontWeight: FontWeight.w900))),
          TextButton(onPressed: ()=> showDialog(context: context, builder: (_)=> AlertDialog(title: const Text('نسيت كلمة المرور'), content: const Text('تواصل مع الدعم: support@jobopportunity.com'), actions:[TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('حسناً'))])), child: const Text('نسيت كلمة المرور؟')),
        ])),
        const SizedBox(height:12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children:[
          const Text('ليس لديك حساب؟ ', style: TextStyle(color: AppColors.textLight)),
          GestureDetector(onTap: ()=> Navigator.pushNamed(context, role=='agency'?'/registerAgency':'/registerUser'), child: const Text('إنشاء حساب جديد', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w800))),
        ]),
        const SizedBox(height:12),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFBFDBFE))), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
          Text('حسابات تجريبية:', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
          SizedBox(height:4), Text('وكالة: agency@test.com / 123456', style: TextStyle(fontSize:12, color: AppColors.textLight)),
          Text('وكالة 2: gold@test.com / 123456', style: TextStyle(fontSize:12, color: AppColors.textLight)),
          Text('مستخدم: user@test.com / 123456', style: TextStyle(fontSize:12, color: AppColors.textLight)),
        ])),
        const Footer(),
      ])),
    );
  }
  Widget _switchBtn(String t, bool active, VoidCallback onTap)=> Expanded(child: InkWell(onTap:onTap, child: Container(padding: const EdgeInsets.symmetric(vertical:10), decoration: BoxDecoration(color: active? Colors.white: Colors.transparent, borderRadius: BorderRadius.circular(10), boxShadow: active?[BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius:6)]:null), child: Text(t, textAlign: TextAlign.center, style: TextStyle(color: active? AppColors.primary: AppColors.textLight, fontWeight: FontWeight.w700)))));
}

// Register User
class RegisterUserScreen extends StatefulWidget { const RegisterUserScreen({super.key}); @override State<RegisterUserScreen> createState()=>_RegUserState();}
class _RegUserState extends State<RegisterUserScreen>{
  final name=TextEditingController(), email=TextEditingController(), phone=TextEditingController(), city=TextEditingController(), pass=TextEditingController(), confirm=TextEditingController();
  String country='مصر';
  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>();
    return Scaffold(appBar: AppBar(title: const Text('إنشاء حساب مستخدم')), body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children:[
      const Text('انضم لاكتشاف أفضل فرص العمل', style: TextStyle(color: AppColors.textLight)),
      const SizedBox(height:12),
      AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children:[
        const FieldLabel('الاسم الكامل *'), TextField(controller:name, decoration: fieldDecoration('أحمد محمد')),
        const FieldLabel('البريد الإلكتروني *'), TextField(controller:email, decoration: fieldDecoration('example@mail.com')),
        const FieldLabel('رقم الهاتف *'), TextField(controller:phone, decoration: fieldDecoration('+20 1xxxxxxxxx')),
        const FieldLabel('الدولة'), Wrap(spacing:6, children: countries.take(6).map((c)=> ChoiceChip(label: Text(c, style: const TextStyle(fontSize:11)), selected: country==c, onSelected: (_)=> setState(()=> country=c), selectedColor: AppColors.primary, labelStyle: TextStyle(color: country==c? Colors.white: AppColors.textLight))).toList()),
        const FieldLabel('المدينة *'), TextField(controller:city, decoration: fieldDecoration('القاهرة')),
        const FieldLabel('كلمة المرور *'), TextField(controller:pass, decoration: fieldDecoration('••••••••'), obscureText:true),
        const FieldLabel('تأكيد كلمة المرور *'), TextField(controller:confirm, decoration: fieldDecoration('••••••••'), obscureText:true),
        const SizedBox(height:16),
        ElevatedButton(onPressed: (){
          if(name.text.isEmpty||email.text.isEmpty||phone.text.isEmpty||city.text.isEmpty||pass.text.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أكمل الحقول المطلوبة'))); return;}
          if(!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email.text)) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('البريد غير صحيح'))); return;}
          if(pass.text.length<6) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('كلمة المرور قصيرة'))); return;}
          if(pass.text!=confirm.text) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('كلمتا المرور غير متطابقتين'))); return;}
          final err=p.registerUser({'name':name.text,'email':email.text,'phone':phone.text,'country':country,'city':city.text,'password':pass.text});
          if(err!=null){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err))); return;}
          Navigator.pushReplacementNamed(context,'/user');
        }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical:14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('إنشاء حساب', style: TextStyle(color:Colors.white, fontWeight: FontWeight.w900))),
        TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('لديك حساب؟ تسجيل الدخول')),
      ])),
      const Footer(),
    ])));
  }
}

// Register Agency
class RegisterAgencyScreen extends StatefulWidget { const RegisterAgencyScreen({super.key}); @override State<RegisterAgencyScreen> createState()=>_RegAgState();}
class _RegAgState extends State<RegisterAgencyScreen>{
  final name=TextEditingController(), email=TextEditingController(), phone=TextEditingController(), city=TextEditingController(), address=TextEditingController(), pass=TextEditingController(), confirm=TextEditingController(), desc=TextEditingController();
  String? certificateName;
  String? certificatePath;

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg','jpeg','png','webp'], withData: false);
      if(result!=null && result.files.isNotEmpty){
        setState(()=> {certificateName=result.files.single.name, certificatePath=result.files.single.path ?? result.files.single.name});
      }
    } catch(e){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ اختيار الصورة: $e'))); }
  }
  Future<void> _pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf'], withData: false);
      if(result!=null && result.files.isNotEmpty){
        setState(()=> {certificateName=result.files.single.name, certificatePath=result.files.single.path ?? result.files.single.name});
      }
    } catch(e){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ اختيار PDF: $e'))); }
  }
  @override Widget build(BuildContext context){
    final p=context.watch<AppProvider>();
    return Scaffold(appBar: AppBar(title: const Text('إنشاء حساب وكالة')), body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children:[
      const Text('سجل وكالتك وابدأ نشر الفرص', style: TextStyle(color: AppColors.textLight)),
      const SizedBox(height:12),
      AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children:[
        const FieldLabel('اسم الوكالة *'), TextField(controller:name, decoration: fieldDecoration('وكالة النخبة')),
        const FieldLabel('البريد الإلكتروني *'), TextField(controller:email, decoration: fieldDecoration('agency@mail.com')),
        const FieldLabel('رقم الهاتف *'), TextField(controller:phone, decoration: fieldDecoration('+966 5xxxxxxx')),
        const FieldLabel('المدينة *'), TextField(controller:city, decoration: fieldDecoration('الرياض')),
        const FieldLabel('العنوان'), TextField(controller:address, decoration: fieldDecoration('الرياض - العليا')),
        const FieldLabel('شهادة الوكالة (صورة أو PDF) *'), Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: certificateName==null ? AppColors.border : AppColors.success, width: certificateName==null ? 1 : 1.5)),
          child: Column(children:[
            Icon(certificateName==null ? Icons.cloud_upload_outlined : (certificateName!.toLowerCase().endsWith('.pdf') ? Icons.picture_as_pdf : Icons.image), size: 36, color: certificateName==null ? AppColors.textLight : AppColors.success),
            const SizedBox(height:8),
            if(certificateName!=null) ...[
              Text(certificateName!, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.success, fontSize: 12), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height:4),
              Text(certificatePath??'', style: const TextStyle(color: AppColors.textLight, fontSize: 10), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            ] else const Text('لم يتم اختيار ملف', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
            const SizedBox(height:10),
            Row(children:[
              Expanded(child: ElevatedButton.icon(onPressed: _pickImage, icon: const Icon(Icons.image, size: 16), label: const Text('صورة', style: TextStyle(fontSize: 12)), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical:10)))),
              const SizedBox(width:8),
              Expanded(child: ElevatedButton.icon(onPressed: _pickPdf, icon: const Icon(Icons.picture_as_pdf, size: 16), label: const Text('PDF', style: TextStyle(fontSize: 12)), style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical:10)))),
            ]),
            if(certificateName!=null) TextButton(onPressed: ()=> setState(()=> {certificateName=null, certificatePath=null}), child: const Text('إزالة الملف', style: TextStyle(color: AppColors.danger, fontSize: 12))),
          ]),
        ),
        const FieldLabel('وصف الوكالة'), TextField(controller:desc, decoration: fieldDecoration('نبذة عن الوكالة'), maxLines:3),
        const FieldLabel('كلمة المرور *'), TextField(controller:pass, decoration: fieldDecoration('••••••••'), obscureText:true),
        const FieldLabel('تأكيد كلمة المرور *'), TextField(controller:confirm, decoration: fieldDecoration('••••••••'), obscureText:true),
        const SizedBox(height:16),
        ElevatedButton(onPressed: (){
          if(name.text.isEmpty||email.text.isEmpty||phone.text.isEmpty||city.text.isEmpty||pass.text.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أكمل الحقول المطلوبة'))); return;}
          if(certificateName==null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى رفع شهادة الوكالة (صورة أو PDF)'), backgroundColor: AppColors.danger)); return;}
          if(pass.text!=confirm.text) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('كلمتا المرور غير متطابقتين'))); return;}
          final err=p.registerAgency({'name':name.text,'email':email.text,'phone':phone.text,'city':city.text,'address':address.text,'password':pass.text,'description':desc.text,'certificateName':certificateName!,'certificatePath':certificatePath??certificateName!});
          if(err!=null){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err))); return;}
          Navigator.pushReplacementNamed(context,'/agency');
        }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical:14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('إنشاء حساب الوكالة', style: TextStyle(color:Colors.white, fontWeight: FontWeight.w900))),
        TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('لديك حساب؟ تسجيل الدخول')),
      ])),
      const Footer(),
    ])));
  }
}
