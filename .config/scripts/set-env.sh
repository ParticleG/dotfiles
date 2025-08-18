#!/bin/bash

# Add EDITOR, VISUAL, and SYSTEMD_EDITOR environment variables
echo "EDITOR=nvim" | sudo tee -a /etc/environment
echo "VISUAL=nvim" | sudo tee -a /etc/environment
echo "SYSTEMD_EDITOR=nvim" | sudo tee -a /etc/environment