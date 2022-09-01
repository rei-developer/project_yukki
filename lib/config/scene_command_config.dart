// Types
import 'package:flutter/cupertino.dart';
import 'package:mana_studio/config/ui_config.dart';
import 'package:mana_studio/i18n/strings.g.dart';

// ------------------------------------------------------------
// Type
const basicCommandType = 'BASIC';
// Commands
const conditionalBranchCommands = 'CONDITIONAL_BRANCH';
const controlFlowCommands = 'CONTROL_FLOW';
// Conditional Branch
const ifCommand = 'IF';
const elseIfCommand = 'ELSE_IF';
const elseCommand = 'ELSE';
// Control Flow
const waitCommand = 'WAIT';
// ------------------------------------------------------------

// ------------------------------------------------------------
// Type
const messageCommandType = 'MESSAGE';
// Commands
const messageCommands = 'MESSAGE';
// Message
const showMessageCommand = 'SHOW_MESSAGE';
const commentCommand = 'COMMENT';
// ------------------------------------------------------------

bool isPossibleHasChildren(String type) => [
      ifCommand,
      elseIfCommand,
      elseCommand,
    ].contains(type);

Color getCommandColor(String type) {
  final findIndex = commandColors.indexWhere(
    (e) => (e['commands'] as List<dynamic>).contains(type),
  );
  if (findIndex < 0) {
    return primaryColor;
  }
  return commandColors[findIndex]['color'];
}

List<dynamic> commandItems = commands.entries
    .map(
      (e) => {
        "commands": ((e.value['commands'] as Map<String, dynamic>)
                .entries
                .map((c) => c.value.map((i) => i))
                .toList())
            .expand((c) => c)
            .toList()
      },
    )
    .expand((dynamic e) => e['commands'])
    .map(
  (e) {
    e['localized'] = t['scene.command.${e["type"]}.label'];
    return e;
  },
).toList();

List<Map<String, dynamic>> commandColors = commands.entries
    .map(
      (e) => {
        "color": e.value['color'],
        "commands": ((e.value['commands'] as Map<String, dynamic>)
                .entries
                .map((c) => c.value.map((i) => i['type']))
                .toList())
            .expand((c) => c)
            .toList()
      },
    )
    .toList();

Map<String, dynamic> commands = {
  basicCommandType: {
    "color": primaryColor,
    "icon": CupertinoIcons.cube,
    "activatedIcon": CupertinoIcons.cube_fill,
    "commands": {
      conditionalBranchCommands: [
        {
          "type": ifCommand,
          "data": {
            "type": "Number",
            "equation": "Equal to",
            "value": 0,
          },
          "children": [],
        },
        {
          "type": elseIfCommand,
          "data": {
            "type": "Number",
            "equation": "Equal to",
            "value": 0,
          },
          "children": [],
        },
        {
          "type": elseCommand,
          "children": [],
        },
      ],
      controlFlowCommands: [
        {
          "type": waitCommand,
          "data": {"duration": "1000"},
        },
      ],
    },
  },
  messageCommandType: {
    "color": const Color(0xFFB2CCFF),
    "icon": CupertinoIcons.chat_bubble,
    "activatedIcon": CupertinoIcons.chat_bubble_fill,
    "commands": {
      messageCommands: [
        {
          "type": showMessageCommand,
          "data": {"name": "", "description": ""},
        },
        {
          "type": commentCommand,
          "data": {"description": ""},
        },
      ],
    },
  },
};
