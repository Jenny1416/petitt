import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      height: 76,
      decoration: BoxDecoration(
        color: const Color(0xff123516),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff123516).withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavBarItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
            label: 'Inicio',
          ),
          _NavBarItem(
            icon: Icons.favorite_border_rounded,
            activeIcon: Icons.favorite_rounded,
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
            label: 'Deseos',
          ),
          _NavBarItem(
            icon: Icons.shopping_cart_outlined,
            activeIcon: Icons.shopping_cart_rounded,
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
            label: 'Carrito',
          ),
          _NavBarItem(
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long_rounded,
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
            label: 'Pedidos',
          ),
          _NavBarItem(
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            isSelected: currentIndex == 4,
            onTap: () => onTap(4),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;
  final String label;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffD4933E).withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? const Color(0xffD4933E) : Colors.white.withOpacity(0.7),
              size: 26,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xffD4933E),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
