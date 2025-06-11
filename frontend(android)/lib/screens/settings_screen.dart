import 'package:flutter/material.dart';
import 'billing_screen.dart';
import 'package:android_medium/widgets/app_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _VpnSettingsScreenState();
}

class _VpnSettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool vpnAccelerator = true;
  bool vpnNotifications = true;
  bool splitTunneling = false;
  bool netShield = true;
  bool killSwitch = true;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final isSmall = screenWidth < 360;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF6FAFF),
      drawer: AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: media.size.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔝 Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: _buildTopIcon('lib/assets/app-drawer.png'),
                  ),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: isSmall ? 18 : 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BillingScreen()),
                      );
                    },
                    child: _buildTopIcon('lib/assets/crown.png'),
                  ),
                ],
              ),
              SizedBox(height: media.size.height * 0.03),

              /// 🧠 Quick Connect Info
              buildCompactItem(
                title: 'Quick Connect',
                description: 'Fastest\nQuick Connect Button Connects You To Selected Server.',
                isSwitch: false,
              ),

              /// 📦 Toggles
              buildCompactItem(
                title: 'VPN Accelerator',
                description: 'Enables unique tech to increase speed up to 400%.',
                value: vpnAccelerator,
                onChanged: (val) => setState(() => vpnAccelerator = val),
              ),
              buildCompactItem(
                title: 'VPN Accelerator notifications',
                description: 'Notifies you when Accelerator switches to faster server.',
                value: vpnNotifications,
                onChanged: (val) => setState(() => vpnNotifications = val),
              ),
              buildCompactItem(
                title: 'Split Tunneling',
                description: 'Exclude apps or IPs from VPN traffic.',
                value: splitTunneling,
                onChanged: (val) => setState(() => splitTunneling = val),
              ),
              buildCompactItem(
                title: 'NetShield',
                description: 'Blocks ads, trackers and malware.',
                value: netShield,
                onChanged: (val) => setState(() => netShield = val),
              ),
              buildCompactItem(
                title: 'Kill Switch',
                description: 'VPN behavior when connection is disrupted.',
                value: killSwitch,
                onChanged: (val) => setState(() => killSwitch = val),
              ),

              /// 🚀 Go Premium
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BillingScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3b74ff),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.lock_open, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Go Premium',
                        style: TextStyle(
                          fontSize: isSmall ? 14 : 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopIcon(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF3b74ff),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(
        assetPath,
        height: 20,
        width: 20,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget buildCompactItem({
    required String title,
    required String description,
    bool isSwitch = true,
    bool value = false,
    ValueChanged<bool>? onChanged,
  }) {
    final media = MediaQuery.of(context);
    final isSmall = media.size.width < 360;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isSmall ? 13 : 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isSmall ? 11 : 12,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (isSwitch)
            Transform.scale(
              scale: 0.85,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF4B32F4),
                inactiveTrackColor: Colors.grey.shade300,
                inactiveThumbColor: Colors.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }
}
