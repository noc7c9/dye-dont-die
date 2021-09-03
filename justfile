_list:
    @just --list

watch CMD +ARGS='':
    watchexec --watch src --restart --clear -- just {{CMD}} {{ARGS}}

run:
    godot .

editor:
    godot project.godot
