import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppGradients {
  const AppGradients._();

  static const LinearGradient shell = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AppColors.deepNavy,
      AppColors.twilight,
      AppColors.softPurple,
    ],
  );

  static LinearGradient screenBackground(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.deepNavy,
            AppColors.midnightBlue,
            AppColors.pine,
          ],
        );
      case 2:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppColors.deepIndigo,
            AppColors.softPurple,
            AppColors.dustyPink,
          ],
        );
      case 3:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.midnightBlue,
            AppColors.twilight,
            AppColors.softCoral,
          ],
        );
      default:
        return shell;
    }
  }

  static List<Color> soundArtwork(String category) {
    switch (category) {
      case 'Nature':
        return const <Color>[
          AppColors.mistBlue,
          AppColors.pine,
          AppColors.deepNavy,
        ];
      case 'ASMR':
        return const <Color>[
          AppColors.dustyPink,
          AppColors.softPurple,
          AppColors.deepIndigo,
        ];
      case 'City':
        return const <Color>[
          AppColors.mutedLavender,
          AppColors.midnightBlue,
          AppColors.deepNavy,
        ];
      case 'Cafe':
        return const <Color>[
          AppColors.softGold,
          AppColors.softCoral,
          AppColors.softPurple,
        ];
      case 'Sleep':
        return const <Color>[
          AppColors.moonWhite,
          AppColors.mutedLavender,
          AppColors.deepIndigo,
        ];
      case 'Focus':
        return const <Color>[
          AppColors.warmBeige,
          AppColors.mistBlue,
          AppColors.midnightBlue,
        ];
      default:
        return const <Color>[
          AppColors.midnightBlue,
          AppColors.softPurple,
          AppColors.deepNavy,
        ];
    }
  }

  static List<Color> quoteCard = const <Color>[
    AppColors.moonWhite,
    AppColors.warmBeige,
    AppColors.dustyPink,
  ];

  static List<Color> premium = const <Color>[
    AppColors.softGold,
    AppColors.dustyPink,
    AppColors.softPurple,
  ];
}
