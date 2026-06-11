import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../services/api_service.dart';

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  Future<void> login(String phone) async {
    try {
      final response = await ApiService().login(phone);
      if (response.statusCode == 200) {
        final data = response.data;
        state = User.fromJson(data['user']);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access_token']);
        await prefs.setString('user_id', state!.id);
        await prefs.setString('user_phone', state!.phone);
        await prefs.setString('user_nickname', state!.nickname);
      }
    } catch (e) {
      throw Exception('登录失败: $e');
    }
  }

  Future<void> loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final phone = prefs.getString('user_phone');
    final nickname = prefs.getString('user_nickname');
    
    if (userId != null && phone != null && nickname != null) {
      state = User(
        id: userId,
        phone: phone,
        nickname: nickname,
        avatar: prefs.getString('user_avatar'),
        gender: prefs.getString('user_gender'),
        birthDate: prefs.getString('user_birth_date'),
        createdAt: '',
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_id');
    await prefs.remove('user_phone');
    await prefs.remove('user_nickname');
    state = null;
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (state == null) return;
    
    try {
      final response = await ApiService().updateUserProfile(state!.id, data);
      if (response.statusCode == 200) {
        final updatedUser = User.fromJson(response.data);
        state = updatedUser;
        
        final prefs = await SharedPreferences.getInstance();
        if (data.containsKey('nickname')) {
          await prefs.setString('user_nickname', updatedUser.nickname);
        }
        if (data.containsKey('avatar')) {
          await prefs.setString('user_avatar', updatedUser.avatar ?? '');
        }
        if (data.containsKey('gender')) {
          await prefs.setString('user_gender', updatedUser.gender ?? '');
        }
        if (data.containsKey('birth_date')) {
          await prefs.setString('user_birth_date', updatedUser.birthDate ?? '');
        }
      }
    } catch (e) {
      throw Exception('更新失败: $e');
    }
  }
}