# AGENTS.md

## Project Goal

Build a dreamy soundscape app with ASMR, Pomodoro timer, daily quote notification, and saved quotes.

The app should feel calm, soft, premium, and emotionally immersive.

Main concept:

- Soundscape
- ASMR
- Pomodoro
- Daily Quote
- Quote Save
- Premium / In-App Purchase ready structure

Working app name:

Soundscape Days

Alternative names:

- Quiet Days
- Dream Room
- Soft Night
- Very Quiet

## Core Design Direction

The UI should follow a dreamy, soft, atmospheric style.

Keywords:

- dreamy
- calm
- night
- soft gradient
- blurred background
- glassmorphism
- quiet luxury
- minimal
- premium
- emotional
- cinematic
- ASMR mood
- night sky
- rain
- soft clouds
- moon
- warm dark mode

Avoid:

- childish design
- overly colorful UI
- generic productivity app feeling
- harsh contrast
- default Flutter look
- corporate SaaS feeling
- too many icons
- too many borders
- bright white background

## Color Palette

Use mostly dark and muted colors.

Recommended colors:

- Deep navy: #0B1020
- Midnight blue: #11182E
- Soft purple: #3A335C
- Dusty pink: #B98299
- Warm beige: #D9B99B
- Moon white: #F4EDE3

Use gradients often, but keep them subtle.

Example gradient:

- top: #0B1020
- middle: #1B2440
- bottom: #3A335C

Accent color:

- warm beige or soft pink

## Typography

Use elegant typography.

Title style:

- serif-like feeling
- large but not too big
- soft spacing
- calm

Body style:

- clean sans-serif
- easy to read
- medium size

If Google Fonts are available, consider:

- Playfair Display for titles
- Pretendard / Inter / Noto Sans for body

Do not use overly cute fonts.

## App Structure

Use bottom navigation with 4 tabs:

1. Sounds
2. Timer
3. Quote
4. My

Bottom navigation should be dark, rounded, slightly transparent, and glass-like.

## Main Screens

### 1. Sounds / Home Player

Purpose:

Let the user immediately feel calm and start a soundscape.

Main UI:

- full-screen dreamy background
- moon or soft atmospheric visual
- selected sound title
- short mood tag
- play / pause button
- previous / next button
- volume slider
- favorite button
- bottom navigation

Example sound title:

Midnight Rain

Example tags:

Rain · Night · Relax

Player button should be large, round, soft, and glass-like.

### 2. Sound List

Purpose:

Allow users to select soundscapes.

Categories:

- All
- Nature
- ASMR
- City
- Cafe
- Sleep
- Focus

Sound examples:

- Midnight Rain
- Rainy Forest
- Ocean Waves
- Cozy Fireplace
- Night Train
- Wind in Trees
- Soft Piano
- Tokyo Night
- Quiet Cafe
- Morning Birds

Each sound item should include:

- thumbnail
- title
- duration
- category
- favorite icon

Also include a mini player at the bottom when audio is playing.

### 3. Mix Studio

Purpose:

Allow premium users to mix multiple sounds.

UI:

- large mood image
- list of sound layers
- volume slider per sound
- save mix button
- play / pause button

Sound layers:

- Rain
- Piano
- City
- Wind
- Fire
- Cafe

This screen should be premium-ready.

Free users may see locked elements.

### 4. Pomodoro / Timer

Purpose:

Focus or relax with sound.

Modes:

- Focus
- Short Break
- Long Break
- Sleep Timer

Default timer:

25:00

UI:

- circular progress timer
- start / pause button
- session count
- selected sound
- mode selector

Keep this screen extremely minimal and calm.

### 5. Daily Quote

Purpose:

Show one daily quote and allow user to save it.

UI:

- date
- large quote text
- author
- save heart button
- share button
- refresh button

Example quote:

"The best way to predict the future is to create it."

Author:

Peter Drucker

Do not make this screen feel like a generic quote app. It should feel like a quiet reflection room.

### 6. My / Settings

Sections:

- Saved Quotes
- Favorite Sounds
- Timer History
- Premium
- Notification Settings
- App Theme
- About

Notification settings:

- Daily quote notification time
- Focus reminder
- Sleep reminder

## Premium / In-App Purchase Structure

Prepare the project structure for premium features.

Premium features:

- All premium sound packs
- Mix custom sounds
- Unlimited saved mixes
- Unlimited quote saves
- Sleep timer
- Advanced Pomodoro settings
- Premium themes
- Widgets in the future

Do not fully implement real payment unless requested.
But create clean code structure so I can connect in-app purchase later.

Use names like:

- PremiumService
- SubscriptionState
- isPremium
- PremiumGate
- PremiumPaywallScreen

Paywall copy example:

Title:

Unlock Your Peaceful Universe

Benefits:

- All premium sounds & rooms
- Mix custom sounds
- Sleep & timer unlimited
- Daily quotes unlimited
- Widgets & more

Button:

Start Free Trial

Price placeholder:

¥490 / month

## Notification

Prepare notification-ready structure.

Daily quote notification example:

Title:

Soundscape Days

Body:

Today’s Quote  
"Believe you can and you’re halfway there."

Do not fully implement platform-specific notification unless requested.
But prepare service files and clean TODO comments.

Use names like:

- NotificationService
- DailyQuoteNotification
- QuoteScheduler

## Data Models

Create clean models for:

SoundItem

Fields:

- id
- title
- category
- duration
- imagePath
- audioPath
- isPremium
- isFavorite

QuoteItem

Fields:

- id
- text
- author
- date
- isSaved

TimerSession

Fields:

- id
- mode
- durationMinutes
- completedAt
- soundId

SoundMix

Fields:

- id
- title
- layers
- createdAt
- isPremium

## Assets

Use placeholder local assets first.

Expected asset folders:

assets/images/
assets/sounds/
assets/icons/

Image placeholders can be gradient containers if no real image exists.

Do not block progress because assets are missing.
Create beautiful placeholder UI with gradients.

## Code Style

Use clean Flutter architecture.

Recommended structure:

lib/
  main.dart
  app.dart
  core/
    theme/
    constants/
    widgets/
  features/
    sounds/
    timer/
    quote/
    my/
    premium/
    notification/
  data/
    models/
    mock/

Keep files small and readable.

Avoid putting all logic in main.dart.

## UX Principles

Every screen should feel calm within 3 seconds.

Use:

- soft motion
- fade in
- rounded cards
- glass panels
- subtle shadows
- generous spacing
- minimal text

Avoid:

- dense settings
- noisy buttons
- technical labels
- too many visible functions at once

## Animation

Use small animations only.

Good:

- fade in
- slow background movement
- soft scale on play button
- progress animation
- gentle page transition

Avoid:

- bouncy cartoon animation
- fast motion
- flashy effects

## Language

Initial app language:

English only.

Prepare strings in a way that Japanese and Korean can be added later.

Use simple, elegant English.

## Important Instruction

Prioritize building a beautiful working prototype first.

Do not over-engineer.

First milestone:

- bottom navigation works
- Sounds screen works visually
- Timer screen works visually
- Quote screen works visually
- My screen works visually
- mock data exists
- premium-ready structure exists
- notification-ready structure exists

Do not implement real audio playback, real notification, or real in-app purchase until requested.

Use clean TODO comments where real integration is needed.

## Final Output Expected

Create or refactor the Flutter app according to this AGENTS.md.

The result should be a polished prototype that looks close to a premium App Store product.