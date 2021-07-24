module Fifa
  module Proclubs
    module DiscordBot
      module CommandLoader
        # Require all command files
        Dir["#{File.dirname(__FILE__)}/commands/*.rb"].each do |file|
          require file
        end

        # Add Command module names here
        @commands = [
          Commands::ClubMatchesHistory,
          Commands::ClubRankTop100,
          Commands::ClubStats,
          Commands::ClubsRankTop100,
          Commands::ClubMembers,
          Commands::PlayerDatasTop100,
          Commands::PlayerDatas
        ]

        def self.get_commands
          @commands
        end

        def self.check_commands(_command)
          @commands.each do |command|
            return true if _command == command
          end
          false
        end

        def self.load_commands
          @commands.each do |command|
            Fifa::Proclubs::DiscordBot::FPCBot.include!(command)
          end
        end
      end
    end
  end
end
