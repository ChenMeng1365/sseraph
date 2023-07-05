
# Tmux

将下述内容复制到.tmux.conf中实现配置

```text
# author: XuTao
# time: Sun Jul 15 21:57:17 CST 2012
# Usage: mv tmux_conf.txt ~/.tmux.conf
#------------------------------------------

#-- base --#
set -g default-terminal "screen"
set -g display-time 3000
set -g history-limit 65535
#----------------------------------------------

#将默认按键前缀改为与C-a避免与终端快捷键冲突

set-option -g prefix C-a
unbind-key C-b
bind-key C-a send-prefix
#----------------------------------------------

#按键绑定


#水平或垂直分割窗口 (C+A+ :split-window + v/h)
unbind '"'
bind - splitw -v #分割成上下两个窗口
unbind %
bind | splitw -h #分割成左右两个窗口
#----------------------------------------------

#选择分割的窗格
bind k selectp -U #选择上窗格
bind j selectp -D #选择下窗格
bind h selectp -L #选择左窗格
bind l selectp -R #选择右窗格
#----------------------------------------------

#重新调整窗格的大小
bind ^k resizep -U 10
bind ^j resizep -D 10
bind ^h resizep -L 10
bind ^l resizep -R 10
#----------------------------------------------

#交换两个窗格
bind ^u swapp -U
bind ^d swapp -D

bind ^a last
bind q killp
#----------------------------------------------

bind '~' splitw htop
bind ! splitw ncmpcpp
bind m command-prompt "splitw -h 'exec man %%'"

unbind s
#----------------------------------------------

#定制状态行

set -g status-left "#[fg=white,bg=blue] > #I < #[default] |" # 0:bash
#set -g status-left "#[fg=white,bg=blue] > #I < #[default] |" # session-name
set -g status-right "#[fg=yellow,bright][ #[fg=cyan]#W #[fg=yellow]]#[default] #[fg=yellow,bright]- %Y.%m.%d #[fg=green]%H:%M #[default]"
set -g status-right-attr bright

set -g status-bg black
set -g status-fg white
set -g set-clipboard on

setw -g window-status-current-attr bright
#setw -g window-status-current-bg red
setw -g window-status-current-bg green
setw -g window-status-current-fg white

set -g status-utf8 on
set -g status-interval 1

#set -g visual-activity on
#setw -g monitor-activity on

set -g status-keys vi
#----------------------------------------------

setw -g mode-keys vi
setw -g mode-mouse on

#setw -g mouse-resize-pane on
#setw -g mouse-select-pane on
#setw -g mouse-select-window on

# move x clipboard into tmux paste buffer
bind C-p run "tmux set-buffer \"$(xclip -o -sel clipbaord)\"; tmux paste-buffer"
# move tmux copy buffer into x clipboard
bind C-y run "tmux show-buffer | xclip -i -sel clipbaord"

#默认启动应用

#new -s work # 新建名为 work 的会话，并启动 mutt
#neww rtorrent # 启动 rtorrent
#neww vim # 启动 vim
#neww zsh
#selectw -t 3 # 默认选择标号为 3 的窗口
```
