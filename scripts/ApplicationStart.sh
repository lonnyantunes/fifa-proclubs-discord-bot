#!/bin/bash

# Setup Environment
source ~/.bash_profile
rvm use --default 2.6.0

# Install dependencies and start application
cd /home/ec2-user/fifa-proclubs-discord-bot
bundle install
bundle exec ruby lib/fifa_proclubs_bot.rb
