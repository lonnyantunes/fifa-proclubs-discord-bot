module Fifa
  module Proclubs
    module DiscordBot
      module Commands
        module ClubStats
          extend Discordrb::Commands::CommandContainer

          # Bucket for rate limiting. Limits to x uses every y seconds at z intervals.
          bucket :limiter, limit: 1, time_span: 5, delay: 1

          command(:clubStats,
                  description: 'To get datas about a club',
                  usage: "#{Constants::PREFIX}clubStats <platform>#{Fifa::Proclubs::Apis::Helper.platforms}",
                  permission_level: Constants::PERM_USER,
                  rate_limit_message: Constants::COMMAND_RATE_LIMIT_MSG,
                  min_args: 1,
                  max_args: 1,
                  bucket: :limiter) do |_event, _platform|

            # Command Body
            if Utils.platform_exist(_event, _platform)
              club_name = Utils.club_name(_event)

              if club_name
                _event.respond Constants::SEARCH_IN_PROGRESS

                result = Fifa::Proclubs::Apis.club_stats(_platform, club_name)
                if result.error_message_handler
                  _event.respond result.error_message_handler
                else
                  embed_clubs_stats(_event, result.obj_result, club_name)
                end
              end
            end

            nil
          end

          def self.embed_clubs_stats(_event, _club, _club_name)
            _event.send_embed do |e|
              e.title = 'Club statistics'
              e.color = 0xFF00FF
              e.description = "Details about #{_club_name}"

              e.fields = [
                Discordrb::Webhooks::EmbedField.new(name: 'Seasons', value: _club.seasons, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Ranking points', value: _club.rankingPoints, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Best division', value: _club.bestDivision, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Titles won', value: _club.titlesWon, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Leagues won', value: _club.leaguesWon, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Total games', value: _club.totalGames, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Wins', value: _club.wins, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Ties', value: _club.ties, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Losses', value: _club.losses, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'All time goals', value: _club.goals, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'All time goals against', value: _club.goalsAgainst, inline: true)
              ]
            end
          end
        end
      end
    end
  end
end
