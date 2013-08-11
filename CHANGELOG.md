# Changelog

## v1.3

- **Fix launch SEGFAULT on OS X 10.8**
- **Create Application Support directory if not there**
- **Create safe filenames for message files**
- **Add Makefile for easy building for release**

## v1.2
- **Added scroll bars to the text fields, though not perfect**
- **Auto-Saves every 60 seconds so you never lose any work**
- **Can use both `Return` and `Enter` (`Opt-Return`) to add newlines, as opposed to _just_ `Enter`**
- **Allows user to change font of message and response text fields to accommodate needs**
- **Changed icon to something a little more exciting**
- Added support for UTF-8 (Unicode) messages
- Added a "Cancel" button to the popup that adds a new recipient
- Fixed issue when changing recipients where it doesn't repopulate the NSTextFields
- Fixed an issue where font is system default
- Now stores font size and name preferences on save so that a preference doesn't have to be changed every time if it's not the default
- Can now open website with `Cmd-/`

## v1.1
- **Added ability to manage message-response pairs from different people.**
- Bug fixes.
- Optimization and code for transfer.

## v1.0
- Initial iteration. Works with only one message-response pair.
