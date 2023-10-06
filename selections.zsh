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
