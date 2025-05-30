import 'package:flutter/material.dart';
import 'package:spotted/domain/models/models.dart';
import 'package:spotted/presentation/widgets/widgets.dart';

class UserInfoRow extends StatelessWidget {
  const UserInfoRow({
    super.key,
    required this.onTap,
    required this.user,
    this.formattedDate,
  });

  final VoidCallback onTap;
  final User user;
  final String? formattedDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CirclePicture(
            minRadius: 20,
            maxRadius: 20,
            urlPicture: user.profileImageUrl,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.completeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '@${user.username}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          if (formattedDate != null)
            Text(
              formattedDate!,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
        ],
      ),
    );
  }
}
