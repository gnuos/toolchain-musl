#!/bin/sh

CC=gcc
CFLAGS="-g -Wall -Os -s"

PROGRAM="start-stop-daemon"
SOURCES="start-stop-daemon.c"

$CC $CFLAGS -o $PROGRAM $SOURCES

