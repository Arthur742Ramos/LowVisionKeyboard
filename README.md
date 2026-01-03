# Accessible iPad Keyboard

A custom iPad keyboard designed for people with low vision, featuring:

- **Extra large keys** - Customizable from 50 to 120 points height
- **Large, bold fonts** - Up to 48pt font size
- **High contrast mode** - Black text on white keys with thick borders
- **Audio feedback** - Key click sounds
- **Haptic feedback** - Vibration on key press
- **Simple, clean layout** - Easy to navigate

## Features

### Accessibility Features
- Adjustable key height (50-120 points)
- Adjustable font size (18-48 points)
- High contrast black/white color scheme
- VoiceOver compatible
- Audio feedback for key presses
- Haptic feedback for tactile confirmation

### Quick Presets
- **Medium**: 60pt keys, 24pt font
- **Large**: 80pt keys, 32pt font
- **Extra Large**: 100pt keys, 40pt font

## Setup Instructions

### Step 1: Add the Keyboard Extension Target

1. Open `IpadKeyboard.xcodeproj` in Xcode
2. Go to **File → New → Target**
3. Choose **iOS → Keyboard Extension**
4. Name it `AccessibleKeyboard`
5. Click **Finish**

### Step 2: Configure App Groups

Both the main app and keyboard extension need to share settings via App Groups:

1. Select the **IpadKeyboard** target
2. Go to **Signing & Capabilities**
3. Click **+ Capability** and add **App Groups**
4. Add a group named `group.com.ipadkeyboard.accessible`

5. Select the **AccessibleKeyboard** target
6. Repeat steps 2-4 to add the same App Group

### Step 3: Add the Keyboard Extension Files

Copy these files to your AccessibleKeyboard target:
- `AccessibleKeyboard/KeyboardViewController.swift`
- `AccessibleKeyboard/KeyView.swift`
- `AccessibleKeyboard/AccessibleKeyboardView.swift`

Make sure they are included in the AccessibleKeyboard target (check the Target Membership in the File Inspector).

### Step 4: Update the Keyboard Extension Info.plist

Replace the contents of `AccessibleKeyboard/Info.plist` with:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSExtension</key>
    <dict>
        <key>NSExtensionAttributes</key>
        <dict>
            <key>IsASCIICapable</key>
            <true/>
            <key>PrefersRightToLeft</key>
            <false/>
            <key>PrimaryLanguage</key>
            <string>en-US</string>
            <key>RequestsOpenAccess</key>
            <true/>
        </dict>
        <key>NSExtensionPointIdentifier</key>
        <string>com.apple.keyboard-service</string>
        <key>NSExtensionPrincipalClass</key>
        <string>$(PRODUCT_MODULE_NAME).KeyboardViewController</string>
    </dict>
</dict>
</plist>
```

### Step 5: Build and Run

1. Select your iPad device or simulator
2. Build and run the main app first to install it
3. The keyboard extension will be installed automatically

### Step 6: Enable the Keyboard on iPad

1. Open **Settings** app on your iPad
2. Go to **General → Keyboard → Keyboards**
3. Tap **Add New Keyboard...**
4. Select **Accessible Keyboard** from the list
5. Tap the keyboard again and enable **Allow Full Access** (needed for settings sync and haptic feedback)

### Step 7: Use the Keyboard

1. Open any app with a text field (Notes, Messages, etc.)
2. Long-press the 🌐 globe icon on the keyboard
3. Select **Accessible Keyboard**
4. Enjoy the large, accessible keys!

## Customizing Settings

Open the **IpadKeyboard** app to customize:

- **Key Height**: Slide to adjust how tall each key is
- **Font Size**: Slide to adjust the size of letters on keys
- **High Contrast Mode**: Toggle for maximum visibility
- **Key Click Sound**: Toggle audio feedback
- **Haptic Feedback**: Toggle vibration feedback

Changes are applied immediately to the keyboard.

## Troubleshooting

### Keyboard not appearing in Settings
- Make sure you've built and run the app at least once
- Check that the keyboard extension target builds without errors

### Settings not syncing
- Ensure both targets have the same App Group configured
- Grant "Full Access" to the keyboard in Settings

### Keyboard looks wrong
- Restart the app where you're typing
- Toggle the keyboard off and on in Settings

## Project Structure

```
IpadKeyboard/
├── IpadKeyboard/                    # Main app (settings)
│   ├── ContentView.swift           # Settings UI
│   ├── IpadKeyboardApp.swift       # App entry point
│   └── Info.plist
├── AccessibleKeyboard/              # Keyboard extension
│   ├── KeyboardViewController.swift # Main keyboard controller
│   ├── KeyView.swift               # Individual key button
│   ├── AccessibleKeyboardView.swift # Keyboard layout container
│   └── Info.plist                  # Extension configuration
└── README.md
```

## License

Free to use and modify for accessibility purposes.
