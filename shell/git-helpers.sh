#!/bin/bash

# Inspired by http://www.jperla.com/blog/post/teach-yourself-git-in-2-minutes.

function ad() {
    echo 'git add' $@ '\n' 
    git add "${@}"
}

function pl() {
    echo 'git pull' $@ '\n'
    git pull "${@}"
}

function ph() {
    echo 'git push' $@ '\n'
    git push "${@}"
}

function cm() {
    echo 'git commit -m' $@ '\n'
    git commit -m "${@}"
}

function ss() {
    echo 'git status' $@ '\n'
    git status "${@}"
}

function lg() {
    echo 'git log' $@ '\n'
    git log "${@}"
}

function df() {
    echo 'git diff' $@ '\n'
    git diff "${@}"
}

function me() {
    echo 'git merge' $@ '\n'
    git merge "${@}"
}

function bh() {
    echo 'git branch' $@ '\n'
    git branch "${@}"
}

function ct() {
    echo 'git checkout' $@ '\n'
    git checkout "${@}"
}

## Aliases 

alias AD=ad
alias PL=pl
alias PH=ph
alias CM=cm
alias SS=ss
alias LG=lg
alias DF=df
alias ME=me
alias BH=bh
alias CT=ct
