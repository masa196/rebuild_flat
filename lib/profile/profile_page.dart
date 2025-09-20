import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../basics/app_colors.dart';
import '../basics/api_url.dart';
import 'profile_controller.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = Get.find<ProfileController>();
  bool isEditing = false;

  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background_orange,
        resizeToAvoidBottomInset: true,

        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: Color(0xfff77520)));
          }

          final user = controller.user.value;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.08),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    buildProfileImage(controller, width),
                    if (isEditing)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => pickImageFromGallery(),
                          child: CircleAvatar(
                            radius: width * 0.06,
                            backgroundColor: AppColors.primaryColor,
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isEditing
                        ? Expanded(
                      child: TextFormField(
                        initialValue: user?.name ?? '',
                        onChanged: (val) {
                          controller.user.value = user!.copyWith(name: val);
                        },
                        style: TextStyle(
                          fontSize: width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                        : Text(
                      user?.name ?? '',
                      style: TextStyle(
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    if (isEditing)
                      Icon(Icons.edit, size: width * 0.05, color: AppColors.primaryColor),
                  ],
                ),
                SizedBox(height: height * 0.03),

                buildEditableInfoRow(
                  icon: Icons.calendar_today,
                  label: 'العمر',
                  value: "${user?.age ?? ''}",
                  width: width,
                  editable: true,
                  onChanged: (val) {
                    controller.user.value = user!.copyWith(age: int.tryParse(val) ?? user.age);
                  },
                ),
                divider(),

                buildEditableInfoRow(
                  icon: Icons.person,
                  label: 'الجنس',
                  value: user?.gender ?? '',
                  width: width,
                  editable: true,
                  onChanged: (val) {
                    controller.user.value = user!.copyWith(gender: val);
                  },
                ),
                divider(),

                buildEditableInfoRow(
                  icon: Icons.email,
                  label: 'البريد الإلكتروني',
                  value: user?.email ?? '',
                  width: width,
                  editable: false,
                ),
                divider(),

                buildEditableInfoRow(
                  icon: Icons.account_balance_wallet,
                  label: 'الرصيد',
                  value: "${user?.balance.toStringAsFixed(2) ?? '0.00'} ل.س",
                  width: width,
                  editable: false,
                ),
                divider(),


                buildEditableInfoRow(
                  icon: Icons.phone,
                  label: 'رقم الهاتف',
                  value: user?.phone ?? '',
                  width: width,
                  editable: true,
                  onChanged: (val) {
                    controller.user.value = user!.copyWith(phone: val);
                  },
                ),
                divider(),

                if (isEditing)

                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 12),
                    child: TextButton(
                      onPressed: () => showPasswordChangeDialog(context),
                      child: const Text(
                        'تغيير كلمة السر',
                        style: TextStyle( fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                          fontSize: 18,),
                      ),
                    ),
                  ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(horizontal: width * 0.15, vertical: height * 0.018),
                    elevation: 4,
                  ),
                  onPressed: () async {
                    if (isEditing) {
                      await controller.saveProfileUpdates(_pickedImage?.path);
                      _pickedImage = null;
                    }
                    setState(() => isEditing = !isEditing);
                  },
                  child: Text(
                    isEditing ? 'حفظ التعديلات' : 'تعديل الملف الشخصي',
                    style: TextStyle(fontSize: width * 0.045, color: Colors.white),
                  ),
                ),
                SizedBox(height: height * 0.04),
              ],
            ),
          );
        }),
      ),
    );
  }

  void showPasswordChangeDialog(BuildContext context) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تغيير كلمة السر',style: TextStyle(
            color: AppColors.primaryColor,),),
          content: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(

                    controller: currentController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'كلمة السر الحالية',
                      floatingLabelStyle: TextStyle(color: AppColors.primaryColor), // لون التسمية عندما ترتفع

                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                    ),

                  ),
                  TextField(
                    controller: newController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'كلمة السر الجديدة',
                      floatingLabelStyle: TextStyle(color: AppColors.primaryColor), // لون التسمية عندما ترتفع

                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                    ),

                  ),
                  TextField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'تأكيد كلمة السر الجديدة',
                      floatingLabelStyle: TextStyle(color: AppColors.primaryColor), // لون التسمية عندما ترتفع

                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء',style: TextStyle(
        color: AppColors.primaryColor,)),
            ),
            ElevatedButton(
              onPressed: () {
                controller.updatePassword(
                  currentController.text,
                  newController.text,
                  confirmController.text,
                );
              },
              child: const Text('حفظ',style: TextStyle(
        color: AppColors.primaryColor,)),
            ),
          ],
        );
      },
    );

  }

  Widget buildProfileImage(ProfileController controller, double width) {
    final user = controller.user.value;
    final String defaultImagePath = (user?.gender.toLowerCase() == 'male' || user?.gender == 'ذكر')
        ? 'assets/male_profile-removebg-preview.png'
        : 'assets/female_profile-removebg-preview.png';

    ImageProvider imageProvider;

    if (_pickedImage != null) {
      imageProvider = FileImage(File(_pickedImage!.path));
    } else if (user != null && (user.image?.isNotEmpty ?? false)) {
      imageProvider = NetworkImage('${ServerConfiguration.domainNameServer}/${user.image}');
    } else {
      imageProvider = AssetImage(defaultImagePath);
    }

    return Container(
      width: width * 0.4,
      height: width * 0.4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryColor,
          width: 3,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.background_color,
        backgroundImage: imageProvider,
      ),
    );
  }

  Widget buildEditableInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required double width,
    bool editable = true,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryColor),
            SizedBox(width: width * 0.03),
            Expanded(
              child: isEditing && editable
                  ? TextFormField(
                initialValue: value,
                onChanged: onChanged,
                style: TextStyle(fontSize: width * 0.045),
                decoration: InputDecoration(
                  hintText: label,
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: Icon(Icons.edit, size: 18, color: Colors.grey),
                ),
              )
                  : Text(
                value,
                style: TextStyle(fontSize: width * 0.045),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Divider(thickness: 1, color: Colors.grey),
    );
  }
}