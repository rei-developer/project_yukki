import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mana_studio/config/ui_config.dart';

class CustomAutocomplete extends StatefulWidget {
  const CustomAutocomplete(this.words, this.onSubmitted, {Key? key})
      : super(key: key);

  final List<String> words;
  final Function(String text) onSubmitted;

  @override
  State<CustomAutocomplete> createState() => _CustomAutocompleteState();
}

class _CustomAutocompleteState extends State<CustomAutocomplete> {
  FocusNode? focusNode;
  final typeAheadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 24,
        child: CupertinoTypeAheadFormField(
          textFieldConfiguration: CupertinoTextFieldConfiguration(
            focusNode: focusNode,
            controller: typeAheadController,
            decoration: const BoxDecoration(color: darkColor),
            placeholder: '검색어를 입력하세요...',
            autofocus: true,
            onSubmitted: _onSubmitted,
          ),
          suggestionsCallback: _onSuggestions,
          suggestionsBoxDecoration: CupertinoSuggestionsBoxDecoration(
            border: Border.all(color: primaryColor),
          ),
          itemBuilder: (context, String suggestion) => Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            decoration: const BoxDecoration(color: darkColor),
            child: Text(suggestion),
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
      );

  void _onSubmitted(String text) {
    typeAheadController.clear();
    widget.onSubmitted.call(text);
    Future.delayed(
      Duration.zero,
      () => FocusScope.of(context).requestFocus(focusNode),
    );
  }

  List<String> _onSuggestions(String query) {
    if (widget.words.isEmpty || query.isEmpty) {
      return [];
    }
    List<String> matches = [];
    matches.addAll(widget.words);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
