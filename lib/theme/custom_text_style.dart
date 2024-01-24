import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyMediumBlack900 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 14.fSize,
      );
  static get bodyMediumGray600 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray600,
        fontSize: 14.fSize,
      );
  static get bodyMediumGray700 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray700,
        fontSize: 14.fSize,
      );
  static get bodyMediumGray800 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray800,
        fontSize: 14.fSize,
      );
  static get bodyMediumRobotoBlack900 =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: appTheme.black900,
      );
  static get bodyMediumRobotoGray800 =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: appTheme.gray800,
      );
  static get bodyMediumff5a7756 => theme.textTheme.bodyMedium!.copyWith(
        color: Color(0XFF5A7756),
      );
  static get bodySmallOutfit => theme.textTheme.bodySmall!.outfit.copyWith(
        fontSize: 12.fSize,
      );
  static get bodySmallOutfitGray60002 =>
      theme.textTheme.bodySmall!.outfit.copyWith(
        color: appTheme.gray60002,
        fontSize: 12.fSize,
        fontWeight: FontWeight.w300,
      );
  static get bodySmallRobotoGray800 =>
      theme.textTheme.bodySmall!.roboto.copyWith(
        color: appTheme.gray800,
        fontSize: 12.fSize,
      );
  // Display text style
  static get displayMediumGray700 => theme.textTheme.displayMedium!.copyWith(
        color: appTheme.gray700,
      );
  // Label text style
  static get labelLargeInterBluegray500 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.blueGray500,
      );
  static get labelLargeInterBluegray500Medium =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.blueGray500,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeInterOnError =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: theme.colorScheme.onError.withOpacity(1),
        fontWeight: FontWeight.w500,
      );
  static get labelLargeInterSecondaryContainer =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: theme.colorScheme.secondaryContainer,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeOutfitGray800 =>
      theme.textTheme.labelLarge!.outfit.copyWith(
        color: appTheme.gray800,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeOutfitOnError =>
      theme.textTheme.labelLarge!.outfit.copyWith(
        color: theme.colorScheme.onError.withOpacity(1),
        fontWeight: FontWeight.w500,
      );
  // Title text style
  static get titleMediumOutfit => theme.textTheme.titleMedium!.outfit.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleMediumOutfitOnError =>
      theme.textTheme.titleMedium!.outfit.copyWith(
        color: theme.colorScheme.onError.withOpacity(1),
      );
  static get titleMediumPoppins =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBluegray400 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray400,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallOutfitGray800 =>
      theme.textTheme.titleSmall!.outfit.copyWith(
        color: appTheme.gray800,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallOutfitOnError =>
      theme.textTheme.titleSmall!.outfit.copyWith(
        color: theme.colorScheme.onError.withOpacity(1),
      );
  static get titleSmallOutfitOnErrorSemiBold =>
      theme.textTheme.titleSmall!.outfit.copyWith(
        color: theme.colorScheme.onError.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static get titleSmallPoppinsOnError =>
      theme.textTheme.titleSmall!.poppins.copyWith(
        color: theme.colorScheme.onError.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static get titleSmallPoppinsOnErrorSemiBold =>
      theme.textTheme.titleSmall!.poppins.copyWith(
        color: theme.colorScheme.onError.withOpacity(1),
        fontSize: 15.fSize,
        fontWeight: FontWeight.w600,
      );
}

extension on TextStyle {
  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }

  TextStyle get outfit {
    return copyWith(
      fontFamily: 'Outfit',
    );
  }

  TextStyle get roboto {
    return copyWith(
      fontFamily: 'Roboto',
    );
  }

  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

}
