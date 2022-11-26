# hacky fix for slow Ctrl+X. There are a lot of multi-key combinations starting with Ctrl+X and by default zsh waits for a second before accepting the current command
# export KEYTIMEOUT=1

export KEY_CMD_BACKSPACE=$'^[b'   # arbitrary; added via kitty config (send_text)
export KEY_CMD_Z='^[[122;9u'
export KEY_SHIFT_CMD_Z=$'^[[122;10u'
export KEY_CTRL_R=$'^R'
export KEY_CMD_C=$'^[[99;9u'
export KEY_CMD_X=$'^[[120;9u'
export KEY_CMD_V=$'^[[118;9u'
export KEY_CMD_A=$'^[[97;9u'
export KEY_CTRL_L=$'^L'
export KEY_UP="${terminfo[kcuu1]:-$'^[[A'}"
export KEY_DOWN="${terminfo[kcud1]:-$'^[[B'}"
export KEY_LEFT="${terminfo[kcub1]:-$'^[[D'}"
export KEY_RIGHT="${terminfo[kcuf1]:-$'^[[C'}"
export KEY_SHIFT_UP="${terminfo[kri]:-$'^[[1;2A'}"
export KEY_SHIFT_DOWN="${terminfo[kind]:-$'^[[1;2B'}"
export KEY_SHIFT_RIGHT="${terminfo[kRIT]:-$'^[[1;2C'}"
export KEY_SHIFT_LEFT="${terminfo[kLFT]:-$'^[[1;2D'}"
export KEY_ALT_LEFT=$'^[[1;3D'
export KEY_ALT_RIGHT=$'^[[1;3C'
export KEY_SHIFT_ALT_LEFT=$'^[[1;4D'
export KEY_SHIFT_ALT_RIGHT=$'^[[1;4C'
export KEY_CMD_LEFT=$'^[[1;9D'
export KEY_CMD_RIGHT=$'^[[1;9C'
export KEY_SHIFT_CMD_LEFT=$'^[[1;10D'
export KEY_SHIFT_CMD_RIGHT=$'^[[1;10C'
export KEY_CTRL_A=$'^A'
export KEY_CTRL_E=$'^E'
export KEY_SHIFT_CTRL_A=$'^[[97;6u'
export KEY_SHIFT_CTRL_E=$'^[[101;6u'
export KEY_SHIFT_CTRL_LEFT=$'^[[1;6D'
export KEY_SHIFT_CTRL_RIGHT=$'^[[1;6C'
export KEY_CTRL_D=$'^D'
export KEY_DELETE=$'^[[3~'
export KEY_BACKSPACE=$'^?'
export KEY_CTRL_DELETE=$'^[[3;5~'
export KEY_END=$'\EOF'
export KEY_SHIFT_END=$'^[[1;2F'
export KEY_HOME=$'\EOH'
export KEY_SHIFT_HOME=$'^[[1;2H'

export KEY_CTRL_SHIFT_C=$'^]C'
export KEY_CTRL_SHIFT_X=$'^]X'
export KEY_CTRL_SHIFT_V=$'^]V'
export KEY_CTRL_SHIFT_Z=$'^]Z'

export KEY_CTRL_X=$'^X'
export KEY_CTRL_V=$'^V'
export KEY_CTRL_Y=$'^Y'
export KEY_CTRL_BACKSPACE=$'^H'
export KEY_CTRL_Z=$'^Z'
export KEY_CTRL_SHIFT_LEFT=$'^[[1;6D'
export KEY_CTRL_SHIFT_RIGHT=$'^[[1;6C'
export KEY_CTRL_LEFT=$'\E[1;5D'
export KEY_CTRL_RIGHT=$'\E[1;5C'

export ACTION_UNDO=$KEY_CTRL_Z
export ACTION_REDO=$KEY_CTRL_SHIFT_Z

export ACTION_SCROLL_AND_CLEAR_SCREEN=$KEY_CTRL_L

export ACTION_COPY_SELECTION=$KEY_CTRL_SHIFT_C
export ACTION_CUT_SELECTION=$KEY_CTRL_SHIFT_X
export ACTION_CUT_SELECTION2=$KEY_CTRL_X


export ACTION_FORWARD_DELETE_CHAR=$KEY_DELETE
export ACTION_BACKWARD_DELETE_CHAR=$KEY_BACKSPACE

export ACTION_FORWARD_KILL_WORD=$KEY_CTRL_DELETE
export ACTION_BACKWARD_KILL_WORD=$KEY_CTRL_BACKSPACE
export ACTION_BACKWARD_KILL_LINE=$KEY_CTRL_Y

export ACTION_SELECT_ALL=$KEY_CTRL_A

export ACTION_UNSELECT_UP=$KEY_UP
export ACTION_UNSELECT_DOWN=$KEY_DOWN
export ACTION_SELECT_UP=$KEY_SHIFT_UP
export ACTION_SELECT_DOWN=$KEY_SHIFT_DOWN

export ACTION_SELECT_FORWARD_WORD="$KEY_CTRL_SHIFT_RIGHT"
export ACTION_SELECT_BACKWARD_WORD="$KEY_CTRL_SHIFT_LEFT"
export ACTION_SELECT_FORWARD_CHAR="$KEY_SHIFT_RIGHT"
export ACTION_SELECT_BACKWARD_CHAR="$KEY_SHIFT_LEFT"

export ACTION_UNSELECT_FORWARD_WORD=$KEY_CTRL_RIGHT
export ACTION_UNSELECT_BACKWARD_WORD=$KEY_CTRL_LEFT
export ACTION_UNSELECT_FORWARD_CHAR=$KEY_RIGHT
export ACTION_UNSELECT_BACKWARD_CHAR=$KEY_LEFT

export ACTION_SELECT_END_OF_LINE=$KEY_SHIFT_END
export ACTION_SELECT_BEGINNING_OF_LINE=$KEY_SHIFT_HOME
export ACTION_UNSELECT_END_OF_LINE=$KEY_END
export ACTION_UNSELECT_BEGINNING_OF_LINE=$KEY_HOME
# export ACTION_PASTE=$KEY_CTRL_SHIFT_V
export COPY_COMMAND="${COPY_COMMAND:-xclip -sel clip}"

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# copy selected terminal text to clipboard
zle -N widget::copy-selection
function widget::copy-selection {
    if ((REGION_ACTIVE)); then
        zle copy-region-as-kill
        printf "%s" $CUTBUFFER | $COPY_COMMAND
    fi
}

# cut selected terminal text to clipboard
zle -N widget::cut-selection
function widget::cut-selection() {
    if ((REGION_ACTIVE)) then
        zle kill-region
        printf "%s" $CUTBUFFER | $COPY_COMMAND
    fi
}

# select entire prompt
zle -N widget::select-all
function widget::select-all() {
    local buflen=$(printf "$BUFFER" | wc -m | bc)
    CURSOR=$buflen   # if this is messing up try: CURSOR=9999999
    zle set-mark-command
    ((CURSOR = 0))
}

# scrolls the screen up, in effect clearing it
zle -N widget::scroll-and-clear-screen
function widget::scroll-and-clear-screen() {
    printf "\n%.0s" {1..$LINES}
    zle clear-screen
}

function widget::util-select() {
    ((REGION_ACTIVE)) || zle set-mark-command
    local widget_name=$1
    shift
    zle $widget_name -- $@
}

function widget::util-unselect() {
    REGION_ACTIVE=0
    local widget_name=$1
    shift
    zle $widget_name -- $@
}

function widget::util-delselect() {
    if ((REGION_ACTIVE)) then
        zle kill-region
    else
        local widget_name=$1
        shift
        zle $widget_name -- $@
    fi
}

# # paste clipboard contents
# zle -N widget::paste
# function widget::paste() {
#     xco
#     ((REGION_ACTIVE)) && zle kill-region
#     RBUFFER="$(xco)${RBUFFER}"
#     CURSOR=$(( CURSOR + $(echo -n "$()" | wc -m | bc) ))
# }

function widget::util-insertchar() {
    ((REGION_ACTIVE)) && zle kill-region
    RBUFFER="${1}${RBUFFER}"
    zle forward-char
}

#                       |  key sequence                   | command
# --------------------- | ------------------------------- | -------------



for action         seq               mode               widget (
    'a'            'a'               insertchar         'a'
    'b'            'b'               insertchar         'b'
    'c'            'c'               insertchar         'c'
    'd'            'd'               insertchar         'd'
    'e'            'e'               insertchar         'e'
    'f'            'f'               insertchar         'f'
    'g'            'g'               insertchar         'g'
    'h'            'h'               insertchar         'h'
    'i'            'i'               insertchar         'i'
    'j'            'j'               insertchar         'j'
    'k'            'k'               insertchar         'k'
    'l'            'l'               insertchar         'l'
    'm'            'm'               insertchar         'm'
    'n'            'n'               insertchar         'n'
    'o'            'o'               insertchar         'o'
    'p'            'p'               insertchar         'p'
    'q'            'q'               insertchar         'q'
    'r'            'r'               insertchar         'r'
    's'            's'               insertchar         's'
    't'            't'               insertchar         't'
    'u'            'u'               insertchar         'u'
    'v'            'v'               insertchar         'v'
    'w'            'w'               insertchar         'w'
    'x'            'x'               insertchar         'x'
    'y'            'y'               insertchar         'y'
    'z'            'z'               insertchar         'z'
    'A'            'A'               insertchar         'A'
    'B'            'B'               insertchar         'B'
    'C'            'C'               insertchar         'C'
    'D'            'D'               insertchar         'D'
    'E'            'E'               insertchar         'E'
    'F'            'F'               insertchar         'F'
    'G'            'G'               insertchar         'G'
    'H'            'H'               insertchar         'H'
    'I'            'I'               insertchar         'I'
    'J'            'J'               insertchar         'J'
    'K'            'K'               insertchar         'K'
    'L'            'L'               insertchar         'L'
    'M'            'M'               insertchar         'M'
    'N'            'N'               insertchar         'N'
    'O'            'O'               insertchar         'O'
    'P'            'P'               insertchar         'P'
    'Q'            'Q'               insertchar         'Q'
    'R'            'R'               insertchar         'R'
    'S'            'S'               insertchar         'S'
    'T'            'T'               insertchar         'T'
    'U'            'U'               insertchar         'U'
    'V'            'V'               insertchar         'V'
    'W'            'W'               insertchar         'W'
    'X'            'X'               insertchar         'X'
    'Y'            'Y'               insertchar         'Y'
    'Z'            'Z'               insertchar         'Z'
    '0'            '0'               insertchar         '0'
    '1'            '1'               insertchar         '1'
    '2'            '2'               insertchar         '2'
    '3'            '3'               insertchar         '3'
    '4'            '4'               insertchar         '4'
    '5'            '5'               insertchar         '5'
    '6'            '6'               insertchar         '6'
    '7'            '7'               insertchar         '7'
    '8'            '8'               insertchar         '8'
    '9'            '9'               insertchar         '9'

    'exclamation-mark'        '!'                insertchar  '!'
    'hash-sign'               '\#'               insertchar  '\#'
    'dollar-sign'             '$'                insertchar  '$'
    'percent-sign'            '%'                insertchar  '%'
    'ampersand-sign'          '\&'               insertchar  '\&'
    'star'                    '\*'               insertchar  '\*'
    'plus'                    '+'                insertchar  '+'
    'comma'                   ','                insertchar  ','
    'dot'                     '.'                insertchar  '.'
    'forwardslash'            '\\'               insertchar  '\\'
    'backslash'               '/'                insertchar  '/'
    'colon'                   ':'                insertchar  ':'
    'semi-colon'              '\;'               insertchar  '\;'
    'left-angle-bracket'      '\<'               insertchar  '\<'
    'right-angle-bracket'     '\>'               insertchar  '\>'
    'equal-sign'              '='                insertchar  '='
    'question-mark'           '\?'               insertchar  '\?'
    'left-square-bracket'     '['                insertchar  '['
    'right-square-bracket'    ']'                insertchar  ']'
    'hat-sign'                '^'                insertchar  '^'
    'underscore'              '_'                insertchar  '_'
    'left-brace'              '{'                insertchar  '{'
    'right-brace'             '\}'               insertchar  '\}'
    'left-parenthesis'        '\('               insertchar  '\('
    'right-parenthesis'       '\)'               insertchar  '\)'
    'pipe'                    '\|'               insertchar  '\|'
    'tilde'                   '\~'               insertchar  '\~'
    'at-sign'                 '@'                insertchar  '@'
    'dash'                    '\-'               insertchar  '\-'
    'double-quote'            '\"'               insertchar  '\"'
    'single-quote'            "\'"               insertchar  "\'"
    'backtick'                '\`'               insertchar  '\`'
    'whitespace'              '\ '               insertchar  '\ '


    'backward-char'      $ACTION_UNSELECT_BACKWARD_CHAR unselect    backward-char
    'forward-char'       $ACTION_UNSELECT_FORWARD_CHAR  unselect    forward-char

    'up'             $ACTION_UNSELECT_UP     unselect      up-line-or-history
    'down'           $ACTION_UNSELECT_DOWN   unselect      down-line-or-history
    'up'             $ACTION_SELECT_UP     select      up-line-or-history
    'down'           $ACTION_SELECT_DOWN   select      down-line-or-history
    'forward-char'   $ACTION_SELECT_FORWARD_CHAR      select      forward-char
    'backward-char'  $ACTION_SELECT_BACKWARD_CHAR       select      backward-char

    'forward-word'         "$ACTION_UNSELECT_FORWARD_WORD"    unselect    forward-word
    'backward-word'        "$ACTION_SELECT_BACKWARD_WORD"     select      backward-word
    'forward-word'         "$ACTION_SELECT_FORWARD_WORD"      select      forward-word
    'backward-word'        "$ACTION_UNSELECT_BACKWARD_WORD"   unselect    backward-word

    'end-of-line'          $ACTION_UNSELECT_END_OF_LINE         unselect    end-of-line
    'beginning-of-line'    $ACTION_UNSELECT_BEGINNING_OF_LINE   unselect    beginning-of-line
    'end-of-line'          $ACTION_SELECT_END_OF_LINE           select      end-of-line
    'beginning-of-line'    $ACTION_SELECT_BEGINNING_OF_LINE     select      beginning-of-line
    'delete-char'          $ACTION_FORWARD_DELETE_CHAR          delselect   delete-char
    'backward-delete-char' $ACTION_BACKWARD_DELETE_CHAR         delselect   backward-delete-char
    'backward-kill-word'   $ACTION_BACKWARD_KILL_WORD           delselect   backward-kill-word
) {
    eval "function widget::action-$mode-$action() {
        widget::util-$mode $widget \$@
    }"
    zle -N widget::action-$mode-$action
    bindkey $seq widget::action-$mode-$action
}

bindkey                   $ACTION_FORWARD_KILL_WORD         kill-word
# bindkey                   $ACTION_BACKWARD_KILL_WORD        backward-kill-word
bindkey                   $ACTION_BACKWARD_KILL_LINE        backward-kill-line
bindkey                   $ACTION_UNDO                      undo
bindkey                   $ACTION_REDO                      redo
bindkey                   $ACTION_COPY_SELECTION            widget::copy-selection
bindkey                   $ACTION_CUT_SELECTION             widget::cut-selection
bindkey                   $ACTION_CUT_SELECTION2            widget::cut-selection
bindkey                   $ACTION_SELECT_ALL                widget::select-all
bindkey                   $ACTION_SCROLL_AND_CLEAR_SCREEN   widget::scroll-and-clear-screen
# bindkey                   $ACTION_PASTE                     widget::paste

export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(widget::action-unselect-forward-char widget::action-select-forward-char widget::action-select-forward-word widget::action-unselect-forward-word)
