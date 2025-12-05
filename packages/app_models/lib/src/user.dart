import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String? uuid;
  final String? uid;
  final String? name;
  final String? email;
  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;
  @JsonKey(name: 'isActive')
  final int? isActive;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? role;
  final String? department;
  final String? bio;
  @JsonKey(name: 'linkedin_url')
  final String? linkedinUrl;
  @JsonKey(name: 'twitter_url')
  final String? twitterUrl;
  @JsonKey(name: 'public_profile')
  final int? publicProfile;
  @JsonKey(name: 'profile_photo')
  final String? profilePhoto;
  @JsonKey(name: 'sign_photo')
  final String? signPhoto;
  @JsonKey(name: 'working_days')
  final String? workingDays;
  @JsonKey(name: 'working_hours_start')
  final String? workingHoursStart;
  @JsonKey(name: 'working_hours_end')
  final String? workingHoursEnd;
  @JsonKey(name: 'calculate_salary')
  final int? calculateSalary;
  final int? salary;
  @JsonKey(name: 'fcm_token')
  final String? fcmToken;
  @JsonKey(name: 'notifications_enabled')
  final bool? notificationsEnabled;
  @JsonKey(name: 'ticket_notifications')
  final bool? ticketNotifications;
  @JsonKey(name: 'attendance_notifications')
  final bool? attendanceNotifications;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'approval_required')
  final String? approvalRequired;
  @JsonKey(name: 'profile_photo_url')
  final String? profilePhotoUrl;
  @JsonKey(name: 'sign_photo_url')
  final String? signPhotoUrl;

  User({
    required this.id,
    this.uuid,
    this.uid,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.isActive,
    this.phoneNumber,
    this.role,
    this.department,
    this.bio,
    this.linkedinUrl,
    this.twitterUrl,
    this.publicProfile,
    this.profilePhoto,
    this.signPhoto,
    this.workingDays,
    this.workingHoursStart,
    this.workingHoursEnd,
    this.calculateSalary,
    this.salary,
    this.fcmToken,
    this.notificationsEnabled,
    this.ticketNotifications,
    this.attendanceNotifications,
    this.createdAt,
    this.updatedAt,
    this.approvalRequired,
    this.profilePhotoUrl,
    this.signPhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    int? id,
    String? uuid,
    String? uid,
    String? name,
    String? email,
    DateTime? emailVerifiedAt,
    int? isActive,
    String? phoneNumber,
    String? role,
    String? department,
    String? bio,
    String? linkedinUrl,
    String? twitterUrl,
    int? publicProfile,
    String? profilePhoto,
    String? signPhoto,
    String? workingDays,
    String? workingHoursStart,
    String? workingHoursEnd,
    int? calculateSalary,
    int? salary,
    String? fcmToken,
    bool? notificationsEnabled,
    bool? ticketNotifications,
    bool? attendanceNotifications,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? approvalRequired,
    String? profilePhotoUrl,
    String? signPhotoUrl,
  }) {
    return User(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      isActive: isActive ?? this.isActive,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      department: department ?? this.department,
      bio: bio ?? this.bio,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      twitterUrl: twitterUrl ?? this.twitterUrl,
      publicProfile: publicProfile ?? this.publicProfile,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      signPhoto: signPhoto ?? this.signPhoto,
      workingDays: workingDays ?? this.workingDays,
      workingHoursStart: workingHoursStart ?? this.workingHoursStart,
      workingHoursEnd: workingHoursEnd ?? this.workingHoursEnd,
      calculateSalary: calculateSalary ?? this.calculateSalary,
      salary: salary ?? this.salary,
      fcmToken: fcmToken ?? this.fcmToken,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      ticketNotifications: ticketNotifications ?? this.ticketNotifications,
      attendanceNotifications: attendanceNotifications ?? this.attendanceNotifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      approvalRequired: approvalRequired ?? this.approvalRequired,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      signPhotoUrl: signPhotoUrl ?? this.signPhotoUrl,
    );
  }
}

class LoginResponse {
  final String token;
  final bool isApprovalRequired;
  final String? role;

  LoginResponse({
    required this.token,
    required this.isApprovalRequired,
    this.role,
  });
}
