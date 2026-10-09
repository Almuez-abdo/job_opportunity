import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/common.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF2563EB)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(width:84,height:84,decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius:12)]), child: const Center(child: Text('JO', style: TextStyle(fontSize:28, fontWeight: FontWeight.w900, color: AppColors.primary)))),
                const SizedBox(height:12),
                const Text('Job Opportunity', style: TextStyle(fontSize:28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing:0.5)),
                const SizedBox(height:6),
                const Text('منصة تربط وكالات التوظيف بالباحثين عن الفرص', style: TextStyle(color: Color(0xFFDBEAFE), fontSize:13), textAlign: TextAlign.center),
                const SizedBox(height:32),
                _bigCard(context, icon:'🏢', title:'الدخول كوكالة', desc:'إدارة العروض ومتابعة الطلبات', btn:'دخول الوكالة →', color: AppColors.primary, onTap: ()=> Navigator.pushNamed(context,'/login', arguments:'agency')),
                const SizedBox(height:16),
                _bigCard(context, icon:'👤', title:'الدخول كمستخدم', desc:'تصفح العروض والتقديم بسهولة', btn:'دخول المستخدم →', color: AppColors.accent, bg: const Color(0xFFEFF6FF), border: const Color(0xFFBFDBFE), onTap: ()=> Navigator.pushNamed(context,'/login', arguments:'user')),
                const SizedBox(height:24),
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.2))), child: const Text('✦ أكثر من 500 فرصة عمل ✦ تأشيرات موثوقة ✦ متابعة فورية', style: TextStyle(color: Colors.white, fontSize:11), textAlign: TextAlign.center)),
                const SizedBox(height:16),
                const Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _bigCard(BuildContext ctx,{required String icon, required String title, required String desc, required String btn, required Color color, Color? bg, Color? border, required VoidCallback onTap}){
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20), child: Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: bg?? Colors.white, borderRadius: BorderRadius.circular(20), border: border!=null? Border.all(color:border): null, boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius:12, offset: const Offset(0,4))]), child: Column(children:[
      Text(icon, style: const TextStyle(fontSize:42)), const SizedBox(height:8),
      Text(title, style: const TextStyle(fontSize:18, fontWeight: FontWeight.w800, color: AppColors.primary)),
      const SizedBox(height:4), Text(desc, style: const TextStyle(color: AppColors.textLight, fontSize:13)),
      const SizedBox(height:16), Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical:12), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Text(btn, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)))
    ])));
  }
}
