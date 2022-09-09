import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_yukki/components/common/custom_tooltip.dart';
import 'package:project_yukki/config/ui_config.dart';
import 'package:project_yukki/providers/audio_player_provider.dart';

class SectionHeaderButton extends ConsumerStatefulWidget {
  const SectionHeaderButton({
    this.icon = CupertinoIcons.xmark,
    this.audioPath = 'move.mp3',
    this.tooltip,
    this.isPlaySoundAfterPong = false,
    this.callback,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String? audioPath;
  final String? tooltip;
  final bool isPlaySoundAfterPong;
  final Function(VoidCallback? pong)? callback;

  @override
  ConsumerState<SectionHeaderButton> createState() => _CustomSectionHeaderButtonState();
}

class _CustomSectionHeaderButtonState extends ConsumerState<SectionHeaderButton> {
  @override
  Widget build(BuildContext context) => CustomTooltip(
        Container(
          decoration: BoxDecoration(color: darkColor, border: Border.all(color: primaryLightColor)),
          child: CupertinoButton(
            minSize: 0,
            padding: EdgeInsets.zero,
            child: SizedBox(
              width: 16,
              height: 16,
              child: Icon(widget.icon, size: 12, color: primaryColor),
            ),
            onPressed: () {
              if (widget.audioPath != null && !widget.isPlaySoundAfterPong) {
                _audioProvider.setSE(widget.audioPath!);
              }
              widget.callback?.call(
                () {
                  if (widget.audioPath != null) {
                    _audioProvider.setSE(widget.audioPath!);
                  }
                },
              );
            },
          ),
        ),
        tooltip: widget.tooltip,
      );

  AudioPlayerProvider get _audioProvider => ref.read(audioPlayerProvider.notifier);
}
