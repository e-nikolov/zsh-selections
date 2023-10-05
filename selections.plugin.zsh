export KEY_CMD_BACKSPACE=$'^[b' # arbitrary; added via kitty config (send_text)
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

export KEY_CTRL_SHIFT_C=$'^[]C'  # custom via konsole.keytab
export KEY_CTRL_SHIFT_X=$'^[]X'  # custom via konsole.keytab
export KEY_CTRL_SHIFT_V=$'^[]V'  # custom via konsole.keytab
export KEY_CTRL_SHIFT_Z=$'^[]Z'  # custom via konsole.keytab

export KEY_CTRL_X=$'^X'
export KEY_CTRL_V=$'^V'
export KEY_CTRL_Y=$'^Y'
export KEY_CTRL_BACKSPACE=$'^H'
export KEY_CTRL_Z=$'^Z'
export KEY_CTRL_SHIFT_LEFT=$'^[[1;6D'
export KEY_CTRL_SHIFT_RIGHT=$'^[[1;6C'
export KEY_CTRL_LEFT=$'^[[1;5D'
export KEY_CTRL_RIGHT=$'^[[1;5C'

export ACTION_UNDO=$KEY_CTRL_Z
export ACTION_REDO=$KEY_CTRL_SHIFT_Z

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
export COPY_COMMAND="${COPY_COMMAND:-xclip -sel clip}"

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

zle -N widget::copy-selection
function widget::copy-selection {
    if ((REGION_ACTIVE)); then
        zle -w copy-region-as-kill
        printf "%s" $CUTBUFFER | $COPY_COMMAND
    fi
}

zle -N widget::cut-selection
function widget::cut-selection() {
    if ((REGION_ACTIVE)); then
        zle -w kill-region
        printf "%s" $CUTBUFFER | $COPY_COMMAND
    fi
}

zle -N widget::select-all
function widget::select-all() {
    REGION_ACTIVE=1
    MARK=0
    CURSOR=${#BUFFER}
    zle -w zle-line-init
}

function widget::util-select() {
    ((REGION_ACTIVE)) || zle -w set-mark-command
    local widget_name=$1
    shift
    zle -w $widget_name -- $@
    if [[ $MARK == $CURSOR ]]; then
        REGION_ACTIVE=0
    fi
}

function widget::util-unselect() {
    local widget_name=$1
    shift
    local region_was_active=$REGION_ACTIVE
    REGION_ACTIVE=0

    _unselect() {
        if [[ $region_was_active -gt 0 ]]; then
            if [[ $widget_name == forward-char ]]; then
                CURSOR=$(($CURSOR > $MARK ? $CURSOR : $MARK))
                return
            elif [[ $widget_name == backward-char ]]; then
                CURSOR=$(($CURSOR < $MARK ? $CURSOR : $MARK))
                return
            fi
        fi

        zle -w $widget_name -- $@
    }

    _unselect $@

    zle -w zle-line-init
}

function widget::util-delselect() {
    if ((REGION_ACTIVE)); then
        zle -w kill-region
    else
        local widget_name=$1
        shift
        zle -w $widget_name -- $@
    fi
}

function widget::self-insert() {
    ((REGION_ACTIVE)) && zle -w kill-region
    LBUFFER+=${KEYS[-1]}

    zle -w zle-line-init
}
zle -N self-insert widget::self-insert

typeset -g keyBindings
keyBindings=(
    'up|'$ACTION_UNSELECT_UP'|unselect|up-line-or-history'
    'down|'$ACTION_UNSELECT_DOWN'|unselect|down-line-or-history'
    'up|'$ACTION_SELECT_UP'|select|up-line-or-history'
    'down|'$ACTION_SELECT_DOWN'|select|down-line-or-history'
    'forward-char|'$ACTION_SELECT_FORWARD_CHAR'|select|forward-char'
    'backward-char|'$ACTION_SELECT_BACKWARD_CHAR'|select|backward-char'
    'forward-char|'$ACTION_UNSELECT_FORWARD_CHAR'|unselect|forward-char'
    'backward-char|'$ACTION_UNSELECT_BACKWARD_CHAR'|unselect|backward-char'
    'forward-word|'"$ACTION_SELECT_FORWARD_WORD"'|select|emacs-forward-word'
    'backward-word|'"$ACTION_SELECT_BACKWARD_WORD"'|select|emacs-backward-word'
    'forward-word|'"$ACTION_UNSELECT_FORWARD_WORD"'|unselect|emacs-forward-word'
    'backward-word|'"$ACTION_UNSELECT_BACKWARD_WORD"'|unselect|emacs-backward-word'
    'beginning-of-line|'$ACTION_SELECT_BEGINNING_OF_LINE'|select|beginning-of-line'
    'end-of-line|'$ACTION_SELECT_END_OF_LINE'|select|end-of-line'
    'beginning-of-line|'$ACTION_UNSELECT_BEGINNING_OF_LINE'|unselect|beginning-of-line'
    'end-of-line|'$ACTION_UNSELECT_END_OF_LINE'|unselect|end-of-line'
    'delete-char|'$ACTION_FORWARD_DELETE_CHAR'|delselect|delete-char'
    'backward-delete-char|'$ACTION_BACKWARD_DELETE_CHAR'|delselect|backward-delete-char'
    'kill-word|'$ACTION_FORWARD_KILL_WORD'|delselect|kill-word'
    'backward-kill-word|'$ACTION_BACKWARD_KILL_WORD'|delselect|backward-kill-word'
    'backward-kill-line|'$ACTION_BACKWARD_KILL_LINE'|delselect|backward-kill-line'
)

for i in "${keyBindings[@]}"; do
    IFS='|' read -r action seq mode widget <<<"$i"
    eval "function widget::action-$mode-$action() {
        widget::util-$mode $widget \$@
    }"
    zle -N "widget::action-$mode-$action"
    bindkey "$seq" "widget::action-$mode-$action"
done

bindkey $ACTION_UNDO undo
bindkey $ACTION_REDO redo
bindkey $ACTION_COPY_SELECTION widget::copy-selection
bindkey $ACTION_CUT_SELECTION widget::cut-selection
bindkey $ACTION_CUT_SELECTION2 widget::cut-selection
bindkey $ACTION_SELECT_ALL widget::select-all

function _zsh_autosuggest_widget_accept() {
    local -i retval
    _zsh_autosuggest_highlight_reset
    _zsh_autosuggest_accept $@
    retval=$?
    _zsh_autosuggest_highlight_apply
    zle -R
    zle -w zle-line-init
    return $retval
}

export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(widget::action-unselect-forward-char widget::action-select-forward-char widget::action-select-forward-word widget::action-unselect-forward-word)
