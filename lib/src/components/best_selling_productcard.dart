import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';

class BestSellingProductCard extends StatelessWidget {
  final VoidCallback onTap;

  const BestSellingProductCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(bottom: appPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(appRadius),
          gradient: const LinearGradient(
            // colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            colors: [colorPrimary, colorSecondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Formas decorativas
            Positioned(
              top: -30,
              right: -30,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: colorTertiary.withOpacity(0.1),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white.withOpacity(0.2),
              ),
            ),

            // Conteúdo principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appMargin),
              child: Row(
                children: [
                  Lottie.asset("assets/images/trophy.json", repeat: false),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Top 10 produtos',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Separamos pra você os itens que mais foram negociados no evento pelo fornecedor! Confira abaixo!',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
