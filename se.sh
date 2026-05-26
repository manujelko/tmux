#!/bin/bash

DIRS=(
    "$HOME/code"
)

SELECTED=$(
    {
        find "${DIRS[@]}" -maxdepth 1 -type d
        printf '%s\n' \
            "$HOME/.config/tmux" \
            "$HOME/.config/nvim"
    } | sed "s|^$HOME/||" | fzf
)

echo $SELECTED

[[ $SELECTED ]] && SELECTED="$HOME/$SELECTED"

[[ ! $SELECTED ]] && exit 0

SELECTED_NAME=$(basename "$SELECTED" | tr . _)

if ! tmux has-session -t "$SELECTED_NAME"; then
    tmux new-session -ds "$SELECTED_NAME" -c "$SELECTED"
    tmux select-window -t "$SELECTED_NAME:1"
fi

if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$SELECTED_NAME"
else
    tmux attach-session -t "$SELECTED_NAME"
fi

