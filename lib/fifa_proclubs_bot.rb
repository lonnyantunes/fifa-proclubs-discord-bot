require 'dotenv'
require 'discordrb'
require 'fifa/game'

require_relative 'fifa_proclubs_bot/version.rb'
require_relative 'fifa_proclubs_bot/constants.rb'
require_relative 'fifa_proclubs_bot/utils.rb'
require_relative 'fifa_proclubs_bot/command_loader.rb'

module Fifa
  module Proclubs
    module DiscordBot
      unless ENV['DISCORD_TOKEN']
        Dotenv.load('.env.development')
      end

      # init fifa-game gem
      Fifa::Utils::Environment::Setup.init(
        'fifa-proclubs-discord-bot'.freeze,
        ENV['IS_DEBUG'],
        ENV['IS_VERBOSE'],
        nil,
        Time.new.strftime('%Y%m%d%k%M%S')
      )

      # Debug
      rescue_proc = proc do |_event, _exception|
        embed = Discordrb::Webhooks::Embed.new(
          description: "#{_exception}\n\n```#{_exception.backtrace}```",
          title: 'Uncaught Exception Occurred!'.freeze
        )
        embed.colour = '#ff0000'
        FPCBot.send_message(ENV['DEBUG_CHANNEL'], '', false, embed)
      end

      # Establish Discord Bot Connection
      FPCBot = Discordrb::Commands::CommandBot.new(token: ENV['DISCORD_TOKEN'],
                                                  prefix: Constants::PREFIX,
                                                  command_doesnt_exist_message: "Use #{Constants::PREFIX}help to see a list of available commands",
                                                  rescue: rescue_proc)

      # When the bot starts up
      FPCBot.ready do |_event|
        FPCBot.game = "#{Constants::PREFIX}help for commands"
        puts 'Bot Online and Connected to Server'
      end

      # Load up all the commands
      CommandLoader.load_commands

      FPCBot.run
    end
  end
end
