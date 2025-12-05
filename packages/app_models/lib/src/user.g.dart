// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  uuid: json['uuid'] as String?,
  uid: json['uid'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
  emailVerifiedAt:
      json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
  isActive: (json['isActive'] as num?)?.toInt(),
  phoneNumber: json['phone_number'] as String?,
  role: json['role'] as String?,
  department: json['department'] as String?,
  bio: json['bio'] as String?,
  linkedinUrl: json['linkedin_url'] as String?,
  twitterUrl: json['twitter_url'] as String?,
  publicProfile: (json['public_profile'] as num?)?.toInt(),
  profilePhoto: json['profile_photo'] as String?,
  signPhoto: json['sign_photo'] as String?,
  workingDays: json['working_days'] as String?,
  workingHoursStart: json['working_hours_start'] as String?,
  workingHoursEnd: json['working_hours_end'] as String?,
  calculateSalary: (json['calculate_salary'] as num?)?.toInt(),
  salary: (json['salary'] as num?)?.toInt(),
  fcmToken: json['fcm_token'] as String?,
  notificationsEnabled: json['notifications_enabled'] as bool?,
  ticketNotifications: json['ticket_notifications'] as bool?,
  attendanceNotifications: json['attendance_notifications'] as bool?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
  approvalRequired: json['approval_required'] as String?,
  profilePhotoUrl: json['profile_photo_url'] as String?,
  signPhotoUrl: json['sign_photo_url'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'uuid': instance.uuid,
  'uid': instance.uid,
  'name': instance.name,
  'email': instance.email,
  'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
  'isActive': instance.isActive,
  'phone_number': instance.phoneNumber,
  'role': instance.role,
  'department': instance.department,
  'bio': instance.bio,
  'linkedin_url': instance.linkedinUrl,
  'twitter_url': instance.twitterUrl,
  'public_profile': instance.publicProfile,
  'profile_photo': instance.profilePhoto,
  'sign_photo': instance.signPhoto,
  'working_days': instance.workingDays,
  'working_hours_start': instance.workingHoursStart,
  'working_hours_end': instance.workingHoursEnd,
  'calculate_salary': instance.calculateSalary,
  'salary': instance.salary,
  'fcm_token': instance.fcmToken,
  'notifications_enabled': instance.notificationsEnabled,
  'ticket_notifications': instance.ticketNotifications,
  'attendance_notifications': instance.attendanceNotifications,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'approval_required': instance.approvalRequired,
  'profile_photo_url': instance.profilePhotoUrl,
  'sign_photo_url': instance.signPhotoUrl,
};
