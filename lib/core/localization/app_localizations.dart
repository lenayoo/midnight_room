import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(localizations != null, 'AppLocalizations not found in context.');
    return localizations!;
  }

  String get _languageCode {
    switch (locale.languageCode) {
      case 'ja':
      case 'ko':
        return locale.languageCode;
      default:
        return 'en';
    }
  }

  String get appName => 'Midnight Room';

  String get soundsTabLabel {
    switch (_languageCode) {
      case 'ja':
        return 'サウンド';
      case 'ko':
        return '사운드';
      default:
        return 'Sounds';
    }
  }

  String get quoteTabLabel {
    switch (_languageCode) {
      case 'ja':
        return 'ことば';
      case 'ko':
        return '문장';
      default:
        return 'Quote';
    }
  }

  String get myTabLabel {
    switch (_languageCode) {
      case 'ja':
        return 'わたし';
      case 'ko':
        return '나';
      default:
        return 'My';
    }
  }

  String get soundsScreenTitle => appName;

  String get allSoundsLabel {
    switch (_languageCode) {
      case 'ja':
        return 'すべてのサウンド';
      case 'ko':
        return '모든 사운드';
      default:
        return 'All sounds';
    }
  }

  String get favoriteSoundsLabel {
    switch (_languageCode) {
      case 'ja':
        return '好きなサウンド';
      case 'ko':
        return '좋아하는 사운드';
      default:
        return 'Favorite sounds';
    }
  }

  String get favoriteSoundsEmptyLabel {
    switch (_languageCode) {
      case 'ja':
        return '気になるサウンドにハートを押してみてください。';
      case 'ko':
        return '마음에 드는 사운드에 하트를 눌러보세요.';
      default:
        return 'Tap the heart on any sound you like.';
    }
  }

  String get quoteScreenTitle {
    switch (_languageCode) {
      case 'ja':
        return 'ことば';
      case 'ko':
        return '문장';
      default:
        return 'Quote';
    }
  }

  String get loadingQuotesLabel {
    switch (_languageCode) {
      case 'ja':
        return 'ことばを読み込んでいます...';
      case 'ko':
        return '문장을 불러오는 중...';
      default:
        return 'Loading quotes...';
    }
  }

  String get noQuotesFoundLabel {
    switch (_languageCode) {
      case 'ja':
        return '表示できることばがありません。';
      case 'ko':
        return '표시할 문장이 없어요.';
      default:
        return 'No quotes found.';
    }
  }

  String quoteCategoryLabel(String category) {
    switch (_languageCode) {
      case 'ja':
        switch (category) {
          case 'calm':
            return '静けさ';
          case 'hope':
            return '希望';
          case 'reflection':
            return '余韻';
          default:
            return category;
        }
      case 'ko':
        switch (category) {
          case 'calm':
            return '고요';
          case 'hope':
            return '희망';
          case 'reflection':
            return '사색';
          default:
            return category;
        }
      default:
        switch (category) {
          case 'calm':
            return 'Calm';
          case 'hope':
            return 'Hope';
          case 'reflection':
            return 'Reflection';
          default:
            if (category.isEmpty) {
              return '';
            }
            return '${category[0].toUpperCase()}${category.substring(1)}';
        }
    }
  }

  String formatQuoteDate(DateTime date) {
    switch (_languageCode) {
      case 'ja':
        return '${date.year}年${date.month}月${date.day}日';
      case 'ko':
        return '${date.year}년 ${date.month}월 ${date.day}일';
      default:
        const List<String> months = <String>[
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  String durationLabel(String rawDuration) {
    final RegExpMatch? match = RegExp(r'\d+').firstMatch(rawDuration);
    final String value = match?.group(0) ?? rawDuration;

    switch (_languageCode) {
      case 'ja':
        return '$value分';
      case 'ko':
        return '$value분';
      default:
        return '$value min';
    }
  }

  String soundTitle(String soundId, {String? fallback}) {
    switch (_languageCode) {
      case 'ja':
        switch (soundId) {
          case 'afternoon_rain':
            return '午後の雨';
          case 'in_the_universe':
            return '宇宙のなかで';
          case 'yoga':
            return 'ヨガ';
          case 'crisp_morning':
            return '澄んだ朝';
          case 'stormy_night':
            return '嵐の夜';
          case 'summer_night':
            return '夏の夜';
          case 'sunset_beach':
            return '夕暮れの浜辺';
          case 'under_the_stars':
            return '星の下で';
          case 'weekend_rainy_day':
            return '雨の週末';
          default:
            return fallback ?? soundId;
        }
      case 'ko':
        switch (soundId) {
          case 'afternoon_rain':
            return '오후의 비';
          case 'in_the_universe':
            return '우주 속에서';
          case 'yoga':
            return '요가';
          case 'crisp_morning':
            return '맑은 아침';
          case 'stormy_night':
            return '폭풍우 치는 밤';
          case 'summer_night':
            return '여름 밤';
          case 'sunset_beach':
            return '노을 해변';
          case 'under_the_stars':
            return '별 아래에서';
          case 'weekend_rainy_day':
            return '비 내리는 주말';
          default:
            return fallback ?? soundId;
        }
      default:
        switch (soundId) {
          case 'afternoon_rain':
            return 'Afternoon Rain';
          case 'in_the_universe':
            return 'In the Universe';
          case 'yoga':
            return 'Yoga';
          case 'crisp_morning':
            return 'Crisp Morning';
          case 'stormy_night':
            return 'Stormy Night';
          case 'summer_night':
            return 'Summer Night';
          case 'sunset_beach':
            return 'Sunset Beach';
          case 'under_the_stars':
            return 'Under the Stars';
          case 'weekend_rainy_day':
            return 'Weekend Rainy Day';
          default:
            return fallback ?? soundId;
        }
    }
  }

  String soundCategoryLabel(String category) {
    switch (_languageCode) {
      case 'ja':
        switch (category) {
          case 'Nature':
            return '自然';
          case 'ASMR':
            return 'ASMR';
          case 'City':
            return '街';
          case 'Cafe':
            return 'カフェ';
          case 'Sleep':
            return '眠り';
          case 'Focus':
            return '集中';
          case 'Yoga':
            return 'ヨガ';
          default:
            return category;
        }
      case 'ko':
        switch (category) {
          case 'Nature':
            return '자연';
          case 'ASMR':
            return 'ASMR';
          case 'City':
            return '도시';
          case 'Cafe':
            return '카페';
          case 'Sleep':
            return '수면';
          case 'Focus':
            return '집중';
          case 'Yoga':
            return '요가';
          default:
            return category;
        }
      default:
        return category;
    }
  }

  String moodTagLabel(String tag) {
    switch (_languageCode) {
      case 'ja':
        switch (tag) {
          case 'Rain':
            return '雨';
          case 'Afternoon':
            return '午後';
          case 'Relax':
            return '休息';
          case 'Night Sky':
            return '夜空';
          case 'Drift':
            return 'まどろみ';
          case 'Stillness':
            return '静けさ';
          case 'Stretch':
            return '伸び';
          case 'Breathe':
            return '呼吸';
          case 'Align':
            return '整える';
          case 'Morning':
            return '朝';
          case 'Breeze':
            return 'そよ風';
          case 'Reset':
            return 'リセット';
          case 'Thunder':
            return '雷';
          case 'Night':
            return '夜';
          case 'Warm Air':
            return 'ぬくもり';
          case 'Crickets':
            return '虫の音';
          case 'Ocean':
            return '海';
          case 'Golden Hour':
            return '夕映え';
          case 'Ease':
            return 'やすらぎ';
          case 'Stars':
            return '星';
          case 'Dream':
            return '夢';
          case 'Weekend':
            return '週末';
          case 'Cozy':
            return 'ぬくもり';
          default:
            return tag;
        }
      case 'ko':
        switch (tag) {
          case 'Rain':
            return '비';
          case 'Afternoon':
            return '오후';
          case 'Relax':
            return '휴식';
          case 'Night Sky':
            return '밤하늘';
          case 'Drift':
            return '잠잠함';
          case 'Stillness':
            return '고요';
          case 'Stretch':
            return '스트레칭';
          case 'Breathe':
            return '호흡';
          case 'Align':
            return '정렬';
          case 'Morning':
            return '아침';
          case 'Breeze':
            return '산들바람';
          case 'Reset':
            return '리셋';
          case 'Thunder':
            return '천둥';
          case 'Night':
            return '밤';
          case 'Warm Air':
            return '따뜻한 공기';
          case 'Crickets':
            return '귀뚜라미';
          case 'Ocean':
            return '바다';
          case 'Golden Hour':
            return '노을빛';
          case 'Ease':
            return '편안함';
          case 'Stars':
            return '별';
          case 'Dream':
            return '꿈';
          case 'Weekend':
            return '주말';
          case 'Cozy':
            return '포근함';
          default:
            return tag;
        }
      default:
        return tag;
    }
  }

  List<String> moodTagLabels(List<String> tags) {
    return tags.map(moodTagLabel).toList(growable: false);
  }

  String featuredDescription(String soundId) {
    switch (_languageCode) {
      case 'ja':
        switch (soundId) {
          case 'afternoon_rain':
            return '午後の雨音が空気をやわらかく包み、急いでいた気持ちを静かにほどいてくれます。';
          case 'in_the_universe':
            return '眠りに向かう速度をそっと落としてくれる、静かな宇宙の部屋です。';
          case 'under_the_stars':
            return '星明かりの下で、深い呼吸とやわらかな夜の余韻に身をあずけます。';
          case 'yoga':
            return 'ゆるやかな呼吸と落ち着いた動きのための、静かな余白を開きます。';
          case 'crisp_morning':
            return '澄んだ朝の気配が思考を整え、軽く透明な集中へと切り替えてくれます。';
          case 'stormy_night':
            return '遠くの雷と濃い夜の雨が、外の世界を閉じて深い休息へ導きます。';
          case 'summer_night':
            return 'ぬるい夜風と虫の音が、眠る前の気持ちをやさしくゆるめていきます。';
          case 'sunset_beach':
            return '波のゆらぎと夕暮れの温度が、肩の力を抜いて長い余韻を残します。';
          case 'weekend_rainy_day':
            return '雨の週末のようなこもった静けさで、部屋の中の安心感を深めます。';
          default:
            return '';
        }
      case 'ko':
        switch (soundId) {
          case 'afternoon_rain':
            return '오후의 빗소리가 공기를 부드럽게 감싸며, 서둘렀던 마음을 천천히 풀어 줍니다.';
          case 'in_the_universe':
            return '잠들기 전 속도를 천천히 낮춰 주는, 조용한 우주의 방이에요.';
          case 'under_the_stars':
            return '별빛 아래에서 깊게 숨 쉬며 부드러운 밤의 여운에 머물러 보세요.';
          case 'yoga':
            return '고른 호흡과 잔잔한 움직임을 위한 조용한 여백을 열어 둡니다.';
          case 'crisp_morning':
            return '맑은 아침의 공기가 생각을 정돈해 주고, 가볍고 투명한 집중으로 데려가요.';
          case 'stormy_night':
            return '멀리서 울리는 천둥과 짙은 밤비가 바깥을 닫아 주며 깊은 휴식으로 이끕니다.';
          case 'summer_night':
            return '따뜻한 밤공기와 귀뚜라미 소리가 잠들기 전 마음을 부드럽게 느슨하게 해 줘요.';
          case 'sunset_beach':
            return '파도와 노을의 온기가 어깨의 힘을 빼 주고 긴 여운을 남깁니다.';
          case 'weekend_rainy_day':
            return '비 오는 주말 같은 아늑한 고요함으로 방 안의 안정감을 더 깊게 만듭니다.';
          default:
            return '';
        }
      default:
        switch (soundId) {
          case 'afternoon_rain':
            return 'Soft afternoon rain settles the air and gently untangles a hurried state of mind.';
          case 'in_the_universe':
            return 'A quiet cosmic room for slow sleep, stillness, and a softer night pace.';
          case 'under_the_stars':
            return 'A star-lit room for deep breaths, soft silence, and a slower midnight drift.';
          case 'yoga':
            return 'Open the Yoga room for gentle breath, space, and grounded movement.';
          case 'crisp_morning':
            return 'A bright, airy morning atmosphere that clears the mind and steadies your focus.';
          case 'stormy_night':
            return 'Distant thunder and heavy night rain close out the world for deeper rest.';
          case 'summer_night':
            return 'Warm night air and crickets soften the room into an easy, sleepy rhythm.';
          case 'sunset_beach':
            return 'Rolling waves and sunset warmth release the shoulders and leave a long exhale behind.';
          case 'weekend_rainy_day':
            return 'A cozy rainy-weekend mood that makes the room feel sheltered, still, and safe.';
          default:
            return '';
        }
    }
  }

  String audioPreviewFailed(String audioPath) {
    switch (_languageCode) {
      case 'ja':
        return '音声プレビューを読み込めませんでした。$audioPath を確認してください。';
      case 'ko':
        return '오디오 미리보기를 불러오지 못했어요. $audioPath 경로를 확인해 주세요.';
      default:
        return 'Audio preview failed to load. Check $audioPath.';
    }
  }

  String unableToPlay(String soundTitle) {
    switch (_languageCode) {
      case 'ja':
        return '$soundTitle を再生できませんでした。';
      case 'ko':
        return '$soundTitle 재생에 실패했어요.';
      default:
        return 'Unable to play $soundTitle.';
    }
  }

  String get loadingLabel {
    switch (_languageCode) {
      case 'ja':
        return '読み込み中';
      case 'ko':
        return '불러오는 중';
      default:
        return 'Loading';
    }
  }

  String get playLabel {
    switch (_languageCode) {
      case 'ja':
        return '再生';
      case 'ko':
        return '재생';
      default:
        return 'Play';
    }
  }

  String get pauseLabel {
    switch (_languageCode) {
      case 'ja':
        return '一時停止';
      case 'ko':
        return '일시정지';
      default:
        return 'Pause';
    }
  }

  String get preparingRoomLabel {
    switch (_languageCode) {
      case 'ja':
        return '部屋を整えています...';
      case 'ko':
        return '방을 준비하는 중...';
      default:
        return 'Preparing your room...';
    }
  }

  String get oneQuietMomentLabel {
    switch (_languageCode) {
      case 'ja':
        return '静かなひとときです。';
      case 'ko':
        return '잠깐만 조용히 기다려 주세요.';
      default:
        return 'One quiet moment.';
    }
  }

  String get howCanICallYouLabel {
    switch (_languageCode) {
      case 'ja':
        return 'なんとお呼びしましょうか。';
      case 'ko':
        return '어떻게 불러드릴까요?';
      default:
        return 'How can I call you?';
    }
  }

  String get yourNameHint {
    switch (_languageCode) {
      case 'ja':
        return 'お名前';
      case 'ko':
        return '이름';
      default:
        return 'Your name';
    }
  }

  String get enterYourRoomLabel {
    switch (_languageCode) {
      case 'ja':
        return '部屋に入る';
      case 'ko':
        return '방으로 들어가기';
      default:
        return 'Enter your room';
    }
  }

  String get friendLabel {
    switch (_languageCode) {
      case 'ja':
        return '友だち';
      case 'ko':
        return '친구';
      default:
        return 'friend';
    }
  }

  String get welcomeBackGreeting {
    switch (_languageCode) {
      case 'ja':
        return 'おかえりなさい。';
      case 'ko':
        return '잘 돌아왔어요.';
      default:
        return 'Welcome back.';
    }
  }

  String get myScreenIntro {
    switch (_languageCode) {
      case 'ja':
        return 'ゆっくり呼吸を整え、静かにただ居られる小さな夜の部屋です。';
      case 'ko':
        return '천천히 숨을 고르고 조용히 머물 수 있는 작은 밤의 방이에요.';
      default:
        return 'A little room where you can slow down, breathe deeply, and simply be.';
    }
  }

  String get calmYourMindLabel {
    switch (_languageCode) {
      case 'ja':
        return '心をしずかに。';
      case 'ko':
        return '마음을 고요하게.';
      default:
        return 'Calm your mind.';
    }
  }

  String get myScreenReflection {
    switch (_languageCode) {
      case 'ja':
        return 'ひとつひとつの呼吸も歩みも、毎日をやさしく満たしていきます。';
      case 'ko':
        return '모든 숨과 걸음, 그리고 하루하루가 당신의 삶을 다정하게 채워 갑니다.';
      default:
        return 'Every breath, every step, and every day is part of celebrating your life.';
    }
  }

  String get justBreatheLabel {
    return 'Just breathe';
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return <String>{'en', 'ja', 'ko'}.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
