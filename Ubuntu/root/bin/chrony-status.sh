#!/bin/sh

# What time is it? And how is the clock doing?

chronyc sources -v
chronyc tracking
chronyc sourcestats -v
