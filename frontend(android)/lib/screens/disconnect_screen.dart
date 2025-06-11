import 'package:flutter/material.dart';
import 'billing_screen.dart';
import 'package:android_medium/widgets/app_drawer.dart';

class DisconnectScreen extends StatefulWidget {
  @override
  State<DisconnectScreen> createState() => _DisconnectScreenState();
}

class _DisconnectScreenState extends State<DisconnectScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;

  Map<String, String> selectedServer = {
    "country": "Netherlands",
    "city": "Amsterdam",
    "ip": "185.107.57.5",
    "flag": "https://flagcdn.com/w40/nl.png"
  };

  final List<Map<String, String>> servers = [
    {
      "country": "Netherlands",
      "city": "Amsterdam",
      "ip": "185.107.57.5",
      "flag": "https://flagcdn.com/w40/nl.png"
    },
    {
      "country": "Germany",
      "city": "Frankfurt",
      "ip": "185.90.61.5",
      "flag": "https://flagcdn.com/w40/de.png"
    },
    {
      "country": "USA",
      "city": "New York",
      "ip": "142.251.32.174",
      "flag": "https://flagcdn.com/w40/us.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showServerList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ListView.builder(
        itemCount: servers.length,
        itemBuilder: (context, index) {
          final server = servers[index];
          return ListTile(
            leading: Image.network(server["flag"]!, width: 32),
            title: Text("${server['country']} - ${server['city']}"),
            subtitle: Text(server['ip']!),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                selectedServer = server;
              });
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔝 Top Bar
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
                      'VPN Status',
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

                SizedBox(height: 20),
                Text("Connecting Time", style: TextStyle(fontSize: 14)),
                SizedBox(height: 4),
                Text("02 : 41 : 52", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),

                // Server Card
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.network(selectedServer["flag"]!, height: 32, width: 42),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(selectedServer["country"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(selectedServer["city"]!, style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Stealth", style: TextStyle(fontSize: 12)),
                          Text("14%", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Upload Download
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(Icons.download, "Download", "527 MB"),
                    _buildStatCard(Icons.upload, "Upload", "49 MB"),
                  ],
                ),

                SizedBox(height: 20),

                // Rotating Globe
                Stack(
                  alignment: Alignment.center,
                  children: [
                    RotationTransition(
                      turns: _controller,
                      child: Image.asset(
                        "lib/assets/globe.png",
                        width: size.width * 0.5,
                        height: size.width * 0.5,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: Container(
                          key: ValueKey(selectedServer["ip"]),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(blurRadius: 3, color: Colors.black26)],
                          ),
                          child: Text(
                            "${selectedServer['city']}\n${selectedServer['ip']}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Change Server Button
                GestureDetector(
                  onTap: () => _showServerList(context),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.language, color: Colors.black54),
                            SizedBox(width: 10),
                            Text("Change Server", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                Text("Disconnected", style: TextStyle(color: Colors.red, fontSize: 16)),
              ],
            ),
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

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.green),
          SizedBox(height: 6),
          Text(label, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
