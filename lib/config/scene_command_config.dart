import 'package:flutter/cupertino.dart';
import 'package:project_yukki/config/ui_config.dart';
import 'package:project_yukki/i18n/strings.g.dart';

// ------------------------------------------------------------
// type
const basicCommandType = 'BASIC';
// commands
const conditionalBranchCommands = 'CONDITIONAL_BRANCH';
const controlFlowCommands = 'CONTROL_FLOW';
// conditional branch
const ifCommand = 'IF';
const elseIfCommand = 'ELSE_IF';
const elseCommand = 'ELSE';
// control flow
const waitCommand = 'WAIT';
// ------------------------------------------------------------

// ------------------------------------------------------------
// type
const messageCommandType = 'MESSAGE';
// commands
const messageCommands = 'MESSAGE';
// message
const showMessageCommand = 'SHOW_MESSAGE';
const commentCommand = 'COMMENT';
// ------------------------------------------------------------

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

List<dynamic> commandItems = commands.entries
    .map(
      (e) => {
        "commands": ((e.value['commands'] as Map<String, dynamic>).entries.map((c) => c.value.map((i) => i)).toList())
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
        "commands":
            ((e.value['commands'] as Map<String, dynamic>).entries.map((c) => c.value.map((i) => i['type'])).toList())
                .expand((c) => c)
                .toList()
      },
    )
    .toList();

// function
Color getCommandColor(String type) {
  final findIndex = commandColors.indexWhere((e) => (e['commands'] as List<dynamic>).contains(type));
  if (findIndex < 0) {
    return primaryColor;
  }
  return commandColors[findIndex]['color'];
}

bool isPossibleHasChildren(String type) => [
      ifCommand,
      elseIfCommand,
      elseCommand,
    ].contains(type);
