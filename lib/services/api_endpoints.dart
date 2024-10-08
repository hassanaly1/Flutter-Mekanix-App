class ApiEndPoints {
  // static String baseUrl = 'https://mechanix-api-production.up.railway.app';
  static String baseUrl = 'https://mechanixapi-production.up.railway.app';

  //Authentications
  static String registerUserUrl = '/api/auth/register';
  static String verifyEmailUrl = '/api/auth/verify-email';
  static String loginUserUrl = '/api/auth/login';
  static String sendOtpUrl = '/api/auth/send-reset-password-email';
  static String verifyOtpUrl = '/api/auth/verify-reset-otp';
  static String changePasswordUrl = '/api/auth/changepassword';
  static String updateProfileUrl = '/api/auth/editprofile';
  static String updateProfilePictureUrl = '/api/auth/editprofilefile';
  static String onAuthStateChangeUrl = '/api/auth/onauthstatechange';
  static String changePasswordInAppUrl =
      '/api/auth/change-password-by-logged-in-user';
  static String logoutUrl = '/api/auth/userLogout';

  //Custom-Task
  static String createCustomTaskUrl = '/api/formbuilder/save-custom-form';
  static String addCustomTaskFilesUrl = '/api/formbuilder/upload-files';
  static String getAllCustomTaskUrl = '/api/formbuilder/getcustomform';
  static String updateCustomTaskUrl = '/api/formbuilder/update-custom-form';
  static String deleteCustomTaskUrl = '/api/formbuilder/delete-custom-form';

  //Analytics
  static String getAnalyticsUrl =
      '/api/formbuilder/total-counts-for-user-activites';

  //Engine
  static String addEngineUrl = '/api/engine/createenginebrand';
  static String getEngineUrl = '/api/engine/getenginebrandpagination';
  static String getEngineBrandById = '/api/engine/getenginebrandbyid';
  static String updateEngineUrl = '/api/engine/updateenginebrand';
  static String deleteEngineUrl = '/api/engine/deleteenginebrand';
  static String updateEngineImageUrl = '/api/engine/updateengineprofile';
}
