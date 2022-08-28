// Types
import 'package:flutter/cupertino.dart';
import 'package:mana_studio/config/ui_config.dart';

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
          "data": "",
        },
      ],
    },
  },
};
