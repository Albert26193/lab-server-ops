#!/bin/bash

# for fzf_jump
# change your dir here
jump_root_dirs=(
	"${HOME}/remote-codespace"
	"${HOME}/.config"
	"${HOME}/.ssh"
	"${HOME}/tmp"
	"${HOME}/onekey_zsh"
	"${HOME}/my_dotfile"
)

jump_ignore_dirs=(
	"node_modules"
	".git"
	"dist"
	".cache"
	"voice-print"
	"lodash"
	"from-github"
	"assets"
	"image"
	"images"
	"static"
	"data"
	"raycast"
	"obsidian-*"
	"zlt-*"
)
