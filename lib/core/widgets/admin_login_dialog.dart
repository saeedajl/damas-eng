import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

const kNavy = Color(0xFF1A2744);
const kGold = Color(0xFFC4922A);
const kRed  = Color(0xFFD93025);

void showAdminLoginDialog(BuildContext context) {
  final auth = AuthService.to;

  if (auth.isAdmin.value) {
    Get.toNamed('/admin/news');
    return;
  }

  final passCtrl  = TextEditingController();
  final obscure   = true.obs;
  final isLoading = false.obs;
  final hasError  = false.obs;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => Obx(() => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              decoration: const BoxDecoration(
                color: kNavy,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: kGold.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: kGold.withOpacity(0.4), width: 1),
                  ),
                  child: const Icon(Icons.admin_panel_settings_outlined,
                      color: kGold, size: 28),
                ),
                const SizedBox(height: 12),
                Text('دخول الإدارة',
                    style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('أدخل كلمة السر للوصول للوحة التحكم',
                    style: GoogleFonts.cairo(
                        color: Colors.white54, fontSize: 12)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                TextField(
                  controller: passCtrl,
                  obscureText: obscure.value,
                  textDirection: TextDirection.ltr,
                  autofocus: true,
                  onChanged: (_) => hasError.value = false,
                  onSubmitted: (_) => _tryLogin(
                      dialogContext, auth, passCtrl, isLoading, hasError),
                  style: GoogleFonts.cairo(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: '••••••••••••',
                    labelText: 'كلمة السر',
                    filled: true,
                    fillColor: hasError.value
                        ? const Color(0xFFFCE8E6)
                        : Colors.grey.shade50,
                    suffixIcon: GestureDetector(
                      onTap: () => obscure.value = !obscure.value,
                      child: Icon(
                        obscure.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey.shade400, size: 18,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: hasError.value ? kRed : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: hasError.value ? kRed : kNavy, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
                if (hasError.value) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.error_outline, color: kRed, size: 14),
                    const SizedBox(width: 6),
                    Text('كلمة السر غير صحيحة',
                        style: GoogleFonts.cairo(color: kRed, fontSize: 12)),
                  ]),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading.value
                        ? null
                        : () => _tryLogin(
                            dialogContext, auth, passCtrl, isLoading, hasError),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: isLoading.value
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : Text('دخول',
                            style: GoogleFonts.cairo(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    )),
  );
}

Future<void> _tryLogin(
  BuildContext dialogContext,
  AuthService auth,
  TextEditingController passCtrl,
  RxBool isLoading,
  RxBool hasError,
) async {
  isLoading.value = true;
  hasError.value  = false;

  await Future.delayed(const Duration(milliseconds: 300));

  final success = auth.loginAsAdmin(passCtrl.text);

  if (success) {
    // أغلق الـ dialog أولاً
    Navigator.of(dialogContext).pop();
    // انتقل للوحة الإدارة مباشرة بدون أي تأخير
    Get.toNamed('/admin/news');
  } else {
    isLoading.value = false;
    hasError.value  = true;
    passCtrl.clear();
  }
}
