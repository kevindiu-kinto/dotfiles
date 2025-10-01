# Bash history configuration for persistent storage

# History file location (persistent volume)
export HISTFILE=/home/dev/.shell_history/bash_history

# History settings
export HISTSIZE=10000
export HISTFILESIZE=20000

# History options
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="[%F %T] "

# Append to history file, don't overwrite
shopt -s histappend

# Save and reload history after each command
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"