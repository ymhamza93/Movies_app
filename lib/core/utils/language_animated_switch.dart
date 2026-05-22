import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/feature/auth_logic/locale_cubit.dart';

class LanguageAnimatedSwitch extends StatefulWidget {
  const LanguageAnimatedSwitch({super.key});

  @override
  State<LanguageAnimatedSwitch> createState() => _LanguageAnimatedSwitchState();
}

class _LanguageAnimatedSwitchState extends State<LanguageAnimatedSwitch> {
  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    Locale currentLocale = context.read<LocaleCubit>().state;
    isEnglish = currentLocale.languageCode == 'en';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<bool>.rolling(
      current: isEnglish,
      values: const [false, true],
      loading: false,

      spacing: 25.0,
      height: 38,
      indicatorSize: const Size.square(28.0),

      style: const ToggleStyle(
        borderColor: ColorManager.yellow,
        backgroundColor: ColorManager.black,
      ),

      styleBuilder: (value) => const ToggleStyle(
        indicatorColor: Colors.transparent,
        indicatorBorder: Border.fromBorderSide(
          BorderSide(color: ColorManager.yellow, width: 2.0),
        ),
      ),

      iconBuilder: (value, foreground) {
        return Text(
          value ? "🇺🇸" : "🇪🇬",
          style: TextStyle(
            fontSize: 20,

            color: foreground ? Colors.white : Colors.white.withOpacity(0.4),
          ),
        );
      },

      onChanged: (b) {
        setState(() {
          isEnglish = b;
        });

        if (isEnglish) {
          context.read<LocaleCubit>().changeLanguage('en');
        } else {
          context.read<LocaleCubit>().changeLanguage('ar');
        }
      },
    );
  }
}
