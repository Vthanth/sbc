import 'package:app_services/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/core/shared_preference_keys.dart';
import 'package:sbccapp/stores/user.store.dart';

class AppCommonMethods {
  static void logout(BuildContext context, {bool isFromSideDrawer = false}) async {
    final bearerToken = await locator<InstantLocalPersistenceService>().getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      if (isFromSideDrawer) {
        context.pop();
      }

      context.pushReplacement('/');
    } else {
      final _userStore = locator<UserStore>();
      _userStore.logout(bearerToken: bearerToken);
      locator<InstantLocalPersistenceService>().remove(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
      locator<InstantLocalPersistenceService>().remove(SHARED_PREFERENCE_KEY_USER_NAME);
      locator<InstantLocalPersistenceService>().remove(SHARED_PREFERENCE_KEY_USER_EMAIL);
      locator<InstantLocalPersistenceService>().remove(SHARED_PREFERENCE_KEY_USER_ROLE);
      if (isFromSideDrawer) {
        context.pop();
      }
      context.pushReplacement('/');
    }
  }
}
