// Types
import 'package:flutter/cupertino.dart';
import 'package:mana_studio/config/ui_config.dart';

const basicCommandType = 'basic';
const conditionCommandType = 'condition';

// Normal
const showMessageCommand = 'SHOW_MESSAGE';
const waitCommand = 'WAIT';
const commentCommand = 'COMMENT';

// Conditions
const ifCommand = 'IF';
const elseIfCommand = 'ELSE_IF';
const elseCommand = 'ELSE';

Map<String, dynamic> commands = {
  basicCommandType: {
    "color": primaryColor,
    "icon": CupertinoIcons.airplane,
    "commands": [
      {
        "type": showMessageCommand,
        "data": {"name": "", "description": ""},
      },
      {
        "type": waitCommand,
        "data": {"duration": "1000"},
      },
      {
        "type": commentCommand,
        "data": "",
      },
    ]
  },
  conditionCommandType: {
    "color": const Color(0xFF9FC93C),
    "icon": CupertinoIcons.calendar,
    "commands": [
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
  }
};
