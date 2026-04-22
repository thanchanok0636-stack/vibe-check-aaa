import 'package:flutter/material.dart';
import 'package:vibe_check_aaa/screens/quick_vital_screen.dart';
import 'preop_screen.dart';
import 'postop_screen.dart';
import 'aaa_size_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),

      // ---------- APP BAR ----------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'VIBE-CHECK AAA',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // ---------- BODY ----------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------- HEADER ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'VIBE-CHECK AAA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB71C1C),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'AAA ZERO-DELAY : THE ULTIMATE GUARD',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Surgical Male Ward 3',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),

            // ---------- MENU CARDS ----------
            _menuCard(
              context,
              icon: Icons.assignment_turned_in,
              title: 'Pre-operative Assessment',
              subtitle: 'ประเมินผู้ป่วยก่อนผ่าตัด',
              color: const Color(0xFFD32F2F),
              page: const PreOpScreen(),
            ),

            _menuCard(
              context,
              icon: Icons.monitor_heart,
              title: 'Post-operative Monitoring',
              subtitle: 'เฝ้าระวังภาวะแทรกซ้อนหลังผ่าตัด',
              color: const Color(0xFFC62828),
              page: const PostOpScreen(),
            ),

            _menuCard(
              context,
              icon: Icons.straighten,
              title: 'AAA Size Evaluation',
              subtitle: 'ประเมินขนาดหลอดเลือดโป่งพอง',
              color: const Color(0xFFB71C1C),
              page: const AaaSizeScreen(),
            ),

            _menuCard(
              context,
              icon: Icons.assignment_rounded,
              title: 'AAA quick vital',
              subtitle: 'ประเมินจาก Vital sign อย่างเดียว',
              color: const Color(0xFFB71C1C),
              page: const QuickVitalScreen(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- MENU CARD ----------
  Widget _menuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget page,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
