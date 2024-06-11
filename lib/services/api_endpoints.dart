class ApiEndPoints {
  // static String baseUrl = 'https://mechanix-api-production.up.railway.app';
  static String baseUrl = 'https://mechanixapi-production.up.railway.app';

  //Authentications
  static String registerUserUrl = '/api/auth/register'; //Registration
  static String verifyEmailUrl =
      '/api/auth/verify-email'; //Verification of email
  static String loginUserUrl = '/api/auth/login'; //Login
  static String sendOtpUrl =
      '/api/auth/send-reset-password-email'; //ForgetPassword & SendOtp
  static String verifyOtpUrl = '/api/auth/verify-reset-otp'; //VerifyOtp
  static String changePasswordUrl =
      '/api/auth/changepassword'; //Change Password
  static String updateProfileUrl = '/api/auth/editprofile';
  static String updateProfilePictureUrl = '/api/auth/editprofilefile';

  //Custom-Task
  static String createCustomTaskUrl = '/api/formbuilder/save-custom-form';
  static String getAllCustomTaskUrl = '/api/formbuilder/getcustomform';
  static String updateCustomTaskUrl = '/api/formbuilder/updatecustomform';
  static String deleteCustomTaskUrl = '/api/formbuilder/deletecustomform';

  //Engine
  static String addEngineUrl = '/api/engine/createenginebrand';
  static String getEngineUrl = '/api/engine/getenginebrandpagination';
  static String getEngineBrandById = '/api/engine/getenginebrandbyid';
  static String updateEngineUrl = '/api/engine/updateenginebrand';
  static String deleteEngineUrl = '/api/engine/deleteenginebrand';
  static String updateEngineImageUrl = '/api/engine/getenginebrandbyid';
}
