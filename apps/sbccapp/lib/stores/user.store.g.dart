// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStore, Store {
  late final _$isLoggedInAtom = Atom(
    name: '_UserStore.isLoggedIn',
    context: context,
  );

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_UserStore.errorMessage',
    context: context,
  );

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$currentUserAtom = Atom(
    name: '_UserStore.currentUser',
    context: context,
  );

  @override
  User? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(User? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$qrCodeAtom = Atom(name: '_UserStore.qrCode', context: context);

  @override
  Result<Uint8List> get qrCode {
    _$qrCodeAtom.reportRead();
    return super.qrCode;
  }

  @override
  set qrCode(Result<Uint8List> value) {
    _$qrCodeAtom.reportWrite(value, super.qrCode, () {
      super.qrCode = value;
    });
  }

  late final _$userRoleAtom = Atom(
    name: '_UserStore.userRole',
    context: context,
  );

  @override
  String? get userRole {
    _$userRoleAtom.reportRead();
    return super.userRole;
  }

  @override
  set userRole(String? value) {
    _$userRoleAtom.reportWrite(value, super.userRole, () {
      super.userRole = value;
    });
  }

  late final _$_userNameAtom = Atom(
    name: '_UserStore._userName',
    context: context,
  );

  String? get userName {
    _$_userNameAtom.reportRead();
    return super._userName;
  }

  @override
  String? get _userName => userName;

  @override
  set _userName(String? value) {
    _$_userNameAtom.reportWrite(value, super._userName, () {
      super._userName = value;
    });
  }

  late final _$_userEmailAtom = Atom(
    name: '_UserStore._userEmail',
    context: context,
  );

  String? get userEmail {
    _$_userEmailAtom.reportRead();
    return super._userEmail;
  }

  @override
  String? get _userEmail => userEmail;

  @override
  set _userEmail(String? value) {
    _$_userEmailAtom.reportWrite(value, super._userEmail, () {
      super._userEmail = value;
    });
  }

  late final _$_isApprovalRequiredAtom = Atom(
    name: '_UserStore._isApprovalRequired',
    context: context,
  );

  bool get isApprovalRequired {
    _$_isApprovalRequiredAtom.reportRead();
    return super._isApprovalRequired;
  }

  @override
  bool get _isApprovalRequired => isApprovalRequired;

  @override
  set _isApprovalRequired(bool value) {
    _$_isApprovalRequiredAtom.reportWrite(value, super._isApprovalRequired, () {
      super._isApprovalRequired = value;
    });
  }

  late final _$loginAsyncAction = AsyncAction(
    '_UserStore.login',
    context: context,
  );

  @override
  Future<void> login({required String email, required String password}) {
    return _$loginAsyncAction.run(
      () => super.login(email: email, password: password),
    );
  }

  late final _$loadProfileAsyncAction = AsyncAction(
    '_UserStore.loadProfile',
    context: context,
  );

  @override
  Future<void> loadProfile() {
    return _$loadProfileAsyncAction.run(() => super.loadProfile());
  }

  late final _$loadStoredUserRoleAsyncAction = AsyncAction(
    '_UserStore.loadStoredUserRole',
    context: context,
  );

  @override
  Future<void> loadStoredUserRole() {
    return _$loadStoredUserRoleAsyncAction.run(
      () => super.loadStoredUserRole(),
    );
  }

  late final _$loadUserNameAsyncAction = AsyncAction(
    '_UserStore.loadUserName',
    context: context,
  );

  @override
  Future<String?> loadUserName() {
    return _$loadUserNameAsyncAction.run(() => super.loadUserName());
  }

  late final _$loadUserEmailAsyncAction = AsyncAction(
    '_UserStore.loadUserEmail',
    context: context,
  );

  @override
  Future<String?> loadUserEmail() {
    return _$loadUserEmailAsyncAction.run(() => super.loadUserEmail());
  }

  late final _$logoutAsyncAction = AsyncAction(
    '_UserStore.logout',
    context: context,
  );

  @override
  Future<void> logout({required String bearerToken}) {
    return _$logoutAsyncAction.run(
      () => super.logout(bearerToken: bearerToken),
    );
  }

  late final _$updateProfileDataAsyncAction = AsyncAction(
    '_UserStore.updateProfileData',
    context: context,
  );

  @override
  Future<void> updateProfileData({
    required String name,
    required String email,
    required String phoneNumber,
  }) {
    return _$updateProfileDataAsyncAction.run(
      () => super.updateProfileData(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
      ),
    );
  }

  late final _$updateProfilePhotosAsyncAction = AsyncAction(
    '_UserStore.updateProfilePhotos',
    context: context,
  );

  @override
  Future<void> updateProfilePhotos({
    required File? profileImage,
    required File? signImage,
  }) {
    return _$updateProfilePhotosAsyncAction.run(
      () => super.updateProfilePhotos(
        profileImage: profileImage,
        signImage: signImage,
      ),
    );
  }

  late final _$loadQRCodeAsyncAction = AsyncAction(
    '_UserStore.loadQRCode',
    context: context,
  );

  @override
  Future<void> loadQRCode() {
    return _$loadQRCodeAsyncAction.run(() => super.loadQRCode());
  }

  late final _$checkUserAuthenticationAsyncAction = AsyncAction(
    '_UserStore.checkUserAuthentication',
    context: context,
  );

  @override
  Future<bool> checkUserAuthentication() {
    return _$checkUserAuthenticationAsyncAction.run(
      () => super.checkUserAuthentication(),
    );
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
errorMessage: ${errorMessage},
currentUser: ${currentUser},
qrCode: ${qrCode},
userRole: ${userRole}
    ''';
  }
}
