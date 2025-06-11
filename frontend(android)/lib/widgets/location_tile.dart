import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LocationTile extends StatelessWidget {
  final String name;
  final int count;
  final bool isPremium;

  const LocationTile({
    required this.name,
    required this.count,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                Text('$count Locations', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: isPremium
                ? Image.asset(
              'lib/assets/vpn_logo.png',
              width: 18,
              height: 18,
              color: Colors.grey[700],
            )
                : Icon(
              CupertinoIcons.power,
              color: Colors.blue,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
