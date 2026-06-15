#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
THEME_OPTION="@tmux-everforest"
DEFAULT_THEME="dark-medium"

get() {
	local option="$1"
	local default_value="$2"
	local option_value
	option_value=$(tmux show-option -gqv "$option")
	[ -z "$option_value" ] && echo "$default_value" || echo "$option_value"
}

set() {
	tmux set-option -gq "$1" "$2"
}

main() {
	local theme="${1:-}"
	[ -z "$theme" ] && theme=$(get "$THEME_OPTION" "$DEFAULT_THEME")

	tmux source-file "$CURRENT_DIR/tmux-everforest-${theme}.conf"

	local shared_widget ; shared_widget=$(get "@widgets"                "#(~/.local/bin/tmux-widget)")
	local time_format   ; time_format=$(get  "@everforest_time_format"  "%T")
	local date_format   ; date_format=$(get  "@everforest_date_format"  "%Y-%m-%d")
	local widgets       ; widgets=$(get      "@everforest_widgets"      "$shared_widget")
	local status_intv   ; status_intv=$(get  "@everforest_status_interval" "5")

	# Reset any window-style dimming left by other themes
	set "window-style" ""
	set "window-active-style" ""

	set "status-interval" "$status_intv"
	set "status-right" "#[fg=#{@everforest_bg2}]#[fg=#{@everforest_fg},bg=#{@everforest_bg2}] #[fg=#{@everforest_fg},bg=#{@everforest_bg2}]${date_format}  ${time_format} #[fg=#{@everforest_bg3},bg=#{@everforest_bg2}]#[fg=#{@everforest_fg},bg=#{@everforest_bg3}] ${widgets} #[fg=#{@everforest_aqua},bg=#{@everforest_bg3},bold]#[fg=#{@everforest_bg_dim},bg=#{@everforest_aqua},bold] #h "
}

main "$@"
