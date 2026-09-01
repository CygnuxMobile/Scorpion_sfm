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
///   e.g. 1000 Realme Narzo 30A phones → all have brand="realme", model="RMX3171".
///   Without Android ID, all those phones would get the SAME hash → collision!
///   Android ID is randomly generated per device at factory → always unique.
///
/// FALLBACK CHAIN:
///   Level 1 — Android ID available + hardware fields → SHA256 (unique, stable)
///   Level 2 — Android ID missing → SecureStorage UUID (unique per device install)
///   Level 3 — SecureStorage fails → Last resort platform hash (WARN: not unique!)
class DeviceFingerprintService {
  static const _storageKey        = 'permanent_device_fingerprint';
  static const _persistentUuidKey = 'device_fallback_uuid';

  static const _secureStorage = FlutterSecureStorage(
    // Android: EncryptedSharedPreferences — cleared on app uninstall
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'PermanentDeviceStorage',
    ),
    // iOS: Keychain — PERSISTS even after app uninstall (iOS feature)
    // accessibility: first_unlock = readable after first device unlock after restart
    // groupId / accountName = null means app-private keychain (default, most secure)
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns a stable, unique fingerprint for this physical device.
  static Future<String> getStableFingerprint() async {
    ApiHandler.logger.i(
      '╔══════════════════════════════════════════════════╗\n'
      '║         DEVICE FINGERPRINT — START               ║\n'
      '╚══════════════════════════════════════════════════╝',
    );

    // Fast path: use cached value
    try {
      final cached = await _secureStorage.read(key: _storageKey);
      if (cached != null && cached.isNotEmpty) {
        ApiHandler.logger.i(
          '[FINGERPRINT] ✅ Cache hit\n'
          '[FINGERPRINT] 🔑 Cached ID : $cached',
        );
        return cached;
      }
      ApiHandler.logger.i('[FINGERPRINT] 📭 No cache — generating fingerprint');
    } catch (e) {
      ApiHandler.logger.w('[FINGERPRINT] ⚠️  Cache read failed: $e');
    }

    final fingerprint = await _buildFingerprint();

    try {
      await _secureStorage.write(key: _storageKey, value: fingerprint);
      ApiHandler.logger.i('[FINGERPRINT] 💾 Saved to SecureStorage');
    } catch (e) {
      ApiHandler.logger.w('[FINGERPRINT] ⚠️  Cache write failed: $e');
    }

    ApiHandler.logger.i(
      '╔══════════════════════════════════════════════════╗\n'
      '║         DEVICE FINGERPRINT — DONE                ║\n'
      '║  🔑 Final ID : $fingerprint\n'
      '╚══════════════════════════════════════════════════╝',
    );
    return fingerprint;
  }

  /// Returns true if the app is running on an emulator / simulator.
  static Future<bool> isEmulator() async {
    ApiHandler.logger.i('[FINGERPRINT] 🔍 Checking: Is Emulator?');
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        final onEmulator = !info.isPhysicalDevice;
        ApiHandler.logger.i(
          '[FINGERPRINT] 📱 isPhysicalDevice : ${info.isPhysicalDevice}\n'
          '[FINGERPRINT] 📱 Model            : ${info.model}\n'
          '[FINGERPRINT] 📱 Result           : ${onEmulator ? "⚠️  EMULATOR DETECTED" : "✅ Real Device"}',
        );
        return onEmulator;
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        final onSimulator = !info.isPhysicalDevice;
        ApiHandler.logger.i(
          '[FINGERPRINT] 📱 isPhysicalDevice : ${info.isPhysicalDevice}\n'
          '[FINGERPRINT] 📱 Model            : ${info.model}\n'
          '[FINGERPRINT] 📱 Result           : ${onSimulator ? "⚠️  SIMULATOR DETECTED" : "✅ Real Device"}',
        );
        return onSimulator;
      }
    } catch (e) {
      ApiHandler.logger.e('[FINGERPRINT] ❌ Emulator check error: $e');
    }
    return false;
  }

  /// Returns true if the device is rooted (Android) or jailbroken (iOS).
  static Future<bool> isRootedOrJailbroken() async {
    ApiHandler.logger.i('[FINGERPRINT] 🔍 Checking: Is Rooted / Jailbroken?');
    try {
      if (Platform.isAndroid) return await _isAndroidRooted();
      if (Platform.isIOS)     return await _isIOSJailbroken();
    } catch (e) {
      ApiHandler.logger.e('[FINGERPRINT] ❌ Root check error: $e');
    }
    ApiHandler.logger.i('[FINGERPRINT] ✅ Root check passed — device clean');
    return false;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Fingerprint Build — Critical Logic
  // ─────────────────────────────────────────────────────────────────────────

  static Future<String> _buildFingerprint() async {
    ApiHandler.logger.i('[FINGERPRINT] 📡 Reading hardware info...');

    if (Platform.isAndroid) {
      return await _buildAndroidFingerprint();
    } else if (Platform.isIOS) {
      return await _buildIosFingerprint();
    }

    return await _fallbackUuid('Unsupported platform');
  }

  static Future<String> _buildAndroidFingerprint() async {
    try {
      final info = await DeviceInfoPlugin().androidInfo;

      // ── Log all raw values ────────────────────────────────────────────
      ApiHandler.logger.i(
        '[FINGERPRINT] ┌─── Android Hardware Info ────────────────────\n'
        '[FINGERPRINT] │  Android ID   : ${info.id}\n'
        '[FINGERPRINT] │  Brand        : ${info.brand}\n'
        '[FINGERPRINT] │  Model        : ${info.model}\n'
        '[FINGERPRINT] │  Manufacturer : ${info.manufacturer}\n'
        '[FINGERPRINT] │  Board        : ${info.board}\n'
        '[FINGERPRINT] │  Hardware     : ${info.hardware}\n'
        '[FINGERPRINT] │  Device       : ${info.device}\n'
        '[FINGERPRINT] │  Product      : ${info.product}\n'
        '[FINGERPRINT] │  Display      : ${info.display}\n'
        '[FINGERPRINT] │  SDK Int      : ${info.version.sdkInt}\n'
        '[FINGERPRINT] │  isPhysical   : ${info.isPhysicalDevice}\n'
        '[FINGERPRINT] └─────────────────────────────────────────────',
      );

      // ── CRITICAL CHECK: Android ID ────────────────────────────────────
      // Android ID is the ONLY field that makes same-model phones unique.
      // Brand/Model/Board are identical across all phones of the same model.
      // Example: 1000 Realme Narzo 30A → brand="realme", model="RMX3171" → ALL SAME.
      // Android ID → randomly generated per device at factory → ALWAYS unique.
      final androidId = info.id.trim();
      final androidIdValid = androidId.isNotEmpty && androidId != 'unknown';

      ApiHandler.logger.i(
        '[FINGERPRINT] 🔑 Android ID check:\n'
        '[FINGERPRINT]    Raw value   : "$androidId"\n'
        '[FINGERPRINT]    Is valid    : $androidIdValid\n'
        '[FINGERPRINT]    Why matters : Without it, same-model phones get SAME ID!',
      );

      if (!androidIdValid) {
        // Android ID missing → hardware-only hash = collision for same-model phones!
        // Use UUID fallback instead.
        ApiHandler.logger.w(
          '[FINGERPRINT] ⚠️  Android ID is null/unknown!\n'
          '[FINGERPRINT]    RISK: brand+model alone = SAME for all ${info.brand} ${info.model} phones.\n'
          '[FINGERPRINT]    ACTION: Skipping hardware-only hash → using UUID to avoid collision.',
        );
        return await _fallbackUuid('Android ID missing on ${info.brand} ${info.model}');
      }

      // ── Level 1: Android ID present → Safe to build hardware hash ────
      final parts = [
        androidId,           // ← The unique differentiator
        info.brand,
        info.model,
        info.manufacturer,
        // Optional extras (add if non-empty and not "unknown")
        if (info.board.isNotEmpty   && info.board   != 'unknown') info.board,
        if (info.hardware.isNotEmpty && info.hardware != 'unknown') info.hardware,
      ];

      final raw         = parts.join('|');
      final fingerprint = _sha256(raw);

      ApiHandler.logger.i(
        '[FINGERPRINT] ✅ Level 1 — Full Android fingerprint\n'
        '[FINGERPRINT]    Parts used  : $parts\n'
        '[FINGERPRINT]    Raw string  : $raw\n'
        '[FINGERPRINT]    SHA256 ID   : $fingerprint',
      );
      return fingerprint;

    } catch (e) {
      ApiHandler.logger.e('[FINGERPRINT] ❌ Android hardware read failed: $e');
      return await _fallbackUuid('Android hardware read exception');
    }
  }

  static Future<String> _buildIosFingerprint() async {
    try {
      final info = await DeviceInfoPlugin().iosInfo;

      ApiHandler.logger.i(
        '[FINGERPRINT] ┌─── iOS Hardware Info ────────────────────────\n'
        '[FINGERPRINT] │  IDFV         : ${info.identifierForVendor}\n'
        '[FINGERPRINT] │  Model        : ${info.model}\n'
        '[FINGERPRINT] │  LocalModel   : ${info.localizedModel}\n'
        '[FINGERPRINT] │  SystemName   : ${info.systemName}\n'
        '[FINGERPRINT] │  SystemVer    : ${info.systemVersion}\n'
        '[FINGERPRINT] │  isPhysical   : ${info.isPhysicalDevice}\n'
        '[FINGERPRINT] └─────────────────────────────────────────────',
      );

      // IDFV = unique per device per vendor — the iOS equivalent of Android ID
      final idfv = info.identifierForVendor ?? '';
      final idfvValid = idfv.isNotEmpty && idfv != 'unknown';

      ApiHandler.logger.i(
        '[FINGERPRINT] 🔑 IDFV check:\n'
        '[FINGERPRINT]    Raw value : "$idfv"\n'
        '[FINGERPRINT]    Is valid  : $idfvValid',
      );

      if (!idfvValid) {
        ApiHandler.logger.w(
          '[FINGERPRINT] ⚠️  IDFV null — same risk as Android ID missing.\n'
          '[FINGERPRINT]    ACTION: Using UUID fallback.',
        );
        return await _fallbackUuid('IDFV missing on iOS ${info.model}');
      }

      final parts       = [idfv, info.model, info.localizedModel, info.systemName];
      final raw         = parts.join('|');
      final fingerprint = _sha256(raw);

      ApiHandler.logger.i(
        '[FINGERPRINT] ✅ Level 1 — Full iOS fingerprint\n'
        '[FINGERPRINT]    Parts used  : $parts\n'
        '[FINGERPRINT]    SHA256 ID   : $fingerprint',
      );
      return fingerprint;

    } catch (e) {
      ApiHandler.logger.e('[FINGERPRINT] ❌ iOS hardware read failed: $e');
      return await _fallbackUuid('iOS hardware read exception');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Fallback UUID — used when Android ID / IDFV is unavailable
  // ─────────────────────────────────────────────────────────────────────────

  /// Generates or retrieves a persistent UUID from SecureStorage.
  ///
  /// This is used when the unique device identifier (Android ID / IDFV) is
  /// unavailable. It is unique per device but changes if app data is cleared.
  static Future<String> _fallbackUuid(String reason) async {
    ApiHandler.logger.w(
      '[FINGERPRINT] ⚠️  Fallback UUID triggered\n'
      '[FINGERPRINT]    Reason : $reason\n'
      '[FINGERPRINT]    Action : Reading persistent UUID from SecureStorage',
    );

    try {
      final existing = await _secureStorage.read(key: _persistentUuidKey);
      if (existing != null && existing.isNotEmpty) {
        ApiHandler.logger.i(
          '[FINGERPRINT] 📦 Existing UUID found (stable across reinstalls)\n'
          '[FINGERPRINT]    UUID   : $existing\n'
          '[FINGERPRINT]    ⚠️  Note: Changes if user clears app data',
        );
        return existing;
      }

      // Generate new UUID seeded by time (unique per generation)
      final seed    = '${Platform.operatingSystem}_${DateTime.now().microsecondsSinceEpoch}_${reason.hashCode}';
      final newUuid = _sha256(seed);
      await _secureStorage.write(key: _persistentUuidKey, value: newUuid);

      ApiHandler.logger.i(
        '[FINGERPRINT] 🆕 New UUID generated and saved\n'
        '[FINGERPRINT]    UUID   : $newUuid\n'
        '[FINGERPRINT]    ⚠️  Note: Stable until app data is cleared',
      );
      return newUuid;

    } catch (e) {
      // ── Level 3: SecureStorage also failed — absolute last resort ────
      final lastResort = _sha256(
        '${Platform.operatingSystem}_${Platform.numberOfProcessors}_${reason}_lastresort',
      );
      ApiHandler.logger.e(
        '[FINGERPRINT] ❌ LAST RESORT — SecureStorage also failed!\n'
        '[FINGERPRINT]    Error   : $e\n'
        '[FINGERPRINT]    ⚠️  WARNING: ID may NOT be unique across same-model devices!\n'
        '[FINGERPRINT]    ID      : $lastResort',
      );
      return lastResort;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Root / Jailbreak Detection
  // ─────────────────────────────────────────────────────────────────────────

  static Future<bool> _isAndroidRooted() async {
    // 1. Build tags
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      ApiHandler.logger.i('[FINGERPRINT] 🏷️  Build tags : ${info.tags}');
      if (info.tags.contains('test-keys')) {
        ApiHandler.logger.w('[FINGERPRINT] ⚠️  Root — build tag "test-keys"');
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
        ApiHandler.logger.w('[FINGERPRINT] ⚠️  Root — su at: $path');
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
        ApiHandler.logger.w('[FINGERPRINT] ⚠️  Root — app at: $path');
        return true;
      }
    }

    ApiHandler.logger.i('[FINGERPRINT] ✅ No root found');
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
        ApiHandler.logger.w('[FINGERPRINT] ⚠️  Jailbreak — path exists: $path');
        return true;
      }
    }
    ApiHandler.logger.i('[FINGERPRINT] ✅ No jailbreak found');
    return false;
  }

  static String _sha256(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}
