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

export KEY_CTRL_SHIFT_C=$'^[[C' # custom via konsole.keytab
export KEY_CTRL_SHIFT_X=$'^[[X' # custom via konsole.keytab
export KEY_CTRL_SHIFT_V=$'^[[V' # custom via konsole.keytab
export KEY_CTRL_SHIFT_Z=$'^[[Z' # custom via konsole.keytab

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
