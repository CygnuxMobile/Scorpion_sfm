import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_handler.dart';

/// Generates a stable hardware-based device fingerprint.
///
/// WHY Android ID is critical:
///   Brand + Model + Manufacturer are the SAME for all phones of the same model.
///   e.g. 1000 Realme Narzo 30A phones â†’ all have brand="realme", model="RMX3171".
///   Without Android ID, all those phones would get the SAME hash â†’ collision!
///   Android ID is randomly generated per device at factory â†’ always unique.
///
/// FALLBACK CHAIN:
///   Level 1 â€” Android ID available + hardware fields â†’ SHA256 (unique, stable)
///   Level 2 â€” Android ID missing â†’ SecureStorage UUID (unique per device install)
///   Level 3 â€” SecureStorage fails â†’ Last resort platform hash (WARN: not unique!)
class DeviceFingerprintService {
  static const _storageKey        = 'permanent_device_fingerprint';
  static const _persistentUuidKey = 'device_fallback_uuid';

  static const _secureStorage = FlutterSecureStorage(
    // Android: EncryptedSharedPreferences â€” cleared on app uninstall
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'PermanentDeviceStorage',
    ),
    // iOS: Keychain â€” PERSISTS even after app uninstall (iOS feature)
    // accessibility: first_unlock = readable after first device unlock after restart
    // groupId / accountName = null means app-private keychain (default, most secure)
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Public API
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Returns a stable, unique fingerprint for this physical device.
  static Future<String> getStableFingerprint() async {
    ApiHandler.logger.i(
      'â•”â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•—\n'
      'â•‘         DEVICE FINGERPRINT â€” START               â•‘\n'
      'â•šâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•',
    );

    // Fast path: use cached value
    try {
      final cached = await _secureStorage.read(key: _storageKey);
      if (cached != null && cached.isNotEmpty) {
        ApiHandler.logger.i(
          '[FINGERPRINT] âœ… Cache hit\n'
          '[FINGERPRINT] ðŸ”‘ Cached ID : $cached',
        );
        return cached;
      }
      ApiHandler.logger.i('[FINGERPRINT] ðŸ“­ No cache â€” generating fingerprint');
    } catch (e) {
      ApiHandler.logger.w('[FINGERPRINT] âš ï¸  Cache read failed: $e');
    }

    final fingerprint = await _buildFingerprint();

    try {
      await _secureStorage.write(key: _storageKey, value: fingerprint);
      ApiHandler.logger.i('[FINGERPRINT] ðŸ’¾ Saved to SecureStorage');
    } catch (e) {
      ApiHandler.logger.w('[FINGERPRINT] âš ï¸  Cache write failed: $e');
    }

    ApiHandler.logger.i(
      'â•”â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•—\n'
      'â•‘         DEVICE FINGERPRINT â€” DONE                â•‘\n'
      'â•‘  ðŸ”‘ Final ID : $fingerprint\n'
      'â•šâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•',
    );
    return fingerprint;
  }

  /// Returns true if the app is running on an emulator / simulator.
  static Future<bool> isEmulator() async {
    ApiHandler.logger.i('[FINGERPRINT] ðŸ” Checking: Is Emulator?');
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        final onEmulator = !info.isPhysicalDevice;
        ApiHandler.logger.i(
          '[FINGERPRINT] ðŸ“± isPhysicalDevice : ${info.isPhysicalDevice}\n'
          '[FINGERPRINT] ðŸ“± Model            : ${info.model}\n'
          '[FINGERPRINT] ðŸ“± Result           : ${onEmulator ? "âš ï¸  EMULATOR DETECTED" : "âœ… Real Device"}',
        );
        return onEmulator;
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        final onSimulator = !info.isPhysicalDevice;
        ApiHandler.logger.i(
          '[FINGERPRINT] ðŸ“± isPhysicalDevice : ${info.isPhysicalDevice}\n'
          '[FINGERPRINT] ðŸ“± Model            : ${info.model}\n'
          '[FINGERPRINT] ðŸ“± Result           : ${onSimulator ? "âš ï¸  SIMULATOR DETECTED" : "âœ… Real Device"}',
        );
        return onSimulator;
      }
    } catch (e) {
      ApiHandler.logger.e('[FINGERPRINT] âŒ Emulator check error: $e');
    }
    return false;
  }

  /// Returns true if the device is rooted (Android) or jailbroken (iOS).
  static Future<bool> isRootedOrJailbroken() async {
    ApiHandler.logger.i('[FINGERPRINT] ðŸ” Checking: Is Rooted / Jailbroken?');
    try {
      if (Platform.isAndroid) return await _isAndroidRooted();
      if (Platform.isIOS)     return await _isIOSJailbroken();
    } catch (e) {
      ApiHandler.logger.e('[FINGERPRINT] âŒ Root check error: $e');
    }
    ApiHandler.logger.i('[FINGERPRINT] âœ… Root check passed â€” device clean');
    return false;
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Fingerprint Build â€” Critical Logic
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static Future<String> _buildFingerprint() async {
    ApiHandler.logger.i('[FINGERPRINT] ðŸ“¡ Reading hardware info...');

    if (Platform.isAndroid) {
      return await _buildAndroidFingerprint();
    } else if (Platform.isIOS) {
      return await _buildIosFingerprint();
    }

    return await _fallbackUuid('Unsupported platform');
  }

  /// Known duplicate Android IDs found across millions of devices.
  /// These values are NOT unique â€” using them causes fingerprint collision.
  /// Sources: AOSP bug tracker, Stack Overflow reports, device manufacturer bugs.
  static const _knownBadAndroidIds = {
    '9774d56d682e549c', // Default Android emulator / many Chinese ROMs
    '0000000000000000', // All zeros â€” reset/corrupted devices
    '1111111111111111', // Sequential â€” some factory reset devices
    'abcdef1234567890', // Known test value
    'dead00beef000000', // Known test value
    '0123456789abcdef', // Sequential â€” some MTK chipset devices
    'unknown',
    '',
  };

  static Future<String> _buildAndroidFingerprint() async {
    try {
      final info = await DeviceInfoPlugin().androidInfo;

      // â”€â”€ Log all raw values â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      ApiHandler.logger.i(
        '[FINGERPRINT] â”Œâ”€â”€â”€ Android Hardware Info â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€\n'
        '[FINGERPRINT] â”‚  Android ID   : ${info.id}\n'
        '[FINGERPRINT] â”‚  Brand        : ${info.brand}\n'
        '[FINGERPRINT] â”‚  Model        : ${info.model}\n'
        '[FINGERPRINT] â”‚  Manufacturer : ${info.manufacturer}\n'
        '[FINGERPRINT] â”‚  Board        : ${info.board}\n'
        '[FINGERPRINT] â”‚  Hardware     : ${info.hardware}\n'
        '[FINGERPRINT] â”‚  Device       : ${info.device}\n'
        '[FINGERPRINT] â”‚  Product      : ${info.product}\n'
        '[FINGERPRINT] â”‚  Display      : ${info.display}\n'
        '[FINGERPRINT] â”‚  SDK Int      : ${info.version.sdkInt}\n'
        '[FINGERPRINT] â”‚  isPhysical   : ${info.isPhysicalDevice}\n'
        '[FINGERPRINT] â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€',
      );

      // â”€â”€ CRITICAL CHECK: Android ID â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      // Android ID is the ONLY field that makes same-model phones unique.
      // BUT: some devices return known DUPLICATE Android IDs shared by
      // millions of devices (e.g. "9774d56d682e549c" on Chinese ROMs).
      // These must be treated as invalid to avoid fingerprint collision.
      final androidId         = info.id.trim().toLowerCase();
      final androidIdInvalid  = _knownBadAndroidIds.contains(androidId);
      final androidIdValid    = !androidIdInvalid;

      ApiHandler.logger.i(
        '[FINGERPRINT] ðŸ”‘ Android ID validation:\n'
        '[FINGERPRINT]    Raw value     : "${info.id}"\n'
        '[FINGERPRINT]    Normalised    : "$androidId"\n'
        '[FINGERPRINT]    In blocklist  : $androidIdInvalid\n'
        '[FINGERPRINT]    Is valid      : $androidIdValid',
      );

      if (!androidIdValid) {
        ApiHandler.logger.w(
          '[FINGERPRINT] âš ï¸  Android ID is invalid/duplicate!\n'
          '[FINGERPRINT]    Value  : "$androidId"\n'
          '[FINGERPRINT]    Reason : Known duplicate ID shared by many devices.\n'
          '[FINGERPRINT]    Action : Using UUID fallback to avoid collision.',
        );
        return await _fallbackUuid('Bad Android ID "$androidId" on ${info.brand} ${info.model}');
      }

      // â”€â”€ Level 1: Android ID valid â†’ Build hardware hash â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      // Include as many non-empty, non-unknown fields as possible.
      // More unique fields = lower collision probability.
      final parts = [
        androidId,
        info.brand,
        info.model,
        info.manufacturer,
        if (info.board.isNotEmpty    && info.board    != 'unknown') info.board,
        if (info.hardware.isNotEmpty && info.hardware != 'unknown') info.hardware,
        if (info.device.isNotEmpty   && info.device   != 'unknown') info.device,
        if (info.product.isNotEmpty  && info.product  != 'unknown') info.product,
      ];

      final raw         = parts.join('|');
      final fingerprint = _sha256(raw);

      ApiHandler.logger.i(
        '[FINGERPRINT] âœ… Level 1 â€” Full Android fingerprint\n'
        '[FINGERPRINT]    Parts used  : $parts\n'
        '[FINGERPRINT]    Raw string  : $raw\n'
        '[FINGERPRINT]    SHA256 ID   : $fingerprint',
      );
      return fingerprint;

    } catch (e) {
      ApiHandler.logger.e('[FINGERPRINT] âŒ Android hardware read failed: $e');
      return await _fallbackUuid('Android hardware read exception');
    }
  }

  static Future<String> _buildIosFingerprint() async {
    try {
      final info = await DeviceInfoPlugin().iosInfo;

      ApiHandler.logger.i(
        '[FINGERPRINT] â”Œâ”€â”€â”€ iOS Hardware Info â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€\n'
        '[FINGERPRINT] â”‚  IDFV         : ${info.identifierForVendor}\n'
        '[FINGERPRINT] â”‚  Model        : ${info.model}\n'
        '[FINGERPRINT] â”‚  LocalModel   : ${info.localizedModel}\n'
        '[FINGERPRINT] â”‚  SystemName   : ${info.systemName}\n'
        '[FINGERPRINT] â”‚  SystemVer    : ${info.systemVersion}\n'
        '[FINGERPRINT] â”‚  isPhysical   : ${info.isPhysicalDevice}\n'
        '[FINGERPRINT] â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€',
      );

      // IDFV = unique per device per vendor â€” the iOS equivalent of Android ID
      final idfv = info.identifierForVendor ?? '';
      final idfvValid = idfv.isNotEmpty && idfv != 'unknown';

      ApiHandler.logger.i(
        '[FINGERPRINT] ðŸ”‘ IDFV check:\n'
        '[FINGERPRINT]    Raw value : "$idfv"\n'
        '[FINGERPRINT]    Is valid  : $idfvValid',
      );

      if (!idfvValid) {
        ApiHandler.logger.w(
          '[FINGERPRINT] âš ï¸  IDFV null â€” same risk as Android ID missing.\n'
          '[FINGERPRINT]    ACTION: Using UUID fallback.',
        );
        return await _fallbackUuid('IDFV missing on iOS ${info.model}');
      }

      final parts       = [idfv, info.model, info.localizedModel, info.systemName];
      final raw         = parts.join('|');
      final fingerprint = _sha256(raw);

      ApiHandler.logger.i(
        '[FINGERPRINT] âœ… Level 1 â€” Full iOS fingerprint\n'
        '[FINGERPRINT]    Parts used  : $parts\n'
        '[FINGERPRINT]    SHA256 ID   : $fingerprint',
      );
      return fingerprint;

    } catch (e) {
      ApiHandler.logger.e('[FINGERPRINT] âŒ iOS hardware read failed: $e');
      return await _fallbackUuid('iOS hardware read exception');
    }
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Fallback UUID â€” used when Android ID / IDFV is unavailable
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Generates or retrieves a persistent UUID from SecureStorage.
  ///
  /// This is used when the unique device identifier (Android ID / IDFV) is
  /// unavailable. It is unique per device but changes if app data is cleared.
  static Future<String> _fallbackUuid(String reason) async {
    ApiHandler.logger.w(
      '[FINGERPRINT] âš ï¸  Fallback UUID triggered\n'
      '[FINGERPRINT]    Reason : $reason\n'
      '[FINGERPRINT]    Action : Reading persistent UUID from SecureStorage',
    );

    try {
      final existing = await _secureStorage.read(key: _persistentUuidKey);
      if (existing != null && existing.isNotEmpty) {
        ApiHandler.logger.i(
          '[FINGERPRINT] ðŸ“¦ Existing UUID found (stable across reinstalls)\n'
          '[FINGERPRINT]    UUID   : $existing\n'
          '[FINGERPRINT]    âš ï¸  Note: Changes if user clears app data',
        );
        return existing;
      }

      // Generate new UUID seeded by time (unique per generation)
      final seed    = '${Platform.operatingSystem}_${DateTime.now().microsecondsSinceEpoch}_${reason.hashCode}';
      final newUuid = _sha256(seed);
      await _secureStorage.write(key: _persistentUuidKey, value: newUuid);

      ApiHandler.logger.i(
        '[FINGERPRINT] ðŸ†• New UUID generated and saved\n'
        '[FINGERPRINT]    UUID   : $newUuid\n'
        '[FINGERPRINT]    âš ï¸  Note: Stable until app data is cleared',
      );
      return newUuid;

    } catch (e) {
      // â”€â”€ Level 3: SecureStorage also failed â€” absolute last resort â”€â”€â”€â”€
      final lastResort = _sha256(
        '${Platform.operatingSystem}_${Platform.numberOfProcessors}_${reason}_lastresort',
      );
      ApiHandler.logger.e(
        '[FINGERPRINT] âŒ LAST RESORT â€” SecureStorage also failed!\n'
        '[FINGERPRINT]    Error   : $e\n'
        '[FINGERPRINT]    âš ï¸  WARNING: ID may NOT be unique across same-model devices!\n'
        '[FINGERPRINT]    ID      : $lastResort',
      );
      return lastResort;
    }
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Root / Jailbreak Detection
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static Future<bool> _isAndroidRooted() async {
    // 1. Build tags
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      ApiHandler.logger.i('[FINGERPRINT] ðŸ·ï¸  Build tags : ${info.tags}');
      if (info.tags.contains('test-keys')) {
        ApiHandler.logger.w('[FINGERPRINT] âš ï¸  Root â€” build tag "test-keys"');
        return true;
      }
    } catch (_) {}

    // 2. su binary
    const suPaths = [
      '/system/bin/su', '/system/xbin/su', '/sbin/su',
      '/system/su', '/system/bin/.ext/.su', '/system/xbin/mu',
    ];
    for (final path in suPaths) {
      if (await File(path).exists()) {
        ApiHandler.logger.w('[FINGERPRINT] âš ï¸  Root â€” su at: $path');
        return true;
      }
    }

    // 3. Root apps
    const rootApps = [
      '/data/app/com.topjohnwu.magisk', '/data/data/com.topjohnwu.magisk',
      '/data/app/eu.chainfire.supersu',  '/data/data/eu.chainfire.supersu',
    ];
    for (final path in rootApps) {
      if (await Directory(path).exists()) {
        ApiHandler.logger.w('[FINGERPRINT] âš ï¸  Root â€” app at: $path');
        return true;
      }
    }

    ApiHandler.logger.i('[FINGERPRINT] âœ… No root found');
    return false;
  }

  static Future<bool> _isIOSJailbroken() async {
    const jbPaths = [
      '/Applications/Cydia.app',
      '/Library/MobileSubstrate/MobileSubstrate.dylib',
      '/bin/bash', '/usr/sbin/sshd', '/etc/apt',
    ];
    for (final path in jbPaths) {
      if (await File(path).exists()) {
        ApiHandler.logger.w('[FINGERPRINT] âš ï¸  Jailbreak â€” path exists: $path');
        return true;
      }
    }
    ApiHandler.logger.i('[FINGERPRINT] âœ… No jailbreak found');
    return false;
  }


  // ─────────────────────────────────────────────────────────────────────────
  // Combined ID — Device Fingerprint + User ID
  // ─────────────────────────────────────────────────────────────────────────

  /// Generates a combined unique ID from device fingerprint + userId.
  ///
  /// WHY this is needed:
  ///   Even after blocklisting known bad Android IDs, two different users on
  ///   the same device could still get same fingerprint.
  ///   Combining with userId guarantees uniqueness per USER per DEVICE.
  ///
  ///   Same user  + same device  → same combined ID  (login works)
  ///   Same user  + diff device  → diff combined ID  (blocked by server)
  ///   Diff user  + same device  → diff combined ID  (no collision!)
  ///   Scammer    + diff device  → diff combined ID  (blocked by server)
  ///
  /// Formula: SHA256( deviceFingerprint + "::" + userId.toLowerCase() )
  static String generateCombinedId({
    required String deviceFingerprint,
    required String userId,
  }) {
    final normalizedUserId = userId.trim().toLowerCase();
    final raw              = '$deviceFingerprint::$normalizedUserId';
    final combinedId       = _sha256(raw);

    ApiHandler.logger.i(
      '[FINGERPRINT] Combined ID generated\n'
      '[FINGERPRINT]    Device FP : $deviceFingerprint\n'
      '[FINGERPRINT]    User ID   : $normalizedUserId\n'
      '[FINGERPRINT]    Formula   : SHA256(deviceFP::userId)\n'
      '[FINGERPRINT]    Result    : $combinedId',
    );

    return combinedId;
  }
  static String _sha256(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}

