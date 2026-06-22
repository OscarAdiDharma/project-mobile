/// Centralised UI strings.
///
/// Keeping them here makes future localisation straightforward —
/// swap this class with a generated l10n file when needed.
class AppStrings {
  AppStrings._();

  // ── App ────────────────────────────────────────────────────
  static const String appName = 'Talent Achive';
  static const String appTagline = 'AI-Powered Employee Performance Prediction';
  static const String appEdition = 'Performance Edition';

  // ── Auth ───────────────────────────────────────────────────
  static const String welcome = 'Welcome';
  static const String loginSubtitle =
      'Sign in to access your performance dashboard';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String rememberMe = 'Remember me';
  static const String forgotPassword = 'Forgot Password?';
  static const String login = 'Login';
  static const String loginAsHrd = 'Login as HRD';
  static const String loginAsEmployee = 'Login as Employee';
  static const String selectRole = 'Select your role to continue';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String registerNow = 'Register Now';

  // ── Register ──────────────────────────────────────────────
  static const String createAccount = 'Create Account';
  static const String registerSubtitle =
      'Fill in your details to get started';
  static const String fullName = 'Full Name';
  static const String confirmPassword = 'Confirm Password';
  static const String department = 'Department';
  static const String selectDepartment = 'Select Department';
  static const String register = 'Register';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String loginNow = 'Login Now';
  static const String passwordMinLength = 'Password must be at least 6 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String pleaseCompleteAllFields = 'Please complete all fields';

  // ── Forgot Password ──────────────────────────────────────
  static const String forgotPasswordTitle = 'Forgot Password';
  static const String forgotPasswordSubtitle =
      'Enter your email address and we\'ll send you a verification code to reset your password.';
  static const String sendVerificationCode = 'Send Verification Code';
  static const String backToLogin = 'Back to Login';
  static const String emailRequired = 'Please enter your email address';
  static const String otpSentSuccess = 'Verification code sent to your email!';

  // ── OTP Verification ─────────────────────────────────────
  static const String otpVerification = 'Verify Code';
  static const String otpSubtitle = 'Enter the 4-digit code sent to';
  static const String verifyCode = 'Verify Code';
  static const String resendCode = 'Resend Code';
  static const String resendCodeIn = 'Resend code in ';
  static const String didntReceiveCode = "Didn't receive the code? ";
  static const String invalidOtp = 'Invalid verification code. Try 1234.';

  // ── Reset Password ───────────────────────────────────────
  static const String resetPassword = 'Reset Password';
  static const String resetPasswordSubtitle =
      'Create a new strong password for your account.';
  static const String newPassword = 'New Password';
  static const String confirmNewPassword = 'Confirm New Password';
  static const String resetPasswordBtn = 'Reset Password';
  static const String passwordResetSuccess =
      'Password reset successfully! Please login with your new password.';
  static const String passwordStrengthWeak = 'Weak';
  static const String passwordStrengthMedium = 'Medium';
  static const String passwordStrengthStrong = 'Strong';

  // ── HRD Dashboard ─────────────────────────────────────────
  static const String executiveSummary = 'Executive Summary';
  static const String executiveSummarySubtitle =
      'Monitor real-time talent performance and distribution metrics.';
  static const String activeEmployees = 'Active Employees';
  static const String avgPredictionScore = 'Avg Prediction Score';
  static const String exemplaryThisMonth = 'Exemplary Candidates This Month';
  static const String departmentPerformance = 'Performance by Department';
  static const String topCandidates = 'Top 5 Exemplary Candidates';
  static const String viewAll = 'View All';
  static const String aiInsightTitle = 'AI Insight Today';
  static const String analyzeLatestData = 'Analyze Latest Data';

  // ── Dataset Management ────────────────────────────────────
  static const String datasetManagement = 'Dataset Management';
  static const String datasetSubtitle =
      'Upload and submit data for AI model training.';
  static const String uploadNewDataset = 'Upload New Dataset';
  static const String dragDropHint = 'Drag and drop file here';
  static const String fileFormatHint =
      'Supports CSV, XLSX format (Max 250MB per file)';
  static const String pickFile = 'Pick File from Computer';
  static const String autoValidation = 'Auto Validation';
  static const String dataEncryption = 'Data Encryption';
  static const String activePipeline = 'Active AI Pipeline';
  static const String datasetHistory = 'Dataset History';
  static const String startProcessing = 'Start Processing';

  // ── Employee Analysis ──────────────────────────────────────
  static const String individualAnalysis = 'Individual Analysis';
  static const String kpiDetails = 'KPI Details';
  static const String developmentRecommendations =
      'Development Recommendations';
  static const String downloadPdf = 'Download PDF Report';

  // ── Employee Dashboard ────────────────────────────────────
  static const String myPerformance = 'My Performance';
  static const String exemplaryChance = 'Exemplary Employee Probability';
  static const String currentTarget = 'Current Target';
  static const String currentStatus = 'Current Status';
  static const String performanceTrend = 'Performance Trend';
  static const String attendance = 'Attendance';
  static const String tasksCompleted = 'Tasks Completed';

  // ── NCF Insights ──────────────────────────────────────────
  static const String strengthsWeaknesses = 'Strengths & Weaknesses Analysis';
  static const String aiPrediction = 'AI Model Prediction';
  static const String actionSteps = 'Action Steps';
  static const String urgent = 'URGENT';
  static const String maintain = 'MAINTAIN';
  static const String suggestedTraining = 'Suggested Training';

  // ── Profile ───────────────────────────────────────────────
  static const String profile = 'Profile';
  static const String trophyRoom = 'Trophy Room';
  static const String editProfile = 'Edit Profile';
  static const String security = 'Security';
  static const String help = 'Help';
  static const String logout = 'Logout';
  static const String saveChanges = 'Save Changes';
  static const String profileUpdated = 'Profile updated successfully!';
  static const String phoneNumber = 'Phone Number';

  // ── Security ──────────────────────────────────────────────
  static const String changePassword = 'Change Password';
  static const String currentPassword = 'Current Password';
  static const String twoFactorAuth = 'Two-Factor Authentication';
  static const String twoFactorAuthDesc =
      'Add an extra layer of security to your account';
  static const String passwordChanged = 'Password changed successfully!';
  static const String loginActivity = 'Login Activity';

  // ── Help ──────────────────────────────────────────────────
  static const String helpCenter = 'Help Center';
  static const String faq = 'Frequently Asked Questions';
  static const String contactSupport = 'Contact Support';
  static const String supportEmail = 'support@talentintel.com';
  static const String supportPhone = '+62 21 1234 5678';

  // ── Settings ──────────────────────────────────────────────
  static const String settingsTitle = 'Settings';
  static const String appearance = 'Appearance';
  static const String darkMode = 'Dark Mode';
  static const String darkModeDesc = 'Switch to dark theme';
  static const String notifications = 'Notifications';
  static const String pushNotifications = 'Push Notifications';
  static const String pushNotificationsDesc = 'Receive push notifications';
  static const String emailNotifications = 'Email Notifications';
  static const String emailNotificationsDesc = 'Receive email updates';
  static const String aboutApp = 'About App';
  static const String version = 'Version';
  static const String appVersion = '1.0.0';
  static const String termsOfService = 'Terms of Service';
  static const String privacyPolicy = 'Privacy Policy';

  // ── Performance History ───────────────────────────────────
  static const String performanceHistory = 'Performance History';
  static const String performanceHistorySubtitle =
      'Track your performance over time';
  static const String monthlyScore = 'Monthly Score';
  static const String overallTrend = 'Overall Trend';
  static const String noHistoryData = 'No history data available';

  // ── Navigation ────────────────────────────────────────────
  static const String dashboard = 'Dashboard';
  static const String leaderboard = 'Leaderboard';
  static const String datasets = 'Datasets';
  static const String userManagement = 'User Management';
  static const String employeePortal = 'Employee Portal';
  static const String settings = 'Settings';

  // ── Bottom Nav (Employee) ─────────────────────────────────
  static const String home = 'Home';
  static const String recommendations = 'Recommendations';
  static const String history = 'History';
}
