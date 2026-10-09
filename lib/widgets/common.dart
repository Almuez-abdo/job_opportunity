import 'package:flutter/material.dart';
import '../core/theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) => const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Center(child: Text('Create By Ezooo Service', style: TextStyle(color: AppColors.textLight, fontSize: 12, fontWeight: FontWeight.w600))));
}
class AppCard extends StatelessWidget {
  final Widget child; final EdgeInsetsGeometry? padding;
  const AppCard({super.key, required this.child, this.padding});
  @override
  Widget build(BuildContext context)=> Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0,2))]), padding: padding?? const EdgeInsets.all(16), child: child);
}
class FieldLabel extends StatelessWidget {
  final String label; const FieldLabel(this.label,{super.key});
  @override
  Widget build(BuildContext context)=> Padding(padding: const EdgeInsets.only(top:8,bottom:4), child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 13)));
}
InputDecoration fieldDecoration(String hint)=> InputDecoration(hintText: hint, hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13), filled: true, fillColor: AppColors.bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accent, width:1.2)), contentPadding: const EdgeInsets.symmetric(horizontal:14, vertical:12));
