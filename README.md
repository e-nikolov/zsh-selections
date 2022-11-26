This zsh plugin adds hotkeys for selecting and editing the active line in zsh in a way similar to a text editor.

- Ctrl    + A                     - adds the entire line to the selection
- Shift   + Left Arrow            - adds one character to the left of the cursor to the selection
- Shift   + Right Arrow           - adds one character to the right of the cursor to the selection
- Shift   + Ctrl  + Left Arrow    - adds a word to the left of the cursor to the selection
- Shift   + Ctrl  + Right Arrow   - adds a word to the right of the cursor to the selection

- Ctrl    + X                     - cuts the current selection, removing it from the line and putting it in the clipboard.
                                  requires `xclip` or setting the `COPY_COMMAND` environment variable to an alternative command, e.g. `pbcopy` on MacOS or `clip.exe` on Windows with WSL
- Ctrl + Z                        - Undo
- Ctrl + Shift + Z                - Redo

- Typing a Backspace or Delete while there is an active selection will remove the selected text
- Typing a character while there is an active selection will replace the selected text with that character
