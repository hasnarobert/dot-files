ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[red]%}➦"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} ✈"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ✭"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%} ✱"

function prompt_char {
	if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo "%{$FG[245]%}>%{$reset_color%}% %{$FG[250]%}>%{$reset_color%}% %{$FG[255]%}>%{$reset_color%}% "; fi
}


# get the name of the branch we are on
function vim_bg_info() {
  if [[ "$(command echo $VIM)" != "" ]]; then
    echo " ⚡"
  fi
}

PROMPT='
%{$fg[green]%}[%*]%{$reset_color%} %{$fg[yellow]%}$(pwd)%{$reset_color%}$(git_prompt_info)%{$reset_color%}$(git_prompt_ahead)%{$reset_color%}$(vim_bg_info)
%_$(prompt_char) '

# Exit code on right, when different than 0
RPROMPT='%(?, ,%{$fg[red]%}Exit code: $?%{$reset_color%}'

