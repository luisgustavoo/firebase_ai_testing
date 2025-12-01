import 'package:firebase_ai_testing/ui/core/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// **Feature: api-integration, Property 27: Theme changes are reflected in UI**
/// **Validates: Requirements 11.2**
///
/// Property-based test for theme switching functionality.
/// Verifies that theme changes trigger notifyListeners and update theme mode.
void main() {
  group('ThemeProvider Property Tests', () {
    test('Property 27: Theme changes are reflected in UI', () {
      // **Feature: api-integration, Property 27: Theme changes are reflected in UI**
      // For any theme mode change, notifyListeners should be called
      // and the theme mode should be updated

      final themeProvider = ThemeProvider();
      var notificationCount = 0;

      // Listen to notifications
      themeProvider.addListener(() {
        notificationCount++;
      });

      // Test all theme mode transitions
      final transitions = [
        (ThemeMode.light, ThemeMode.dark),
        (ThemeMode.dark, ThemeMode.light),
        (ThemeMode.light, ThemeMode.system),
        (ThemeMode.system, ThemeMode.dark),
        (ThemeMode.dark, ThemeMode.system),
        (ThemeMode.system, ThemeMode.light),
      ];

      for (final (from, to) in transitions) {
        // Reset to initial state
        themeProvider.setThemeMode(from);
        notificationCount = 0;

        // Change theme
        themeProvider.setThemeMode(to);

        // Verify notification was sent
        expect(
          notificationCount,
          1,
          reason: 'Should notify listeners when changing from $from to $to',
        );

        // Verify theme mode was updated
        expect(
          themeProvider.themeMode,
          to,
          reason: 'Theme mode should be updated to $to',
        );
      }
    });

    test('Property 27: Toggle theme alternates between light and dark', () {
      // **Feature: api-integration, Property 27: Theme changes are reflected in UI**
      // For any initial theme mode (light or dark), toggle should switch to the other

      final themeProvider = ThemeProvider();
      var notificationCount = 0;

      themeProvider.addListener(() {
        notificationCount++;
      });

      // Test toggle from light to dark
      themeProvider.setLightTheme();
      notificationCount = 0;

      themeProvider.toggleTheme();

      expect(notificationCount, 1, reason: 'Should notify on toggle');
      expect(
        themeProvider.themeMode,
        ThemeMode.dark,
        reason: 'Should toggle to dark from light',
      );

      // Test toggle from dark to light
      notificationCount = 0;
      themeProvider.toggleTheme();

      expect(notificationCount, 1, reason: 'Should notify on toggle');
      expect(
        themeProvider.themeMode,
        ThemeMode.light,
        reason: 'Should toggle to light from dark',
      );
    });

    test('Property 27: Setting same theme mode does not notify', () {
      // **Feature: api-integration, Property 27: Theme changes are reflected in UI**
      // For any theme mode, setting it to the same value should not trigger notification

      final themeProvider = ThemeProvider();
      var notificationCount = 0;

      themeProvider.addListener(() {
        notificationCount++;
      });

      // Set to light theme
      themeProvider.setLightTheme();
      notificationCount = 0;

      // Set to light theme again (same value)
      themeProvider.setLightTheme();

      expect(
        notificationCount,
        0,
        reason: 'Should not notify when setting same theme mode',
      );
      expect(themeProvider.themeMode, ThemeMode.light);
    });

    test('Property 27: isDarkMode reflects current theme mode', () {
      // **Feature: api-integration, Property 27: Theme changes are reflected in UI**
      // For any theme mode, isDarkMode should correctly reflect whether dark mode is active

      final themeProvider = ThemeProvider();

      // Test light mode
      themeProvider.setLightTheme();
      expect(
        themeProvider.isDarkMode,
        false,
        reason: 'isDarkMode should be false in light mode',
      );

      // Test dark mode
      themeProvider.setDarkTheme();
      expect(
        themeProvider.isDarkMode,
        true,
        reason: 'isDarkMode should be true in dark mode',
      );

      // Test system mode
      themeProvider.setSystemTheme();
      expect(
        themeProvider.isDarkMode,
        false,
        reason: 'isDarkMode should be false in system mode',
      );
    });

    test('Property 27: Theme data is properly configured for Material 3', () {
      // **Feature: api-integration, Property 27: Theme changes are reflected in UI**
      // For any theme (light or dark), it should use Material 3 configuration

      final themeProvider = ThemeProvider();

      // Test light theme
      final lightTheme = themeProvider.lightTheme;
      expect(
        lightTheme.useMaterial3,
        true,
        reason: 'Light theme should use Material 3',
      );
      expect(
        lightTheme.colorScheme.brightness,
        Brightness.light,
        reason: 'Light theme should have light brightness',
      );

      // Test dark theme
      final darkTheme = themeProvider.darkTheme;
      expect(
        darkTheme.useMaterial3,
        true,
        reason: 'Dark theme should use Material 3',
      );
      expect(
        darkTheme.colorScheme.brightness,
        Brightness.dark,
        reason: 'Dark theme should have dark brightness',
      );
    });

    test(
      'Property 27: Multiple theme changes notify listeners correctly',
      () {
        // **Feature: api-integration, Property 27: Theme changes are reflected in UI**
        // For any sequence of theme changes, each change should notify listeners

        final themeProvider = ThemeProvider();
        final notifications = <ThemeMode>[];

        themeProvider.addListener(() {
          notifications.add(themeProvider.themeMode);
        });

        // Perform multiple theme changes
        themeProvider.setLightTheme();
        themeProvider.setDarkTheme();
        themeProvider.setSystemTheme();
        themeProvider.setLightTheme();

        // Verify all notifications were received
        expect(
          notifications,
          [
            ThemeMode.light,
            ThemeMode.dark,
            ThemeMode.system,
            ThemeMode.light,
          ],
          reason: 'Should receive notification for each theme change',
        );
      },
    );
  });
}
