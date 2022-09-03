import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mana_studio/components/common/custom_button.dart';
import 'package:mana_studio/config/ui_config.dart';

class CustomAutocomplete extends StatefulWidget {
  const CustomAutocomplete(
    this.words,
    this.onSubmitted, {
    this.placeholder,
    this.searchIcon = CupertinoIcons.add,
    this.searchLabel = 'Search',
    Key? key,
  }) : super(key: key);

  final List<String> words;
  final Function(String text) onSubmitted;
  final String? placeholder;
  final IconData searchIcon;
  final String searchLabel;

  @override
  State<CustomAutocomplete> createState() => _CustomAutocompleteState();
}

class _CustomAutocompleteState extends State<CustomAutocomplete> {
  final focusNode = FocusNode();
  final controller = TextEditingController();

  static const upKey = 'Arrow Up';
  static const downKey = 'Arrow Down';

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 260,
        height: 25,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 24,
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: _onKey,
                child: CupertinoTypeAheadFormField(
                  textFieldConfiguration: CupertinoTextFieldConfiguration(
                    focusNode: focusNode,
                    controller: controller,
                    decoration: const BoxDecoration(color: darkColor),
                    placeholder: widget.placeholder,
                    autofocus: true,
                    onSubmitted: _onSubmitted,
                  ),
                  suggestionsCallback: _onSuggestions,
                  suggestionsBoxDecoration: CupertinoSuggestionsBoxDecoration(
                    border: Border.all(color: primaryColor),
                  ),
                  itemBuilder: (context, text) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      color: controller.text == text ? primaryColor : darkColor,
                    ),
                    child: Text(
                      '$text',
                      style: controller.text == text ? darkTextBoldStyle : primaryTextStyle,
                    ),
                  ),
                  noItemsFoundBuilder: (_) => Container(),
                  suggestionsBoxVerticalOffset: 10,
                  debounceDuration: Duration.zero,
                  animationDuration: Duration.zero,
                  getImmediateSuggestions: true,
                  hideOnLoading: true,
                  keepSuggestionsOnLoading: true,
                  onSuggestionSelected: _onSubmitted,
                ),
              ),
            ),
            SizedBox(
              height: 25,
              child: CustomButton(
                widget.searchLabel,
                icon: widget.searchIcon,
                onSubmitted: _onSubmitted,
              ),
            ),
          ],
        ),
      );

  void _onKey(event) {
    final keyEvent = event.runtimeType;
    final key = event.data.logicalKey.keyLabel;
    if (!(keyEvent == RawKeyDownEvent && (key == upKey || key == downKey))) {
      return;
    }
    final text = controller.text;
    final matches = _onSuggestions(text);
    if (matches.isEmpty) {
      return;
    }
    if (key == upKey) {
      _setText(matches.last);
    } else if (key == downKey) {
      if (!matches.contains(text)) {
        _setText(matches.first);
        return;
      }
      final findIndex = matches.indexWhere((e) => e == text);
      final nextIndex = findIndex + 1;
      if (findIndex < 0 || nextIndex >= matches.length) {
        return;
      }
      _setText(matches[nextIndex]);
    }
  }

  void _setText(text) {
    controller.text = text;
    Future.delayed(
      Duration.zero,
      () => controller.selection = TextSelection.fromPosition(
        TextPosition(offset: text.length),
      ),
    );
  }

  void _onSubmitted([String? text]) {
    text ??= controller.text;
    if (text == '') {
      return;
    }
    controller.clear();
    final matches = _onSuggestions(text);
    if (matches.isNotEmpty && !matches.contains(text)) {
      text = matches.first;
    }
    widget.onSubmitted.call(text);
    Future.delayed(
      Duration.zero,
      () => FocusScope.of(context).requestFocus(focusNode),
    );
  }

  List<String> _onSuggestions(text) {
    if (widget.words.isEmpty || text.isEmpty) {
      return [];
    }
    final matches = <String>[];
    matches.addAll(widget.words);
    matches.retainWhere((s) => s.toLowerCase().contains(text.toLowerCase()));
    return matches;
  }
}
