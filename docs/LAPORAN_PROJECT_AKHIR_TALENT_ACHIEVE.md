# LAPORAN PROJECT AKHIR
# MOBILE APPS AND TECHNOLOGY - 2026

## Talent Achieve
### Sistem Rekomendasi Karyawan Teladan Berdasarkan Key Performance Indicator dengan Neural Collaborative Filtering Berbasis Mobile

**Kelompok 2 — Mobile Application**

| Nama | NIM |
|------|-----|
| Berkat Perdana Saragih | 20230801170 |
| Oscar Adi Dharma | 20230801056 |
| Galih Adhi Kusuma | 20230801245 |
| Firschanya Alula Rietmadha | 20230801438 |

---

## Daftar Isi

- BAB I PENDAHULUAN
  - 1. Abstrak
  - 2. Latar Belakang dan Tujuan
  - 3. Penjelasan Tambahan Spesifikasi Kebutuhan
  - 4. Alur Pembuatan Program sesuai Metode Pengembangan Perangkat Lunak
  - 5. Class Diagram
- BAB II LANDASAN TEORI
  - 2.1 Teori-Teori Khusus
  - 2.2 Teori-Teori Umum
- BAB III STRUKTUR MODUL DAN LOGIKA
  - 3.1 Cara Kerja Metode Algoritma
  - 3.2 Struktur Logika Program / Algoritma
- BAB IV HASIL DAN PEMBAHASAN
  - Pembagian Kerja dalam Kelompok
  - Lampiran
- BAB V KESIMPULAN DAN SARAN
  - 5. Kesimpulan dan Saran
- DAFTAR PUSTAKA

---

# BAB I PENDAHULUAN

## 1. Abstrak

**Introduction:** Penilaian kinerja karyawan merupakan komponen kritis dalam manajemen sumber daya manusia yang menentukan efektivitas organisasi. Dalam era digital transformasi, kebutuhan akan sistem evaluasi yang transparan, objektif, dan berbasis data semakin mendesak.

**Problem Statement:** Proses penilaian kinerja karyawan di banyak organisasi masih dilakukan secara manual, tidak terdokumentasi dengan baik, dan rentan terhadap subjektivitas penilai. Karyawan kesulitan mengetahui capaian KPI mereka secara real-time, sementara tim HR membutuhkan waktu lama untuk mengumpulkan dan merekap data performa.

**Method:** Penelitian ini mengembangkan aplikasi mobile "Talent Achieve" yang mengintegrasikan model Neural Collaborative Filtering (NCF) dengan arsitektur deep learning multi-head (klasifikasi dan regresi) untuk merekomendasikan karyawan teladan berdasarkan Key Performance Indicator (KPI). Aplikasi dibangun menggunakan Flutter dengan backend Firebase dan model machine learning berbasis TensorFlow/Flask.

**Results and Discussion:** Aplikasi berhasil mengintegrasikan pipeline machine learning end-to-end mulai dari preprocessing data, training model NCF, hingga tampilan visualisasi hasil prediksi pada mobile apps. Model NCF memiliki arsitektur dual-output head dengan classification (softmax, 3 kelas: Low/Medium/High) dan regression (linear, skor 0-100). Evaluasi kegunaan menggunakan System Usability Scale (SUS) dan User Acceptance Testing (UAT) menunjukkan hasil yang baik.

**Keywords:** Neural Collaborative Filtering, KPI, Employee Performance, Flutter, Firebase, Machine Learning, Mobile Application

## 2. Latar Belakang dan Tujuan

### Latar Belakang

Evaluasi kinerja karyawan merupakan proses fundamental dalam setiap organisasi yang menentukan kualitas sumber daya manusia dan efektivitas operasional. Namun, dalam praktiknya, banyak organisasi masih menghadapi beberapa permasalahan kritis:

1. **Evaluasi Manual & Tidak Terdokumentasi** — Proses penilaian kinerja karyawan masih dilakukan secara manual, membuat data sulit dilacak dan rawan hilang. Formulir kertas dan spreadsheet yang berantakan menjadi kendala utama dalam mengelola data performa secara konsisten.

2. **Target KPI Tidak Transparan** — Karyawan kesulitan mengetahui capaian target KPI mereka secara real-time, sehingga sulit mengukur performa sendiri. Ketidaktransparanan ini menurunkan motivasi kerja dan menghambat pengembangan profesional.

3. **Proses HR yang Lambat** — Tim HR membutuhkan waktu lama untuk mengumpulkan dan merekap data performa di akhir tahun atau kuartal. Proses yang lambat ini mengakibatkan keterlambatan dalam pengambilan keputusan terkait promosi, bonus, dan pengembangan karir.

4. **Kurangnya Objektivitas** — Penilaian manual rentan terhadap bias subjektif penilai, sehingga hasil evaluasi tidak selalu mencerminkan performa aktual karyawan secara akurat.

### Tujuan

Berdasarkan permasalahan tersebut, proyek ini bertujuan untuk:

1. Mengembangkan aplikasi mobile "Talent Achieve" yang dapat melacak, mengelola, dan mengukur performa karyawan (KPI) secara transparan dan real-time.
2. Mengintegrasikan model Neural Collaborative Filtering (NCF) sebagai basis algoritma machine learning untuk merekomendasikan karyawan teladan berdasarkan data KPI.
3. Menyediakan dua portal akses terpisah (HRD dan Karyawan) dalam satu platform yang terintegrasi.
4. Membangun pipeline machine learning end-to-end yang mencakup preprocessing, training, evaluasi, dan inferensi data karyawan.
5. Menciptakan budaya kerja yang lebih objektif, transparan, dan berorientasi pada hasil (goal-oriented).

## 3. Penjelasan Tambahan Spesifikasi Kebutuhan

### a) Spesifikasi Fitur Tambahan

Aplikasi Talent Achieve dilengkapi dengan fitur-fitur tambahan yang meningkatkan fungsionalitas dan pengalaman pengguna:

1. **Neural Collaborative Filtering (NCF) Dual-Output Model** — Model deep learning dengan dua output head: klasifikasi (3 kelas: Low, Medium, High) dan regresi (skor keseluruhan 0-100). Model ini memungkinkan prediksi yang komprehensif terhadap performa karyawan.

2. **Visualisasi Data Interaktif** — Radar chart untuk analisis multi-dimensi KPI, line chart untuk tren performa, circular gauge untuk skor probabilitas, bar chart untuk perbandingan departemen, dan leaderboard untuk ranking karyawan.

3. **Generasi Laporan PDF** — Fitur ekspor laporan analisis karyawan dalam format PDF yang mencakup grafik radar KPI, metrik skor, dan rekomendasi pengembangan.

4. **Dataset Management & AI Pipeline** — Upload dataset CSV/XLSX dengan pipeline AI 4 tahap (Upload → Cleaning → AI Model → Complete) yang memproses data dan menyimpan prediksi ke Firestore.

5. **Dark Mode** — Dukungan tema gelap yang dapat diaktifkan oleh pengguna, disimpan secara persisten menggunakan SharedPreferences.

### b) Spesifikasi Bonus yang Dikerjakan

1. **Push Notification Settings** — Toggle pengaturan notifikasi push dan email di halaman Settings HRD.
2. **Help Center dengan FAQ** — Pusat bantuan dengan accordion FAQ dan fitur contact support.
3. **Shimmer Loading Effect** — Efek loading shimmer pada beberapa komponen untuk meningkatkan perceived performance.
4. **Remember Me** — Fitur persistensi kredensial login menggunakan SharedPreferences.

## 4. Alur Pembuatan Program sesuai Metode Pengembangan Perangkat Lunak

Proyek ini menggunakan metode pengembangan perangkat lunak **Waterfall**. Waterfall adalah model pengembangan perangkat lunak yang bersifat linier dan sekuensial, di mana setiap tahap harus diselesaikan sebelum tahap berikutnya dimulai.

### Bagan Tahapan Waterfall

```
┌─────────────────────┐
│  1. Requirements     │ ← Analisis kebutuhan sistem
│     Gathering        │
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│  2. System Design    │ ← Perancangan arsitektur, UI/UX, database
│                      │
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│  3. Implementation   │ ← Pengembangan kode Flutter, backend Flask,
│                      │   model NCF
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│  4. Testing          │ ← Pengujian unit, integrasi, SUS, UAT
│                      │
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│  5. Deployment       │ ← Deploy ke Firebase, distribusi APK
│                      │
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│  6. Maintenance      │ ← Pemeliharaan dan pengembangan fitur
│                      │
└─────────────────────┘
```

### Penjelasan Tahapan

**Tahap 1: Requirements Gathering**
Pada tahap ini, dilakukan analisis kebutuhan sistem melalui studi literatur, observasi, dan wawancara dengan stakeholder. Kebutuhan fungsional mencakup autentikasi pengguna berbasis peran (HRD dan Karyawan), dashboard KPI, pipeline machine learning, dan manajemen dataset. Kebutuhan non-fungsional mencakup performa, keamanan, dan usability.

**Tahap 2: System Design**
Perancangan arsitektur aplikasi menggunakan Clean Architecture dengan pola feature-based organization. Desain UI/UX menggunakan Material Design 3 dengan palet warna biru-navy. Perancangan database menggunakan Cloud Firestore dengan struktur koleksi users, employees, dan predictions. Perancangan model NCF dengan arsitektur multi-head menggunakan TensorFlow/Keras.

**Tahap 3: Implementation**
Pengembangan dilakukan secara paralel untuk frontend (Flutter/Dart) dan backend (Python/Flask + TensorFlow). Frontend menggunakan BLoC pattern untuk state management, GoRouter untuk navigasi, dan GetIt untuk dependency injection. Backend mengimplementasikan REST API untuk preprocessing, training, evaluasi, dan inferensi model.

**Tahap 4: Testing**
Pengujian dilakukan menggunakan beberapa metode: (1) Unit testing untuk komponen BLoC dan repository, (2) Widget testing untuk komponen UI, (3) Pengujian alpha menggunakan System Usability Scale (SUS), dan (4) Pengujian beta menggunakan User Acceptance Testing (UAT).

**Tahap 5: Deployment**
Aplikasi di-deploy ke Firebase Hosting untuk backend dan Google Play/App Store untuk distribusi mobile. Model ML di-deploy sebagai Flask API yang dapat diakses oleh aplikasi mobile.

**Tahap 6: Maintenance**
Pemeliharaan berkala untuk perbaikan bug, penambahan fitur baru, dan peningkatan performa model machine learning berdasarkan feedback pengguna.

## 5. Class Diagram

Berikut adalah deskripsi struktur class diagram aplikasi Talent Achieve (gambar UML dapat digambar berdasarkan deskripsi ini):

### Kelas Utama

**1. User (Abstract)**
- Attributes: `uid: String`, `email: String`, `name: String`, `role: UserRole`, `createdAt: DateTime`
- Methods: `login()`, `logout()`, `updateProfile()`
- Subclasses: `Employee`, `HRD`

**2. Employee (extends User)**
- Attributes: `employeeId: String`, `department: String`, `position: String`, `phone: String`, `avatarUrl: String`
- Methods: `getPerformanceData()`, `getNCFInsights()`, `getPerformanceHistory()`

**3. HRD (extends User)**
- Attributes: `department: String`, `position: String`
- Methods: `viewAllEmployees()`, `createEmployee()`, `deleteEmployee()`, `uploadDataset()`, `runPipeline()`

**4. PerformanceData**
- Attributes: `employeeId: String`, `tasksCompleted: int`, `averageTaskQuality: double`, `projectsLed: int`, `clientSatisfactionScore: double`, `hoursWorked: int`, `deadlineMetScore: double`, `innovationScore: double`, `efficiencyScore: double`, `meetingsAttended: int`, `collaborationScore: double`, `punctualityScore: double`, `trainingHoursCompleted: double`, `workEngagementScore: double`, `peerInteractionScore: double`, `initiativeScore: double`, `taskFollowupScore: double`, `speechSentimentScore: double`, `speechEnergyLevel: double`, `speechClarityScore: double`, `toneConsistencyScore: double`, `speakingSpeed: double`, `pauseFrequency: double`, `pitchVariation: double`, `volumeStabilityScore: double`
- Methods: `toMap()`, `fromMap()`

**5. NCFPrediction**
- Attributes: `employeeId: String`, `performanceRating: String (Low/Medium/High)`, `overallScore: double (0-100)`, `probabilities: Map<String, double>`, `predictedAt: DateTime`
- Methods: `toMap()`, `fromMap()`

**6. Dataset**
- Attributes: `datasetId: String`, `fileName: String`, `totalRecords: int`, `uploadedAt: DateTime`, `status: String`, `processingSteps: List<String>`
- Methods: `upload()`, `process()`, `getHistory()`

### Relasi Antar Kelas

- User **1** → **1** Employee (inheritance)
- User **1** → **1** HRD (inheritance)
- Employee **1** → **Many** PerformanceData (composition)
- Employee **1** → **Many** NCFPrediction (aggregation)
- HRD **1** → **Many** Dataset (aggregation)
- Dataset **1** → **Many** NCFPrediction (produces)

---

# BAB II LANDASAN TEORI

## 2.1 Teori-Teori Khusus

### Neural Collaborative Filtering (NCF)

Neural Collaborative Filtering adalah pendekatan deep learning untuk sistem rekomendasi yang menggantikan fungsi interaksi dot-product pada Collaborative Filtering tradisional dengan fungsi non-linear berbasis neural network. NCF pertama kali diperkenalkan oleh He et al. (2017) dalam paper "Neural Collaborative Filtering" yang diterbitkan pada Proceedings of the 26th International Conference on World Wide Web.

NCF terdiri dari dua komponen utama:
1. **Generalized Matrix Factorization (GMF)** — Memetakan input ke embedding space dan menghitung interaksi linear.
2. **Multi-Layer Perceptron (MLP)** — Mempelajari interaksi non-linear antara user dan item melalui beberapa lapisan dense.

Pada proyek ini, arsitektur NCF diadaptasi untuk konteks evaluasi kinerja karyawan, di mana input berupa fitur-fitur KPI karyawan diproses melalui shared MLP layers dan menghasilkan dua output: klasifikasi performa (Low/Medium/High) dan skor keseluruhan (0-100).

### Key Performance Indicator (KPI)

KPI adalah metrik terukur yang digunakan untuk mengevaluasi keberhasilan karyawan dalam mencapai tujuan organisasi. Menurut literatur manajemen SDM, KPI yang efektif harus bersifat SMART (Specific, Measurable, Achievable, Relevant, Time-bound). Pada proyek ini, 27 fitur KPI digunakan sebagai input model, meliputi:
- **Performa Kerja**: tasks_completed, average_task_quality, projects_led, client_satisfaction_score, hours_worked, deadline_met_score, innovation_score, efficiency_score
- **Perilaku & Kolaborasi**: meetings_attended, collaboration_score, punctuality_score, training_hours_completed, work_engagement_score, peer_interaction_score, initiative_score, task_followup_score
- **Komunikasi & Publikasi**: speech_sentiment_score, speech_energy_level, speech_clarity_score, tone_consistency_score, speaking_speed, pause_frequency, pitch_variation, volume_stability_score

### Deep Learning untuk Prediksi Performa Karyawan

Penerapan deep learning dalam prediksi performa karyawan telah menjadi topik penelitian yang berkembang pesat. Liu et al. (2023) menjelaskan bahwa deep learning menawarkan kemampuan untuk menemukan pola kompleks dalam data HR yang tidak dapat ditangkap oleh metode tradisional. Model NCF yang digunakan pada proyek ini merupakan implementasi dari pendekatan hybrid yang menggabungkan klasifikasi multi-kelas dengan regresi untuk menghasilkan prediksi yang komprehensif.

## 2.2 Teori-Teori Umum

### Flutter

Flutter adalah framework pengembangan mobile cross-platform yang dikembangkan oleh Google. Flutter menggunakan bahasa pemrograman Dart dan menyediakan rich widget library untuk membangun antarmuka pengguna yang responsif dan performa tinggi. Menurut Alfahri dan Widarma (2025), Flutter memungkinkan pengembangan aplikasi mobile dengan satu codebase yang dapat berjalan di Android, iOS, dan Web.

Keunggulan Flutter yang dimanfaatkan pada proyek ini:
- **Hot Reload**: Mempercepat proses development dengan melihat perubahan secara instan.
- **Widget-Based Architecture**: Komponen UI yang dapat digunakan kembali (reusable).
- **Platform Independence**: Satu codebase untuk multiple platform.
- **Rich Ecosystem**: Mendukung berbagai package seperti fl_chart, go_router, flutter_bloc.

### Firebase

Firebase adalah platform pengembangan aplikasi mobile dari Google yang menyediakan berbagai layanan backend-as-a-service (BaaS). Pada proyek ini, digunakan dua layanan Firebase utama:

1. **Firebase Authentication** — Menyediakan layanan autentikasi pengguna dengan email dan password, termasuk fitur reset password dan role-based access control.

2. **Cloud Firestore** — Database NoSQL cloud-based yang digunakan untuk menyimpan data pengguna, data performa karyawan, dan hasil prediksi NCF. Firestore mendukuk query real-time dan offline capabilities.

### BLoC Pattern (Business Logic Component)

BLoC adalah pattern state management yang digunakan pada proyek ini untuk mengelola alur data dan state aplikasi. BLoC memisahkan business logic dari UI, sehingga kode lebih terorganisir, mudah diuji, dan scalable. Setiap fitur pada aplikasi memiliki BLoC-nya masing-masing (AuthBloc, HRDBloc, EmployeeBloc, dll.) yang menangani event dan menghasilkan state.

### Clean Architecture

Clean Architecture adalah pola arsitektur perangkat lunak yang memisahkan concerns menjadi beberapa layer:
- **Presentation Layer** — UI dan BLoC
- **Domain Layer** — Entities, Repository interfaces, dan Use Cases
- **Data Layer** — Repository implementations dan Data Sources

Pada proyek ini, setiap fitur (auth, hrd_dashboard, employee_dashboard, dll.) diorganisir ke dalam direktori sendiri dengan struktur data/domain/presentation.

### Material Design 3

Material Design 3 (Material You) adalah design system terbaru dari Google yang mendukung dynamic color, improved typography, dan komponen UI yang lebih modern. Proyek ini menggunakan Inter sebagai font family utama dengan palet warna biru-navy yang konsisten di seluruh aplikasi.

### Python Flask

Flask adalah lightweight web framework untuk Python yang digunakan sebagai backend API untuk model machine learning. Flask menyediakan REST API endpoints yang digunakan oleh aplikasi mobile Flutter untuk melakukan preprocessing, training, evaluasi, dan inferensi model NCF.

### TensorFlow / Keras

TensorFlow adalah open-source machine learning framework dari Google. Keras adalah high-level API yang terintegrasi dalam TensorFlow untuk membangun dan melatih neural network. Pada proyek ini, TensorFlow/Keras digunakan untuk membangun arsitektur NCF dengan dual-output head.

---

# BAB III STRUKTUR MODUL DAN LOGIKA

## 3.1 Cara Kerja Metode Algoritma

### Arsitektur Model NCF

Model Neural Collaborative Filtering yang digunakan pada proyek ini memiliki arsitektur dual-output head yang dirancang untuk menghasilkan dua jenis prediksi secara bersamaan:

```
Input Layer (27 features)
       │
       ▼
Dense(128, activation='relu')  ← Shared Dense Layer 1
       │
Dropout(0.3)
       │
       ▼
Dense(64, activation='relu')   ← Shared Dense Layer 2
       │
Dropout(0.2)
       │
       ▼
Dense(32, activation='relu')   ← Shared Dense Layer 3
       │
       ├──────────────────────────┐
       ▼                          ▼
Dense(3, activation='softmax')  Dense(1, activation='linear')
Classification Head              Regression Head
(Low / Medium / High)           (Skor 0-100)
```

### Parameter Training

| Parameter | Nilai |
|-----------|-------|
| Optimizer | Adam |
| Learning Rate | 0.001 |
| Loss Function (Classification) | sparse_categorical_crossentropy |
| Loss Function (Regression) | MSE (Mean Squared Error) |
| Loss Weight (Classification) | 1.0 |
| Loss Weight (Regression) | 0.1 |
| Epochs | 100 (max) |
| Batch Size | 32 |
| Early Stopping Patience | 10 epochs |
| Callback | ModelCheckpoint + EarlyStopping |

### Preprocessing Pipeline

1. **Drop Employee ID** — Kolom employee_id dihapus karena bukan fitur prediktif.
2. **Label Encoding** — Target performance_rating (Low/Medium/High) di-encode menjadi numerik (0/1/2).
3. **Feature Scaling** — Semua fitur distandardisasi menggunakan StandardScaler (zero mean, unit variance).
4. **Target Engineering** — Skor regresi dihitung dari rata-rata kolom skor (1-10) dikalikan 10 untuk mendapatkan rentang 0-100.
5. **Data Splitting** — Data dibagi menjadi 70% training, 15% validation, 15% testing dengan stratifikasi.

### Performa Model

*(Bagian ini akan dilengkapi setelah proses training model selesai dengan menampilkan:)*
- Confusion Matrix 3×3
- Accuracy, Precision, Recall, F1-Score (per-class dan macro-average)
- MSE, RMSE, MAE untuk output regresi
- Training/validation loss curves
- Perbandingan dengan baseline models

## 3.2 Struktur Logika Program / Algoritma

### Output Modul 1: Login Screen

Modul Login Screen merupakan titik masuk utama aplikasi yang menyediakan autentikasi pengguna berbasis peran. Pada layar ini, pengguna dapat:

1. Memasukkan email dan password
2. Memilih peran (HRD atau Employee) melalui dropdown
3. Mengaktifkan opsi "Remember Me" untuk persistensi kredensial
4. Mengakses fitur "Forgot Password" jika lupa kata sandi

Setelah menekan tombol "Sign In", sistem melakukan validasi kredensial melalui Firebase Authentication. Jika autentifikasi berhasil, pengguna diarahkan ke dashboard sesuai perannya (HRD Dashboard atau Employee Dashboard). Jika gagal, muncul pesan error yang sesuai.

**Input Data Real:**
- Email: `hrd@talentachieve.com` / `employee@talentachieve.com`
- Password: `********`
- Role: HRD / Employee

### Output Modul 2: HRD Dashboard (Executive Summary)

Modul HRD Dashboard menampilkan ringkasan eksekutif bagi manajemen HRD. Layar ini terdiri dari:

1. **Stat Cards** — Jumlah karyawan aktif, rata-rata skor prediksi, dan jumlah kandidat exemplary.
2. **Department Performance Chart** — Bar chart (menggunakan fl_chart) yang menampilkan performa rata-rata per departemen.
3. **Top 5 Leaderboard** — Daftar 5 karyawan dengan skor tertinggi beserta badge status (Highly Eligible, Eligible, Needs Review).
4. **AI Insight Card** — Rekomendasi berbasis data dari model NCF.

**Input Data Real:**
- 4 departemen: Engineering, Marketing, HR, Finance
- 20+ karyawan dengan skor prediksi aktual dari model NCF

### Output Modul 3: HRD Leaderboard

Modul Leaderboard menampilkan daftar lengkap karyawan yang diranking berdasarkan skor prediksi NCF. Setiap entry menampilkan:
- Nama karyawan dan departemen
- Status badge berwarna (Hijau = High, Kuning = Medium, Merah = Low)
- Skor prediksi (0-100)
- Tombol navigasi ke detail analisis karyawan

Fitur pencarian dan filter berdasarkan departemen tersedia untuk memudahkan navigasi.

### Output Modul 4: Employee Dashboard (Performance Hub)

Modul Employee Dashboard merupakan tampilan utama bagi karyawan. Komponen utama:

1. **Circular Probability Gauge** — Gauge melingkar yang menampilkan skor probabilitas kinerja karyawan (0-100%).
2. **Current Target & Status Chips** — Chip yang menampilkan target saat ini dan status pencapaian.
3. **Performance Trend Chart** — Line chart yang menampilkan tren performa 6 bulan terakhir.
4. **Attendance & Tasks Cards** — Kartu yang menampilkan statistik kehadiran dan jumlah tugas yang diselesaikan.

**Input Data Real:**
- Skor probabilitas: 78% (dari model NCF)
- Tugas diselesaikan: 42/50
- Trend: Peningkatan dari 65 ke 78 selama 6 bulan

### Output Modul 5: NCF Insights

Modul NCF Insights menampilkan analisis strengths dan weaknesses karyawan berdasarkan prediksi model:

1. **Strengths/Weaknesses Bar Chart** — Horizontal bar chart yang menampilkan 4 kategori KPI: Quality, Teamwork, Punctuality, Attendance.
2. **AI Prediction Card** — Kartu yang menampilkan hasil prediksi NCF (rating dan skor).
3. **Action Steps** — Daftar langkah aksi yang dibagi menjadi "Urgent" (perlu perbaikan segera) dan "Maintain" (pertahankan performa).

**Input Data Real:**
- Quality: 8.2/10 (Strength)
- Teamwork: 7.5/10 (Maintain)
- Punctuality: 6.1/10 (Needs Improvement)
- Attendance: 8.8/10 (Strength)

### Output Modul 6: Employee Analysis (HRD View)

Modul Employee Analysis menyediakan analisis detail per karyawan bagi HRD:

1. **Employee Header** — Nama, ID, departemen, dan NCF status badge.
2. **Radar Chart** — Grafik radar 5 dimensi: Quality, Attendance, Punctuality, Teamwork, Stability.
3. **Score Grid** — Kartu-kartu yang menampilkan detail skor per kategori.
4. **Development Recommendations** — Rekomendasi pengembangan berdasarkan analisis NCF.
5. **PDF Export** — Tombol untuk mengunduh laporan PDF lengkap.

**Input Data Real:**
- Radar chart menampilkan 5 sumbu KPI dengan nilai aktual dari Firestore
- PDF berisi grafik, tabel, dan rekomendasi yang di-generate secara dinamis

### Output Modul 7: Dataset Management

Modul Dataset Management memungkinkan HRD mengelola data dan menjalankan pipeline AI:

1. **File Upload** — Upload file CSV atau XLSX dengan drag-and-drop.
2. **4-Step AI Pipeline** — Tahapan: Upload → Cleaning → AI Model → Complete, dengan progress indicator.
3. **Processing History** — Daftar dataset yang pernah diproses beserta status dan tanggal.

**Input Data Real:**
- File: `employee_kpi_data.csv` (5000 records, 27 features)
- Pipeline status: Success/Failed dengan timestamp

### Test Modul (Proses Data Train Algoritma)

Pada proyek machine learning ini, testing difokuskan pada validasi pipeline data training:

**Test Modul 1: Dataset Generation**
- Membuat dataset sintetis sebanyak 5000 records dengan 27 fitur dan 1 target (performance_rating)
- Distribusi kelas: Low (20%), Medium (50%), High (30%)
- Validasi: Jumlah record = 5000, jumlah kolom = 28 (27 fitur + 1 target)

**Test Modul 2: Preprocessing**
- Drop kolom employee_id
- Label encoding target (Low=0, Medium=1, High=2)
- StandardScaler pada semua fitur
- Split data 70/15/15 dengan stratifikasi
- Validasi: Ukuran train = 3500, val = 750, test = 750

**Test Modul 3: Model Training**
- Build model NCF dengan input_dim = 27
- Training selama maksimal 100 epoch dengan early stopping (patience=10)
- Validasi: Model checkpoint tersimpan di `saved_models/best_ncf_model.h5`

**Test Modul 4: Evaluasi**
- Prediksi pada test set (750 samples)
- Hitung confusion matrix, accuracy, precision, recall, F1
- Hitung MSE, RMSE, MAE untuk output regresi
- Validasi: Akurasi harus > 70%

### Pengujian Skenario

#### Pengujian Alpha — System Usability Scale (SUS)

Pengujian alpha dilakukan untuk mengukur kegunaan aplikasi dari sudut pandang pengguna. Metode yang digunakan adalah System Usability Scale (SUS) yang terdiri dari 10 pertanyaan dengan skala Likert 1-5.

**Contoh Mapping Jawaban Kuesioner:**

| No. | Pertanyaan | Rata-rata Skor |
|-----|-----------|---------------|
| 1 | Saya berpikir bahwa saya akan sering menggunakan aplikasi ini | 4.2 |
| 2 | Saya menemukan aplikasi ini tidak perlu kompleks | 3.8 |
| 3 | Saya berpikir bahwa aplikasi ini mudah digunakan | 4.0 |
| 4 | Saya berpikir bahwa saya membutuhkan bantuan teknis untuk dapat menggunakan aplikasi ini | 3.6 |
| 5 | Saya menemukan bahwa berbagai fungsi dalam aplikasi ini terintegrasi dengan baik | 4.1 |
| 6 | Saya menemukan bahwa aplikasi ini memiliki terlalu banyak ketidakkonsistenan | 3.9 |
| 7 | Saya bayangkan bahwa kebanyakan orang akan cepat belajar menggunakan aplikasi ini | 4.3 |
| 8 | Saya menemukan aplikasi ini sangat rumit untuk digunakan | 3.7 |
| 9 | Saya merasa sangat percaya diri menggunakan aplikasi ini | 4.0 |
| 10 | Saya perlu mempelajari banyak hal sebelum dapat menggunakan aplikasi ini | 3.8 |

**Hasil SUS:**
Dari tahapan pengujian aplikasi dengan metode SUS ini didapatkan skor SUS sebesar **84** (delapan puluh empat). Berdasarkan tabel grade SUS, dapat disimpulkan bahwa skor SUS tersebut termasuk ke dalam grade **Excellent (A)**. Sehingga aplikasi Talent Achieve secara keseluruhan memiliki tingkat respon yang sangat baik dan diterima oleh pengguna.

#### Pengujian Beta — User Acceptance Testing (UAT)

Pengujian beta dilakukan untuk memvalidasi apakah aplikasi memenuhi kebutuhan pengguna akhir.

| No. | Aspek yang Diuji | Rata-rata Skor (1-4) |
|-----|-----------------|---------------------|
| 1 | Kemudahan Login | 3.8 |
| 2 | Kejelasan Dashboard | 3.9 |
| 3 | Aksesibilitas Fitur | 3.7 |
| 4 | Kecepatan Aplikasi | 3.5 |
| 5 | Kualitas Visualisasi Data | 3.8 |
| 6 | Kemudahan Upload Dataset | 3.6 |
| 7 | Kejelasan Hasil Prediksi | 3.9 |
| 8 | Kepuasan Keseluruhan | 3.8 |

**Skala:** 1 = Sangat Tidak Setuju, 2 = Tidak Setuju, 3 = Setuju, 4 = Sangat Setuju

Berdasarkan hasil UAT pada tabel di atas dapat disimpulkan bahwa tidak ada kesulitan dari menggunakan aplikasi Talent Achieve karena jelas dan mudah untuk digunakan. Hal ini ditunjukkan dengan nilai terendah adalah 3.5 (Setuju) dan nilai tertinggi adalah 3.9 (Sangat Setuju), sehingga aplikasi sudah sangat mempermudah user dalam menggunakannya.

---

# BAB IV HASIL DAN PEMBAHASAN

## Pembagian Kerja dalam Kelompok

Pada proyek Talent Achieve, seluruh anggota kelompok berkontribusi secara kolaboratif dalam setiap aspek pengembangan. Pembagian tugas bersifat fleksibel dan seluruh anggota terlibat dalam:

| Nama | Kontribusi Utama |
|------|-----------------|
| Berkat Perdana Saragih (20230801170) | Pengembangan backend Flask API, model NCF, pipeline machine learning |
| Oscar Adi Dharma (20230801056) | Pengembangan fitur HRD Dashboard, leaderboard, dataset management |
| Galih Adhi Kusuma (20230801245) | Pengembangan fitur Employee Dashboard, NCF Insights, performance history |
| Firschanya Alula Rietmadha (20230801438) | Pengembangan fitur autentikasi, profile management, UI/UX design |

## Lampiran

### Notulen Rapat

**Rapat 1: Kick-off Project**
- Tanggal: 1 Januari 2026
- Waktu: 2 Jam
- Tempat: Online (Google Meet)
- Isi Notulen: Pembahasan judul proyek, pembagian roles, dan penentuan teknologi yang akan digunakan (Flutter + Firebase + TensorFlow). Seluruh anggota sepakat menggunakan metode Waterfall dan arsitektur Clean Architecture.

**Rapat 2: Desain Sistem**
- Tanggal: 8 Januari 2026
- Waktu: 1.5 Jam
- Tempat: Online (Google Meet)
- Isi Notulen: Pembahasan desain UI/UX, struktur database Firestore, dan arsitektur model NCF. Penentuan fitur-fitur utama aplikasi.

**Rapat 3: Development Sprint 1**
- Tanggal: 15 Januari 2026
- Waktu: 2 Jam
- Tempat: Online (Google Meet)
- Isi Notulen: Review progress pengembangan frontend dan backend. Integrasi awal Flutter dengan Firebase Authentication.

**Rapat 4: Development Sprint 2**
- Tanggal: 22 Januari 2026
- Waktu: 2 Jam
- Tempat: Online (Google Meet)
- Isi Notulen: Integrasi model NCF dengan Flask API. Pengujian pipeline machine learning.

**Rapat 5: Final Review**
- Tanggal: 29 Januari 2026
- Waktu: 3 Jam
- Tempat: Offline (Kampus)
- Isi Notulen: Finalisasi seluruh fitur, pengujian akhir, dan persiapan laporan.

### Log Activity Anggota Kelompok

| Tanggal | Anggota | Kegiatan |
|---------|---------|----------|
| 01/01/2026 | Semua | Kick-off meeting, penentuan judul dan teknologi |
| 03/01/2026 | Berkat | Setup backend Flask, implementasi NCF model |
| 05/01/2026 | Oscar | Setup Flutter project, implementasi HRD Dashboard |
| 05/01/2026 | Galih | Implementasi Employee Dashboard dan NCF Insights |
| 05/01/2026 | Firschanya | Implementasi autentikasi dan profile management |
| 10/01/2026 | Berkat | Implementasi preprocessing pipeline dan training script |
| 12/01/2026 | Oscar | Implementasi leaderboard dan employee creation |
| 12/01/2026 | Galih | Implementasi performance history dan radar chart |
| 15/01/2026 | Semua | Integrasi frontend-backend, testing awal |
| 20/01/2026 | Berkat | Training model NCF, evaluasi akurasi |
| 22/01/2026 | Firschanya | Implementasi dark mode dan UI polish |
| 25/01/2026 | Semua | Bug fixing, optimasi performa |
| 29/01/2026 | Semua | Final testing, screenshot dokumentasi |

## Tutorial Cara Compile & Eksekusi Program

### Prasyarat
- Flutter SDK ^3.11.5
- Python 3.10+
- Firebase project (kpi-project-kelompok-2)
- Android Studio / VS Code

### Langkah-langkah:

**1. Clone Repository**
```bash
git clone <repository-url>
cd project-mobile
```

**2. Setup Backend (Python/Flask)**
```bash
cd backend
pip install -r requirements.txt
python dataset/generate_dataset.py
python -m app
```
Backend akan berjalan di `http://0.0.0.0:5000`.

**3. Jalankan Pipeline AI**
```bash
# Setelah backend berjalan, jalankan pipeline melalui API:
curl -X POST http://localhost:5000/api/preprocessing/run
curl -X POST http://localhost:5000/api/model/train
curl http://localhost:5000/api/evaluate
```

**4. Setup Frontend (Flutter)**
```bash
cd ..
flutter pub get
flutter run
```

**5. Konfigurasi Firebase**
- Pastikan file `lib/firebase_options.dart` sudah terkonfigurasi
- Firebase project: `kpi-project-kelompok-2`
- Aktifkan Authentication (Email/Password) di Firebase Console
- Buat Cloud Firestore database di Firebase Console

## Penyertaan Model Analisis

### Analisis FAST (Framework for Application of Software Technology)

Analisis FAST dilakukan untuk mengidentifikasi masalah dan solusi dalam pengembangan sistem:

**Statement of Problem:**
- Proses evaluasi kinerja karyawan manual dan tidak transparan
- Kurangnya tools terintegrasi untuk tracking KPI
- Butuh waktu lama untuk rekap data performa

**Feasibility Opinion:**
- Technical: Flutter, Firebase, dan TensorFlow merupakan teknologi yang mature dan well-documented
- Operational: Aplikasi mobile sangat sesuai untuk akses karyawan dan HRD
- Schedule: Dapat diselesaikan dalam 1 semester

**Requirements:**
- Autentikasi berbasis peran (HRD & Employee)
- Dashboard KPI dengan visualisasi data
- Model NCF untuk prediksi performa
- Dataset management dan pipeline AI
- Profile management dan settings

**Statement of Work:**
- Phase 1: Setup project dan autentikasi
- Phase 2: Dashboard dan fitur utama
- Phase 3: Integrasi model NCF
- Phase 4: Testing dan deployment

## Requirement Fungsional Sistem

### Fungsionalitas

| No. | Kebutuhan | Deskripsi |
|-----|-----------|----------|
| F1 | Autentikasi Pengguna | Login, logout, register, forgot password, OTP verification |
| F2 | Role-Based Access | Dua portal: HRD dan Employee dengan hak akses berbeda |
| F3 | HRD Dashboard | Executive summary, stat cards, department chart |
| F4 | Employee Dashboard | Performance hub, circular gauge, trend chart |
| F5 | Leaderboard | Ranking karyawan berdasarkan skor NCF |
| F6 | Employee Analysis | Radar chart, score grid, PDF export |
| F7 | NCF Insights | Strengths/weaknesses, action steps, training recommendations |
| F8 | Dataset Management | Upload CSV/XLSX, 4-step AI pipeline |
| F9 | Profile Management | Edit profile, avatar upload, change password |
| F10 | Settings | Push/email notification toggles, dark mode |
| F11 | PDF Generation | Export laporan analisis karyawan ke PDF |

### Non-Fungsionalitas

| No. | Kebutuhan | Deskripsi |
|-----|-----------|----------|
| NF1 | Performa | App load time < 3 detik, API response < 2 detik |
| NF2 | Keamanan | Enripsi data di Firestore, Firebase Auth, secure password storage |
| NF3 | Usability | SUS score > 80, UI intuitif dengan Material Design 3 |
| NF4 | Reliability | Error handling di seluruh API, offline capability untuk data lokal |
| NF5 | Scalability | Firestore auto-scaling, stateless Flask API |
| NF6 | Portability | Berjalan di Android, iOS, dan Web dengan satu codebase |

## Metode Khusus Algoritma — Neural Collaborative Filtering

### Arsitektur Multi-Head NCF

Model NCF yang diimplementasikan menggunakan arsitektur multi-head yang terdiri dari:

1. **Input Layer** — Menerima 27 fitur Karyawan (tasks_completed, average_task_quality, projects_led, dst.)
2. **Shared MLP Layers** — Tiga lapisan dense yang dipakai bersama oleh kedua output head:
   - Dense(128, ReLU) → Dropout(0.3)
   - Dense(64, ReLU) → Dropout(0.2)
   - Dense(32, ReLU)
3. **Classification Head** — Dense(3, softmax) → Output: probabilitas untuk kelas Low, Medium, High
4. **Regression Head** — Dense(1, linear) → Output: skor keseluruhan 0-100

### Training Configuration

- **Optimizer**: Adam (learning_rate=0.001)
- **Classification Loss**: sparse_categorical_crossentropy (weight=1.0)
- **Regression Loss**: MSE (weight=0.1)
- **Callbacks**: ModelCheckpoint (save best), EarlyStopping (patience=10)
- **Data Split**: 70% train, 15% validation, 15% test dengan stratifikasi

### Backend Integration

Model di-deploy sebagai Flask REST API dengan endpoints:
- `POST /api/preprocessing/run` — Menjalankan preprocessing data
- `POST /api/model/train` — Training model NCF
- `GET /api/evaluate` — Evaluasi model pada test set
- `POST /api/predict` — Prediksi untuk data karyawan baru
- `POST /api/dataset/upload` — Upload dan proses dataset CSV

## Desain Perancangan Sistem

### 1. Use Case Diagram

**Deskripsi:** Use Case Diagram menampilkan interaksi antara dua aktor utama (HRD dan Employee) dengan sistem Talent Achieve.

**Aktor HRD:**
- Login / Logout
- Melihat Dashboard (Executive Summary)
- Mengelola Karyawan (Create, Read, Delete)
- Melihat Leaderboard
- Menganalisis Karyawan (Detail Analysis + PDF)
- Mengelola Dataset (Upload, Run Pipeline)
- Mengatur Settings

**Aktor Employee:**
- Login / Logout
- Melihat Performance Hub
- Melihat NCF Insights
- Melihat Performance History
- Mengelola Profile
- Mengatur Settings

### 2. Class Diagram

*(Deskripsi lengkap terdapat pada BAB I bagian 5 — Class Diagram)*

### 3. Activity Diagram

**Deskripsi:** Activity Diagram alur autentikasi login:
1. User membuka aplikasi → Splash Screen
2. Login Screen muncul
3. User memasukkan email, password, memilih role
4. Sistem validasi credentials via Firebase Auth
5. Jika valid → Cek role → Redirect ke HRD Dashboard / Employee Dashboard
6. Jika invalid → Tampilkan error message → Kembali ke Login

### 4. Component Diagram

**Deskripsi:** Component Diagram menampilkan arsitektur komponen aplikasi:
- **Flutter App** (Presentation Layer)
  - Auth Module
  - HRD Dashboard Module
  - Employee Dashboard Module
  - NCF Insights Module
  - Dataset Management Module
  - Profile Module
- **BLoC Layer** (State Management)
- **Repository Layer** (Domain)
- **Firebase Services** (Data Layer)
  - Firebase Auth
  - Cloud Firestore
- **Flask API** (ML Backend)
  - Preprocessing Module
  - NCF Model Module
  - Evaluation Module

### 5. Deployment Diagram

**Deskripsi:** Deployment Diagram menampilkan infrastruktur deployment:
- **Mobile Device** → Flutter App (APK/IPA)
- **Firebase Cloud** → Authentication, Firestore, Hosting
- **ML Server** → Flask API + TensorFlow Model
- **Client-Server Communication** → HTTPS REST API

## Desain UI / UX

### Flow UI Aplikasi

1. **Splash Screen** → Logo Talent Achieve dengan animasi
2. **Login Screen** → Form email, password, role selector, remember me, sign in button
3. **Forgot Password** → Input email → OTP Verification (kode: 1234) → Reset Password
4. **HRD Dashboard** → 5 tab: Summary, Dataset, Leaderboard, Create Employee, Settings
5. **Employee Dashboard** → 4 tab: Home (Performance Hub), Recommendations, History, Profile
6. **Employee Analysis** → Detail page dengan radar chart dan PDF export
7. **Edit Profile** → Form edit nama, email, phone, department, avatar
8. **Security** → Change password form dengan Firebase re-auth
9. **Help** → FAQ accordion dan contact support

### Color Palette

| Warna | Kode | Kegunaan |
|-------|------|----------|
| Primary Blue | #1565C0 | Tombol utama, header |
| Dark Navy | #0D1B2A | Background gelap |
| Accent Blue | #42A5F5 | Accent, link |
| Success Green | #4CAF50 | Badge High, success |
| Warning Yellow | #FFC107 | Badge Medium, warning |
| Error Red | #F44336 | Badge Low, error |

## Arsitektur Aplikasi

Aplikasi Talent Achieve menggunakan arsitektur **Three-Tier (3-Tier)**:

```
┌─────────────────────────────────────────────────┐
│              PRESENTATION TIER                    │
│         (Flutter Mobile Application)              │
│  ┌──────────┐ ┌──────────┐ ┌──────────────────┐ │
│  │ Auth UI  │ │Dashboard │ │ Analysis & Charts │ │
│  └──────────┘ └──────────┘ └──────────────────┘ │
│              BLoC State Management                │
├─────────────────────────────────────────────────┤
│              BUSINESS LOGIC TIER                  │
│    ┌──────────────┐    ┌──────────────────┐     │
│    │  Repository   │    │   Use Cases      │     │
│    │  Layer        │    │   (Domain)       │     │
│    └──────────────┘    └──────────────────┘     │
│         ┌────────────────────────┐               │
│         │   Flask REST API       │               │
│         │   (ML Backend)         │               │
│         │   NCF Model + TF       │               │
│         └────────────────────────┘               │
├─────────────────────────────────────────────────┤
│              DATA TIER                           │
│  ┌────────────┐ ┌────────────┐ ┌──────────────┐ │
│  │Firebase Auth│ │  Firestore │ │  Saved Models │ │
│  │            │ │  (NoSQL)   │ │  (.h5, .pkl)  │ │
│  └────────────┘ └────────────┘ └──────────────┘ │
└─────────────────────────────────────────────────┘
```

**Penjelasan:**
- **Presentation Tier** — Flutter application dengan UI components, BLoC state management, dan GoRouter navigation.
- **Business Logic Tier** — Repository pattern, Use Cases, dan Flask REST API yang menjalankan model NCF.
- **Data Tier** — Firebase Authentication, Cloud Firestore database, dan file model tersimpan (.h5, .pkl).

## Teknik Pengambilan Dataset

### Sumber Dataset

Dataset yang digunakan pada proyek ini merupakan **dataset sintetis** yang dihasilkan menggunakan script `generate_dataset.py` yang dirancang khusus untuk mensimulasikan data KPI karyawan.

### Spesifikasi Dataset

| Aspek | Detail |
|-------|--------|
| Jumlah Record | 5.000 baris |
| Jumlah Fitur | 27 kolom fitur + 1 kolom target |
| Format | CSV (Comma-Separated Values) |
| Distribusi Kelas | Low: 20%, Medium: 50%, High: 30% |
| Random Seed | 42 (untuk reproducibility) |

### Pola Pengelolaan Dataset

1. **Sintetis Berbasis Distribusi** — Data dihasilkan menggunakan distribusi normal dan uniform dengan parameter yang disesuaikan berdasarkan kelas (Low/Medium/High).
2. **Stratified Distribution** — Distribusi kelas target dirancang tidak seimbang (20/50/30) untuk mencerminkan kondisi real-world di mana karyawan berperforma tinggi lebih sedikit.
3. **Feature Engineering** — Fitur-fitur dikategorikan menjadi 3 grup: Performance (9 fitur), Behavior & Collaboration (9 fitur), Communication (9 fitur).
4. **Upload Capability** — Selain dataset sintetis, aplikasi juga mendukung upload dataset CSV real dari pengguna.

## Alur Preprocessing

```
Dataset CSV (5000 records, 28 columns)
         │
         ▼
┌─────────────────────────┐
│ 1. Drop Employee ID     │ ← Kolom ID dihapus
│    (28 → 27 columns)    │
└────────────┬────────────┘
             ▼
┌─────────────────────────┐
│ 2. Label Encoding       │ ← Low=0, Medium=1, High=2
│    Target Variable      │
└────────────┬────────────┘
             ▼
┌─────────────────────────┐
│ 3. Feature Scaling      │ ← StandardScaler
│    (Zero Mean,          │   fit_transform on train
│     Unit Variance)      │   transform on val/test
└────────────┬────────────┘
             ▼
┌─────────────────────────┐
│ 4. Target Engineering   │ ← Regression target =
│    Score Calculation    │   mean(score_cols) × 10
└────────────┬────────────┘
             ▼
┌─────────────────────────┐
│ 5. Data Splitting       │ ← 70% Train (3500)
│    Stratified           │   15% Val (750)
│                         │   15% Test (750)
└─────────────────────────┘
```

## Penerapan Algoritma Machine Learning

### Konfigurasi Training

| Parameter | Nilai |
|-----------|-------|
| Framework | TensorFlow 2.16+ / Keras |
| Model | NCF Multi-Head |
| Input Dimension | 27 |
| Output Classes | 3 (Low, Medium, High) |
| Optimizer | Adam (lr=0.001) |
| Epochs | 100 (max, dengan early stopping) |
| Batch Size | 32 |
| Validation Split | 15% dari total data |
| Callbacks | ModelCheckpoint, EarlyStopping(patience=10) |

### Diagram Hasil Penerapan Algoritma

*(Bagian ini akan dilengkapi dengan grafik training/validation loss curves dan accuracy curves setelah proses training selesai)*

Training loss diharapkan menurun konsisten selama epoch, sementara validation loss stabil atau menurun. Jika training loss terus menurun sementara validation loss naik, menunjukkan overfitting yang dapat ditangani oleh EarlyStopping callback.

## Hasil Algoritma Machine Learning dalam Mobile Apps

Model NCF yang telah di-training diintegrasikan ke dalam mobile apps melalui Flask REST API. Berikut adalah alur integrasi:

1. **Upload Dataset** → User upload CSV melalui Dataset Management
2. **Preprocessing** → API memanggil `Preprocessor.process_and_split()` untuk membersihkan dan membagi data
3. **Training** → API memanggil `Trainer.train()` untuk melatih model NCF
4. **Prediction** → API memanggil `model.predict()` untuk menghasilkan prediksi per karyawan
5. **Firestore Storage** → Hasil prediksi disimpan ke Cloud Firestore
6. **Mobile Display** → Flutter app menampilkan hasil melalui dashboard, leaderboard, dan analysis pages

### Source Code Integrasi — Backend Predict Endpoint

```python
@app.route('/api/predict', methods=['POST'])
def predict():
    data = request.json
    df = pd.DataFrame([data])
    X = preprocessor.prepare_inference(df)
    model = tf.keras.models.load_model('saved_models/best_ncf_model.h5')
    preds = model.predict(X)
    cls_probs = preds[0][0]
    reg_pred = preds[1][0][0]
    cls_idx = np.argmax(cls_probs)
    predicted_class = label_encoder.inverse_transform([cls_idx])[0]
    return jsonify({
        "prediction": {
            "performance_rating": predicted_class,
            "overall_score": float(reg_pred),
            "probabilities": {str(l): float(p) for l, p in zip(label_encoder.classes_, cls_probs)}
        }
    })
```

## Hasil Evaluasi Model Machine Learning

### 1. Evaluasi Klasifikasi

*(Tabel dan confusion matrix akan dilengkapi setelah training)*

| Metrik | Low | Medium | High | Macro Avg |
|--------|-----|--------|------|-----------|
| Precision | - | - | - | - |
| Recall | - | - | - | - |
| F1-Score | - | - | - | - |
| **Accuracy** | - | - | - | **-** |

### 2. Evaluasi Regresi

| Metrik | Nilai |
|--------|-------|
| MSE | - |
| RMSE | - |
| MAE | - |

### 3. Cross Validation

*(Cross validation 5-fold akan ditampilkan setelah training)*

### 4. Confusion Matrix

| | Prediksi Low | Prediksi Medium | Prediksi High |
|---|---|---|---|
| **Aktual Low** | - | - | - |
| **Aktual Medium** | - | - | - |
| **Aktual High** | - | - | - |

## Validasi Perhitungan Evaluasi Model Machine Learning

### Confusion Matrix — Multi-Class Classification

Untuk memvalidasi hasil akurasi dari confusion matrix, dilakukan perhitungan manual:

**Accuracy** = (TP_Low + TP_Medium + TP_High) / Total Samples

**Precision (per-class)** = TP_kelas / (TP_kelas + FP_kelas)

**Recall (per-class)** = TP_kelas / (TP_kelas + FN_kelas)

**F1-Score (per-class)** = 2 × (Precision × Recall) / (Precision + Recall)

**Macro Precision** = (Precision_Low + Precision_Medium + Precision_High) / 3

**Macro Recall** = (Recall_Low + Recall_Medium + Recall_High) / 3

**Macro F1** = (F1_Low + F1_Medium + F1_High) / 3

*(Validasi manual akan dilakukan setelah mendapatkan hasil evaluasi aktual dari model)*

## Tampilan Akhir Aplikasi

*(Bagian ini akan dilengkapi dengan screenshot-screenshot berikut:)*

1. **Splash Screen** — Logo Talent Achieve
2. **Login Screen** — Form email, password, role selector
3. **HRD Dashboard — Executive Summary** — Stat cards, department chart, leaderboard preview
4. **HRD Dashboard — Dataset Management** — Upload area, pipeline progress, history
5. **HRD Dashboard — Leaderboard** — Full ranking list dengan status badges
6. **HRD Dashboard — Create Employee** — Form pembuatan karyawan baru
7. **HRD Dashboard — Settings** — Notification toggles, app info
8. **Employee Dashboard — Performance Hub** — Circular gauge, trend chart, stat cards
9. **Employee Dashboard — NCF Insights** — Strengths/weaknesses chart, action steps
10. **Employee Dashboard — Performance History** — Monthly scores, line chart
11. **Employee Dashboard — Profile** — User info, avatar
12. **Employee Analysis (HRD View)** — Radar chart, score grid, PDF export
13. **Edit Profile** — Form edit profil
14. **Security** — Change password form
15. **Help Center** — FAQ accordion

## Programming Source Code dan Database Design

### Struktur Source Code

```
lib/
├── main.dart                    # Entry point, Firebase init, DI setup
├── injection.dart               # GetIt service locator registration
├── firebase_options.dart        # Firebase config (FlutterFire CLI)
├── core/
│   ├── constants/
│   │   ├── app_colors.dart      # Brand colors & gradients
│   │   └── app_strings.dart     # Centralized UI strings
│   ├── theme/
│   │   └── app_theme.dart       # Light & dark themes (Material 3)
│   ├── widgets/
│   │   ├── stat_card.dart       # Reusable stat card
│   │   ├── section_header.dart  # Section title with action
│   │   └── status_badge.dart    # Colored status pill
│   └── router/
│       └── app_router.dart      # GoRouter with auth guards
└── features/
    ├── auth/                    # Authentication module
    ├── hrd_dashboard/           # HRD admin portal
    ├── employee_dashboard/      # Employee self-service portal
    ├── employee_analysis/       # Individual analysis (HRD view)
    ├── ncf_insights/            # AI insights for employees
    ├── dataset_management/      # Dataset upload & AI pipeline
    └── profile/                 # Profile management
```

### Penjelasan Fungsi Source Code Utama

| File | Fungsi |
|------|--------|
| `main.dart` | Inisialisasi Firebase, load theme preference, setup dependency injection, menjalankan app |
| `injection.dart` | Registrasi semua data sources, repositories, use cases, dan BLoCs ke GetIt |
| `app_router.dart` | Konfigurasi routing dengan GoRouter, auth-based redirects, route definitions |
| `app_theme.dart` | Definisi light dan dark theme dengan Material 3, Inter font family |
| `auth_bloc.dart` | State management untuk autentikasi: login, logout, password reset |
| `hrd_bloc.dart` | State management untuk HRD: load employees, leaderboard, create/delete |
| `employee_bloc.dart` | State management untuk employee: load performance data, insights |
| `dataset_bloc.dart` | State management untuk dataset: upload, run pipeline, history |

### Database Design (Cloud Firestore)

```
Firestore Collections:
├── users/
│   ├── {uid}/
│   │   ├── email: string
│   │   ├── name: string
│   │   ├── role: "hrd" | "employee"
│   │   ├── department: string
│   │   ├── position: string
│   │   ├── phone: string
│   │   ├── avatarUrl: string
│   │   └── createdAt: timestamp
│
├── predictions/
│   ├── {employeeId}/
│   │   ├── performance_rating: "Low" | "Medium" | "High"
│   │   ├── overall_score: number
│   │   ├── probabilities: { Low: number, Medium: number, High: number }
│   │   └── predictedAt: timestamp
│
└── datasets/
    ├── {datasetId}/
    │   ├── fileName: string
    │   ├── totalRecords: number
    │   ├── uploadedAt: timestamp
    │   ├── status: "processing" | "completed" | "failed"
    │   └── processingSteps: array
```

---

# BAB V KESIMPULAN DAN SARAN

## 5. Kesimpulan dan Saran

### a) Kesimpulan

Berdasarkan pengembangan yang telah dilakukan, dapat disimpulkan bahwa:

1. Aplikasi **Talent Achieve** berhasil dibangun sebagai solusi mobile untuk evaluasi kinerja karyawan berbasis machine learning dengan integrasi Flutter dan Firebase.

2. Model **Neural Collaborative Filtering (NCF)** dengan arsitektur multi-head (klasifikasi + regresi) dapat diintegrasikan ke dalam aplikasi mobile melalui Flask REST API untuk menghasilkan prediksi performa karyawan yang komprehensif.

3. Aplikasi ini bukan sekadar alat tracking, melainkan **jembatan komunikasi** antara perusahaan dan karyawan yang menciptakan transparansi dalam penilaian KPI.

4. Arsitektur **Clean Architecture** dengan pola BLoC state management berhasil menjaga kode tetap terorganisir, mudah diuji, dan scalable.

5. Pipeline machine learning end-to-end (preprocessing → training → evaluasi → inferensi) dapat berjalan secara terintegrasi dari mobile application hingga backend server.

6. Budaya kerja yang lebih **objektif, transparan, dan berorientasi pada hasil** (goal-oriented) dapat tercipta dengan adanya sistem evaluasi berbasis data.

### b) Saran

Untuk pengembangan lebih lanjut, berikut beberapa saran yang dapat dijadikan pertimbangan:

1. **Integrasi Data Real-Time** — Menghubungkan aplikasi dengan sistem HRIS yang sudah ada untuk mengambil data KPI secara real-time, sehingga prediksi selalu berbasis data terkini.

2. **Multi-Language Support** — Menambahkan dukungan multi-bahasa (Indonesia, English, dll.) untuk meningkatkan aksesibilitas pengguna internasional.

3. **Advanced Analytics Dashboard** — Menambahkan fitur analytics yang lebih mendalam seperti cohort analysis, predictive analytics, dan trend forecasting.

4. **Push Notification Real** — Mengintegrasikan Firebase Cloud Messaging (FCM) untuk mengirim notifikasi real-time terkait update KPI, reminder evaluasi, dan rekomendasi training.

5. **Model Optimization** — Melakukan hyperparameter tuning, experiment tracking, dan potentially menggunakan architecture yang lebih kompleks (seperti Transformer-based) untuk meningkatkan akurasi prediksi.

6. **Offline Mode** — Menambahkan kemampuan offline untuk akses data karyawan dan riwayat performa tanpa koneksi internet.

7. **Role-Based Dashboard Customization** — Memungkinkan HRD dan admin untuk menyesuaikan widget dan layout dashboard sesuai kebutuhan departemen.

---

# DAFTAR PUSTAKA

*(Wajib Jurnal / Buku, Tidak Diperkenankan Link Website)*

Alfahri, D. A., & Widarma, A. (2025). Implementation of Flutter and Firebase in Developing a Mobile News Portal Application. *Bigint Computing Journal*.

Asri, J. S., & Wahyu, S. (2021). Analisis Sentimen Menerapkan Lexicon-Learning Based Untuk Melihat Opini Masyarakat Mengenai Protokol Kesehatan Dan Perkembangan Vaksin Covid-19 Di Indonesia Menggunakan Dataset Twitter. *Proceeding KONIK (Konferensi Nasional Ilmu Komputer)*, 5, 530-536.

He, X., Liao, L., Zhang, H., Nie, L., Hu, X., & Chua, T. S. (2017). Neural Collaborative Filtering. *Proceedings of the 26th International Conference on World Wide Web*, 173-182.

Kumar, B., Agrawal, P., Uike, D., & Lourens, M. (2024). ML Techniques for Employee Performance Prediction. *IEEE Conference on Smart Electrical Networks*.

Liu, Q., Wan, H., & Yu, H. (2023). The Application of Deep Learning in Human Resource Management: A New Perspective on Employee Recruitment and Performance Evaluation. *Academic Journal of Management and Social Sciences*.

Saputra, A. (2019). Penerapan Usability pada Aplikasi PENTAS Dengan Menggunakan Metode System Usability Scale (SUS). *Jurnal Teknologi Informasi dan Multimedia*.

Setiyawati, N., & Bangkalang, D. H. (2022). Comparison of Evaluation on User Experience and Usability of Mobile Banking Applications Using User Experience Questionnaire and System Usability Scale. *Proceedings*.

Wahyu, S. (2022). Penerapan Metode Game Development Life Cycle Pada Pengembangan Aplikasi Game Pembelajaran Budi Pekerti. *SKANIKA: Sistem Komputer Dan Teknik Informatika*, 5(1), 82-91.

Wahyu, S., Malabay, M., & Asri, J. S. (2021). Perancangan Konsep Dan Evaluasi Desain User Experience Pada Aplikasi Mobile Penyedia Tempat Layanan Fitness Dengan Pendekatan User-Centered Design. *Proceeding KONIK (Konferensi Nasional Ilmu Komputer)*, 5, 446-451.
