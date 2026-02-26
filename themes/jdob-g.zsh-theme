# Load colors and create aliases
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst

eval PR_BOLD="%{$terminfo[bold]%}"
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$fg[${(L)color}]%}'
  eval PR_LIGHT_$color='%{$PR_BOLD%}%{$fg[${(L)color}]%}'
done
eval PR_NO_COLOR="%{$terminfo[sgr0]%}"

# Custom Colors
# List color values with either of these:
#  spectrum_ls
#  for code in {000..255}; do print -P -- "$code: %F{$code}Color%f"; done
export PR_PUMPKIN="%F{208}"
export PR_PURPLE="%F{099}"
export PR_VIOLET="%F{093}"
export PR_LIME="%F{118}"
export PR_SOFT_BLUE="%F{027}"
export PR_SNOW="%F{038}"
export PR_YELLOW="%F{227}"
export PR_SUSE_DARK="%F{034}"
export PR_SUSE_LIGHT="%F{040}"

# Set the colors so they can be overridden in .zshrc
if [ -z "$COLOR_BORDER" ]; then
  COLOR_BORDER=%{$PR_LIGHT_BLUE%}
fi
if [ -z "$COLOR_USER" ]; then
  COLOR_USER=%{$PR_LIGHT_CYAN%}
fi
if [ -z "$COLOR_HOST" ]; then
  COLOR_HOST=%{$PR_LIGHT_MAGENTA%}
fi
if [ -z "$COLOR_CWD" ]; then
  COLOR_CWD=%{$PR_LIGHT_RED%}
fi
if [ -z "$COLOR_GIT" ]; then
  COLOR_GIT=%{$PR_YELLOW%}
fi
if [ -z "$COLOR_VENV" ]; then
  COLOR_VENV=%{$PR_BLUE%}
fi
if [ -z "$COLOR_EXTRA" ]; then
  COLOR_EXTRA=%{$PR_CYAN%}
fi
if [ -z "$COLOR_RETURN" ]; then
  COLOR_RETURN=%{$PR_LIGHT_RED%}
fi

# Git
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$PR_LIGHT_GREEN%}✔%{$COLOR_GIT%}"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$PR_LIGHT_ORANGE%}✜%{$COLOR_GIT%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$PR_LIGHT_RED%}✘%{$COLOR_GIT%}"

# Virtual Environments
function virtualenv_info {
  [ $VIRTUAL_ENV ] && echo `basename $VIRTUAL_ENV`
}

# Kubernetes Config File
function kubeconfig {
  [ $KUBECONFIG ] && echo `basename $KUBECONFIG`
}

# Pieces to be used in the prompts
local top_leader='%{$COLOR_BORDER%}╭─'
local current_dir='%{$PR_NO_COLOR%}%{$COLOR_CWD%}[%~]%{$PR_NO_COLOR%}%{$COLOR_BORDER%}'
local git_branch='%{$PR_NO_COLOR%}%{$COLOR_GIT%}[$(git_prompt_info)%{$COLOR_GIT%}]%{$PR_NO_COLOR%}%{$COLOR_BORDER%}'
local kube='%{$PR_NO_COLOR%}%{$COLOR_VENV%}[$(kubeconfig)]%{$PR_NO_COLOR%}%{$COLOR_BORDER%}'
local venv='%{$PR_NO_COLOR%}%{$COLOR_VENV%}[$(virtualenv_info)]%{$PR_NO_COLOR%}%{$COLOR_BORDER%}'
local bottom_leader='╰─%{$PR_NO_COLOR%}'
local prompt='%{$COLOR_BORDER%}➤ %{$PR_NO_COLOR%}'
local return_code="%(?..%{$COLOR_RETURN%}%? ↵%{$PR_NO_COLOR%})"


# local user='%{$PR_NO_COLOR%}%{$COLOR_USER%}%n%{$PR_NO_COLOR%}%{$COLOR_BORDER%}'
# local host='%{$PR_NO_COLOR%}%{$COLOR_HOST%}%M%{$PR_NO_COLOR%}%{$COLOR_BORDER%}'
# local extra='%{$PR_NO_COLOR%}%{$COLOR_EXTRA%}[$EXTRA_ENV]%{$PR_NO_COLOR%}%{$COLOR_BORDER%}'

# Assemble the prompts
# PROMPT="${top_leader}[${user}]─[${host}]─[${current_dir}]─[${git_branch}]─●
# PROMPT="${top_leader}[${host}]─[${current_dir}]─[${git_branch}]─[${venv}]─●
# PROMPT="${top_leader}${current_dir}─${git_branch}─${venv}─${extra}─●
PROMPT="${top_leader}${current_dir}─${git_branch}─${venv}─●
${bottom_leader}${prompt}%{$PR_NO_COLOR%}"
RPS1="${return_code}"
