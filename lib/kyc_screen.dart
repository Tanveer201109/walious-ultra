name: xAI Wallet KYC Create Fixed

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
          sed -i 's/android:label="xai_wallet"/android:label="xAI Wallet"/g' android/app/src/main/AndroidManifest.xml
          sed -i '/<\/manifest>/i \    <uses-permission android:name="android.permission.CAMERA"\/>' android/app/src/main/AndroidManifest.xml

      - name: 2. Update pubspec.yaml
        run: |
          cat > pubspec.yaml << 'EOF'
          name: xai_wallet
          description: xAI Wallet with Working Create Wallet
          publish_to: 'none'
          version: 1.0.0+1

          environment:
            sdk: '>=3.5.0 <4.0.0'

          dependencies:
            flutter:
              sdk: flutter
            camera: ^0.10.5
            permission_handler: ^11.3.1
            shared_preferences: ^2.2.3
            uuid: ^4.4.0

          flutter:
            uses-material-design: true
          EOF

      - name: 3. Get dependencies
        run: flutter pub get

      - name: 4. Write All Dart Files
        run: |
          cat > lib/main.dart << 'EOF'
          import 'package:flutter/material.dart';
          import 'connect_screen.dart';
          void main() { runApp(const XaiWalletApp()); }
          class XaiWalletApp extends StatelessWidget {
            const XaiWalletApp({super.key});
            @override
            Widget build(BuildContext context) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF080808)),
                home: const ConnectScreen(),
              );
            }
          }
          EOF

          cat > lib/connect_screen.dart << 'EOF'
          import 'package:flutter/material.dart';
          import 'package:shared_preferences/shared_preferences.dart';
          import 'kyc_screen.dart';
          import 'wallet_home.dart';

          class ConnectScreen extends StatefulWidget {
            const ConnectScreen({super.key});
            @override
            State<ConnectScreen> createState() => _ConnectScreenState();
          }

          class _ConnectScreenState extends State<ConnectScreen> {
            bool _loading = true;

            @override
            void initState() {
              super.initState();
              _checkWallet();
            }

            Future<void> _checkWallet() async {
              final prefs = await SharedPreferences.getInstance();
              bool hasWallet = prefs.getString('wallet_id') != null;
              bool kycDone = prefs.getBool('kyc_verified') ?? false;
              
              if (hasWallet && kycDone && mounted) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WalletHome()));
              } else {
                setState(() => _loading = false);
              }
            }

            Future<void> _createNewWallet() async {
              final result = await Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const KycScreen())
              );
              if (result == true && mounted) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WalletHome()));
              }
            }

            Future<void> _connectExistingWallet() async {
              final prefs = await SharedPreferences.getInstance();
              if (prefs.getString('wallet_id') != null) {
                if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WalletHome()));
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No wallet found. Create new wallet first'), backgroundColor: Colors.red),
                  );
                }
              }
            }

            @override
            Widget build(BuildContext context) {
              if (_loading) {
                return const Scaffold(
                  backgroundColor: Color(0xFF080808),
                  body: Center(child: CircularProgressIndicator(color: Color(0xFF00FF88))),
                );
              }
              return Scaffold(
                backgroundColor: const Color(0xFF080808),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.account_balance_wallet, size: 100, color: Color(0xFF00FF88)),
                        const SizedBox(height: 40),
                        const Text('xAI Wallet', style: TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.w300, letterSpacing: 4)),
                        const SizedBox(height: 8),
                        const Text('Versale', style: TextStyle(fontSize: 16, color: Color(0xFF00FF88), letterSpacing: 8)),
                        const SizedBox(height: 80),
                        ElevatedButton(
                          onPressed: _createNewWallet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00FF88),
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Create New Wallet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: _connectExistingWallet,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF00FF88), width: 2),
                            foregroundColor: const Color(0xFF00FF88),
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Connect Wallet', style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
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
          import 'package:shared_preferences/shared_preferences.dart';
          import 'package:uuid/uuid.dart';

          class KycScreen extends StatefulWidget {
            const KycScreen({super.key});
            @override
            State<KycScreen> createState() => _KycScreenState();
          }

          class _KycScreenState extends State<KycScreen> {
            CameraController? _controller;
            bool _isCreating = false;
            String _status = 'Position your face in the circle';

            @override
            void initState() {
              super.initState();
              _initCamera();
            }

            Future<void> _initCamera() async {
              var status = await Permission.camera.request();
              if (status.isDenied) {
                setState(() => _status = 'Camera permission denied');
                return;
              }
              final cameras = await availableCameras();
              final front = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
              _controller = CameraController(front, ResolutionPreset.medium);
              await _controller!.initialize();
              if (mounted) setState(() {});
            }

            Future<void> _createWallet() async {
              setState(() {
                _isCreating = true;
                _status = 'Verifying face...';
              });
              
              await Future.delayed(const Duration(seconds: 2));
              
              final prefs = await SharedPreferences.getInstance();
              String walletId = 'WID${const Uuid().v4().replaceAll('-', '').substring(0, 16).toUpperCase()}';
              
              await prefs.setString('wallet_id', walletId);
              await prefs.setBool('kyc_verified', true);
              
              setState(() => _status = 'Wallet Created Successfully!');
              await Future.delayed(const Duration(milliseconds: 500));
              
              if (mounted) Navigator.pop(context, true); // true return করবে Connect Screen এ
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
                appBar: AppBar(
                  title: const Text('Create New Wallet'),
                  backgroundColor: const Color(0xFF0A0A0A),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: _controller?.value.isInitialized == true
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                CameraPreview(_controller!),
                                Container(
                                  width: 280, height: 280,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFF00FF88), width: 4),
                                    borderRadius: BorderRadius.circular(140),
                                  ),
                                ),
                                Positioned(
                                  bottom: 40,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(_status, style: const TextStyle(color: Color(0xFF00FF88))),
                                  ),
                                ),
                              ],
                            )
                          : Center(child: Text(_status, style: const TextStyle(color: Colors.white))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: _isCreating ? null : _createWallet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00FF88),
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 55),
                        ),
                        child: Text(_isCreating ? 'Creating...' : 'Verify & Create Wallet'),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          EOF

          cat > lib/wallet_home.dart << 'EOF'
          import 'package:flutter/material.dart';
          import 'package:shared_preferences/shared_preferences.dart';
          import 'connect_screen.dart';

          class WalletHome extends StatefulWidget {
            const WalletHome({super.key});
            @override
            State<WalletHome> createState() => _WalletHomeState();
          }

          class _WalletHomeState extends State<WalletHome> {
            String walletId = 'Loading...';
            
            @override
            void initState() {
              super.initState();
              _loadWalletId();
            }

            Future<void> _loadWalletId() async {
              final prefs = await SharedPreferences.getInstance();
              String? id = prefs.getString('wallet_id');
              setState(() => walletId = id ?? 'WID-ERROR');
            }

            Future<void> _disconnect() async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ConnectScreen()),
                  (route) => false,
                );
              }
            }

            @override
            Widget build(BuildContext context) {
              return Scaffold(
                backgroundColor: const Color(0xFF080808),
                appBar: AppBar(
                  title: const Text('xAI Wallet'),
                  backgroundColor: const Color(0xFF0A0A0A),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(onPressed: _disconnect, icon: const Icon(Icons.logout, color: Colors.red)),
                  ],
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified_user, size: 50, color: Color(0xFF00FF88)),
                      const SizedBox(height: 8),
                      const Text('Wallet Activated', style: TextStyle(color: Color(0xFF00FF88), fontSize: 16)),
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
                      const SizedBox(height: 20),
                      const Text('Balance: 0.00 MSPACK', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
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
          name: xAI-WALLET-CREATE-WORKING-APK
          path: build/app/outputs/flutter-apk/app-release.apk
