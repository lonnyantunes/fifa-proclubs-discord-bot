module Fifa
  module Proclubs
    module DiscordBot
      module Commands
        module PlayerDatas
          extend Discordrb::Commands::CommandContainer

          # Bucket for rate limiting. Limits to x uses every y seconds at z intervals.
          bucket :limiter, limit: 1, time_span: 5, delay: 1

          command(:player,
                  description: 'To get datas about a player',
                  usage: "#{Constants::PREFIX}player <platform>#{Fifa::Proclubs::Apis::Helper.platforms} <player_name>",
                  permission_level: Constants::PERM_USER,
                  rate_limit_message: Constants::COMMAND_RATE_LIMIT_MSG,
                  min_args: 2,
                  max_args: 2,
                  bucket: :limiter) do |_event, _platform, _player_name|

            # Command Body
            if Utils.platform_exist(_event, _platform)
              club_name = Utils.club_name(_event)
              if club_name
                _event.respond Constants::SEARCH_IN_PROGRESS

                result = Fifa::Proclubs::Apis.player_datas(_platform, club_name, _player_name)

                if result.error_message_handler
                  _event.respond result.error_message_handler
                else
                  player_datas = result.obj_result
                  embed_career(_event, player_datas)
                  embed_club(_event, player_datas)
                end
              end
            end

            nil
          end

          def self.embed_career(_event, _player_datas)
            if _player_datas.memberCareer
              member_career = _player_datas.memberCareer
              _event.send_embed do |e|
                e.title = 'Career player statistics'
                e.color = 0xFF00FF
                e.description = "Details about #{_player_datas.name}"

                e.fields = [
                  Discordrb::Webhooks::EmbedField.new(name: 'Rating average', value: member_career.ratingAve, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Favorite position', value: member_career.favoritePosition, inline: true),

                  Discordrb::Webhooks::EmbedField.new(name: 'Games played', value: member_career.gamesPlayed, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Man of the match', value: member_career.manOfTheMatch, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Goals', value: member_career.goals, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Assists', value: member_career.assists, inline: true)
                ]
              end
            else
              _event.respond "No datas found about '#{_player_datas.name}' career!"
            end
          end

          def self.embed_club(_event, _player_datas)
            if _player_datas.memberClub
              member_club = _player_datas.memberClub
              _event.send_embed do |e|
                e.title = "Club player statistics : #{member_club.clubName}"
                e.color = 0xFF00FF
                e.description = "Details about #{_player_datas.name}"

                e.fields = [
                  Discordrb::Webhooks::EmbedField.new(name: 'Pro name', value: member_club.proName, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Pro overall', value: member_club.proOverall, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Favorite position', value: member_club.favoritePosition, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Games played', value: member_club.gamesPlayed, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Man of the match', value: member_club.manOfTheMatch, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Goals', value: member_club.goals, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Assists', value: member_club.assists, inline: true),

                  Discordrb::Webhooks::EmbedField.new(name: 'Win rate', value: member_club.winRate, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Shot success rate', value: member_club.shotSuccessRate, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Passes made', value: member_club.passesMade, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Pass success rate', value: member_club.passSuccessRate, inline: true),

                  Discordrb::Webhooks::EmbedField.new(name: 'Tackles made', value: member_club.tacklesMade, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Tackle success rate', value: member_club.tackleSuccessRate, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Red cards', value: member_club.redCards, inline: true),

                  Discordrb::Webhooks::EmbedField.new(name: 'Clean sheets Def', value: member_club.cleanSheetsDef, inline: true),
                  Discordrb::Webhooks::EmbedField.new(name: 'Clean sheets GK', value: member_club.cleanSheetsGK, inline: true)
                ]
              end
            else
              _event.respond "No datas found about the club player '#{_player_datas.name}' club !"
            end
          end
        end
      end
    end
  end
end
