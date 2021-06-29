module Fifa
  module Proclubs
    module DiscordBot
      module Commands
        module ClubsRankTop100
          extend Discordrb::Commands::CommandContainer

          # Bucket for rate limiting. Limits to x uses every y seconds at z intervals.
          bucket :limiter, limit: 1, time_span: 5, delay: 1

          command(:top100,
                  description: 'To get all clubs from the Top100',
                  usage: "#{Constants::PREFIX}top100 <platform>#{Fifa::Proclubs::Apis::Helper.platforms}",
                  permission_level: Constants::PERM_USER,
                  rate_limit_message: Constants::COMMAND_RATE_LIMIT_MSG,
                  min_args: 1,
                  max_args: 1,
                  bucket: :limiter) do |_event, _platform|

            # Command Body
            if Utils.platform_exist(_event, _platform)
              _event.respond Constants::SEARCH_IN_PROGRESS
              result = Fifa::Proclubs::Apis.clubs_rank_top100(_platform)

              if result.error_message_handler
                _event.respond result.error_message_handler
              else
                embed_clubs_top_100(_event, result.obj_result[0..24], _platform)
                embed_clubs_top_100(_event, result.obj_result[25..49], _platform)
                embed_clubs_top_100(_event, result.obj_result[50..74], _platform)
                embed_clubs_top_100(_event, result.obj_result[75..99], _platform)
              end
            end

            nil
          end

          def self.embed_clubs_top_100(_event, _array_club_top100, _platform)
            _event.send_embed do |e|
              e.title = "Top 100 clubs"
              e.color = 0xFF00FF
              e.description = "Current platform '#{_platform}'"

              _array_club_top100.each do |club|
                e.fields.push(Discordrb::Webhooks::EmbedField.new(name: "#{club.place} - #{club.clubName}",
                                                                  value: "Points : #{club.rankingPoints}\n🏆 Season titles : #{club.titlesWon}\n🥇 Leagues Won: #{club.leaguesWon}",
                                                                  inline: true)
                )
              end
            end
          end
        end
      end
    end
  end
end
