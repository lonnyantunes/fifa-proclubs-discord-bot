module Fifa
  module Proclubs
    module DiscordBot
      module Commands
        module PlayerDatasTop100
          extend Discordrb::Commands::CommandContainer

          # Bucket for rate limiting. Limits to x uses every y seconds at z intervals.
          bucket :limiter, limit: 1, time_span: 5, delay: 1

          command(:searchPlayerTop100,
                  description: 'To get datas about a player from the Top100',
                  usage: "#{Constants::PREFIX}searchPlayerTop100 <platform>#{Fifa::Proclubs::Apis::Helper.platforms} <player_name>",
                  permission_level: Constants::PERM_USER,
                  rate_limit_message: Constants::COMMAND_RATE_LIMIT_MSG,
                  min_args: 2,
                  max_args: 2,
                  bucket: :limiter) do |_event, _platform,_player_name|

            # Command Body
            if Utils.platform_exist(_event, _platform)
              _event.respond Constants::SEARCH_IN_PROGRESS
              result = Fifa::Proclubs::Apis.player_datas_top100(_platform, _player_name)

              if result.error_message_handler
                _event.respond result.error_message_handler
              else
                embed_player_top_100(_event, result.obj_result)
              end
            end

            nil
          end

          def self.embed_player_top_100(_event, _player_datas_top100)
            player_name = _player_datas_top100[0]
            player_club_name = _player_datas_top100[1]
            player_club_place = _player_datas_top100[2]

            _event.send_embed do |e|
              e.title = "Top 100 : search club of the player named '#{player_name}'"
              e.color = 0xFF00FF
              e.description = 'Current club informations'

              e.fields =  [
                Discordrb::Webhooks::EmbedField.new(name: 'Place', value: player_club_place, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Club', value: player_club_name, inline: true)
              ]
            end
          end
        end
      end
    end
  end
end
