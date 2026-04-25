name: xAI Wallet KYC Ultra Fixed

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: 0. Checkout repo
        uses: actions/checkout@v4

      - name: Setup Java 17
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Setup Flutter 3.24
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'

      - name: 1. Create Flutter project
        run: flutter create --org com.migoxai --project-name xai_wallet --platforms android --overwrite .

      - name: 1.1. Set App Name & Permissions
        run: |
          sed -i 's/android:label="xai_wallet"/android:label="xAI Wallet KYC Ultra"/g' android/app/src/main/AndroidManifest.xml
          sed -i '/<\/manifest>/i \    <uses-permission android:name="android.permission.CAMERA"\/>\n    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"\/>' android/app/src/main/AndroidManifest.xml
          sed -i 's/com.migoxai.xai_wallet/com.migoxai.wallet/g' android/app/build.gradle
          mkdir -p android/app/src/main/kotlin/com/migoxai/wallet
          mv android/app/src/main/kotlin/com/migoxai/xai_wallet/MainActivity.kt android/app/src/main/kotlin/com/migoxai/wallet/ 2>/dev/null || true
          rm -rf android/app/src/main/kotlin/com/migoxai/xai_wallet

      - name: 2. Update pubspec.yaml
        run: |
          cat > pubspec.yaml << 'EOF'
          name: xai_wallet
          description: xAI Wallet with Face KYC Ultra
          publish_to: 'none'
          version: 1.0.0+1

          environment:
            sdk: '>=3.5.0 <4.0.0'

          dependencies:
            flutter:
              sdk: flutter
            cupertino_icons: ^1.0.8
            camera: ^0.10.5
            permission_handler: ^11.3.1
            shared_preferences: ^2.2.3
            uuid: ^4.4.0

          dev_dependencies:
            flutter_test:
              sdk: flutter
            flutter_lints: ^3.0.0

          flutter:
            uses-material-design: true
          EOF

      - name: 3. Get dependencies
        run: flutter pub get

      - name: 4. Write All Dart Files
        run: |
          cat > lib/main.dart << 'EOF'
          import 'package:flutter/material.dart';
          import 'splash_screen.dart';
          void main() { runApp(const XaiWalletApp()); }
          class XaiWalletApp extends StatelessWidget {
            const XaiWalletApp({super.key});
            @override
            Widget build(BuildContext context) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF080808)),
                home: const SplashScreen(),
              );
            }
          }
          EOF

          cat > lib/splash_screen.dart << 'EOF'
          import 'package:flutter/material.dart';
          import 'kyc_screen.dart';
          class SplashScreen extends StatefulWidget {
            const SplashScreen({super.key});
            @override
            State<SplashScreen> createState() => _SplashScreenState();
          }
          class _SplashScreenState extends State<SplashScreen> {
            @override
            void initState() {
              super.initState();
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KycScreen()));
              });
            }
            @override
            Widget build(BuildContext context) {
              return const Scaffold(
                backgroundColor: Color(0xFF080808),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.face_retouching_natural, size: 80, color: Color(0xFF00FF88)),
                      SizedBox(height: 20),
                      Text('xAI Wallet', style: TextStyle(fontSize: 32, color: Colors.white, letterSpacing: 4)),
                      SizedBox(height: 8),
                      Text('KYC Ultra', style: TextStyle(fontSize: 16, color: Color(0xFF00FF88), letterSpacing: 6)),
                    ],
                  ),
                ),
              );
            }
          }
          EOF

          cat > lib/kyc_screen.dart << 'EOF'
          import 'package:flutter/material.dart';
          import 'package:camera/camera.dart';
          import 'package:permission_handler/permission_handler.dart';
          import 'home_page.dart';
          import 'package:shared_preferences/shared_preferences.dart';

          class KycScreen extends StatefulWidget {
            const KycScreen({super.key});
            @override
            State<KycScreen> createState() => _KycScreenState();
          }

          class _KycScreenState extends State<KycScreen> {
            CameraController? _controller;
            bool _isVerifying = false;
            bool _kycDone = false;

            @override
            void initState() {
              super.initState();
              _checkKycStatus();
            }

            Future<void> _checkKycStatus() async {
              final prefs = await SharedPreferences.getInstance();
              bool done = prefs.getBool('kyc_verified') ?? false;
              if (done) {
                _goToWallet();
              } else {
                _initCamera();
              }
            }

            Future<void> _initCamera() async {
              await Permission.camera.request();
              final cameras = await availableCameras();
              final front = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
              _controller = CameraController(front, ResolutionPreset.medium);
              await _controller!.initialize();
              if (mounted) setState(() {});
            }

            Future<void> _verifyFace() async {
              setState(() => _isVerifying = true);
              await Future.delayed(const Duration(seconds: 2)); // Fake verify
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('kyc_verified', true);
              setState(() => _isVerifying = false);
              _goToWallet();
            }

            void _goToWallet() {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
            }

            @override
            void dispose() {
              _controller?.dispose();
              super.dispose();
            }

            @override
            Widget build(BuildContext context) {
              return Scaffold(
                backgroundColor: const Color(0xFF080808),
                appBar: AppBar(title: const Text('Face KYC Verify'), backgroundColor: const Color(0xFF0A0A0A)),
                body: Column(
                  children: [
                    Expanded(
                      child: _controller?.value.isInitialized == true
                          ? CameraPreview(_controller!)
                          : const Center(child: CircularProgressIndicator(color: Color(0xFF00FF88))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: _isVerifying ? null : _verifyFace,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00FF88),
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(_isVerifying ? 'Verifying...' : 'Start Face KYC'),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          EOF

          cat > lib/home_page.dart << 'EOF'
          import 'package:flutter/material.dart';
          import 'package:uuid/uuid.dart';
          import 'package:shared_preferences/shared_preferences.dart';

          class HomePage extends StatefulWidget {
            const HomePage({super.key});
            @override
            State<HomePage> createState() => _HomePageState();
          }

          class _HomePageState extends State<HomePage> {
            String walletId = 'Loading...';
            
            @override
            void initState() {
              super.initState();
              _loadWalletId();
            }

            Future<void> _loadWalletId() async {
              final prefs = await SharedPreferences.getInstance();
              String? id = prefs.getString('wallet_id');
              if (id == null) {
                id = 'WID${const Uuid().v4().replaceAll('-', '').substring(0, 16).toUpperCase()}';
                await prefs.setString('wallet_id', id);
              }
              setState(() => walletId = id!);
            }

            @override
            Widget build(BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('xAI Wallet'),
                  backgroundColor: const Color(0xFF0A0A0A),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified_user, size: 60, color: Color(0xFF00FF88)),
                      const SizedBox(height: 10),
                      const Text('KYC Verified', style: TextStyle(color: Color(0xFF00FF88))),
                      const SizedBox(height: 40),
                      Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF00FF88), width: 2),
                        ),
                        child: const Icon(Icons.account_balance_wallet, size: 60, color: Color(0xFF00FF88)),
                      ),
                      const SizedBox(height: 40),
                      const Text('Wallet ID', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 8),
                      SelectableText(
                        walletId,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF00FF88), letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 60),
                      const Text('Versale', style: TextStyle(fontSize: 16, color: Color(0xFF00FF88), letterSpacing: 6)),
                    ],
                  ),
                ),
              );
            }
          }
          EOF

      - name: 5. Build APK
        run: flutter build apk --release

      - name: 6. Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: xAI-WALLET-KYC-ULTRA-FIXED-APK
          path: build/app/outputs/flutter-apk/app-release.apk
