#!/bin/bash
function robot-status {
    tmux kill-session -t   "robot"
    tmux new-session -d -s "robot"

    tmux split-window -h -p 50
    tmux split-window -v -p 50
    tmux selectp -t 0
    tmux split-window -v -p 50

    tmux send-keys -t robot.0 "cd ~/.robot" ENTER
    tmux send-keys -t robot.1 "watch -n 1 cat /home/pi/.robot/programme.txt" ENTER
    tmux send-keys -t robot.2 "watch -n 1 cat /home/pi/.robot/robot/Programme.py" ENTER
    tmux send-keys -t robot.3 "watch -n 1 cat /home/pi/.robot/informations" ENTER

    tmux selectp -t 0
    tmux a -d -t "robot"
} ; robot-status
