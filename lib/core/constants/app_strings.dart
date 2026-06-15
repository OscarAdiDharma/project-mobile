/// Centralised UI strings.
///
/// Keeping them here makes future localisation straightforward —
/// swap this class with a generated l10n file when needed.
class AppStrings {
  AppStrings._();

  // ── App ────────────────────────────────────────────────────
  static const String appName = 'TalentIntel AI';
  static const String appTagline = 'AI-Powered Employee Performance Prediction';
  static const String appEdition = 'Enterprise Edition';

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
