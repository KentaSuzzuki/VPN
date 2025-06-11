import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'premium_screen.dart';
import 'package:android_medium/widgets/app_drawer.dart'; // <-- Import your drawer

class CountriesScreen extends StatefulWidget {
  @override
  _CountriesScreenState createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final freeLocations = [
    {'name': 'Italy', 'locations': 4},
    {'name': 'Netherlands', 'locations': 12},
    {'name': 'Germany', 'locations': 10},
  ];

  final premiumLocations = [
    {'name': 'United States', 'locations': 35},
    {'name': 'Brazil', 'locations': 16},
    {'name': 'France', 'locations': 27},
    {'name': 'Canada', 'locations': 21},
  ];

  Map<String, bool> dropdownExpanded = {};
  Map<String, bool> powerToggled = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(), // <-- Attach your external drawer
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF1B1A55),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Builder(
              builder: (context) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'lib/assets/app-drawer.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "Countries",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SettingsScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'lib/assets/crown.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for Country or City",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main content
          Expanded(
            child: ListView(
              children: [
                _buildSection("Free Locations", freeLocations, false),
                _buildSection("Premium Locations", premiumLocations, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> data, bool isPremium) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        ...data.map((location) => _buildLocationTile(
          name: location['name'],
          count: location['locations'],
          isPremium: isPremium,
        )),
      ],
    );
  }

  Widget _buildLocationTile({
    required String name,
    required int count,
    required bool isPremium,
  }) {
    dropdownExpanded.putIfAbsent(name, () => false);
    powerToggled.putIfAbsent(name, () => false);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                'lib/assets/flag.png',
                width: 36,
                height: 24,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('$count Locations',
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),

              // Power or Crown Button
              GestureDetector(
                onTap: () {
                  if (isPremium) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PremiumScreen()),
                    );
                  } else {
                    setState(() {
                      powerToggled[name] = !powerToggled[name]!;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: powerToggled[name]! ? Colors.blue : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: isPremium
                      ? Image.asset('lib/assets/crown.png', width: 18, height: 18)
                      : Icon(CupertinoIcons.power,
                      color: powerToggled[name]! ? Colors.white : Colors.blue,
                      size: 18),
                ),
              ),

              const SizedBox(width: 6),

              // Dropdown Arrow
              GestureDetector(
                onTap: () {
                  setState(() {
                    dropdownExpanded[name] = !dropdownExpanded[name]!;
                  });
                },
                child: Transform.rotate(
                  angle: dropdownExpanded[name]! ? 1.57 : 0,
                  child: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),

        // Dropdown content
        if (dropdownExpanded[name]!)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(8),
            child: const Text(
              "Details about this location...\n(e.g., city list, server speed, ping etc.)",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
