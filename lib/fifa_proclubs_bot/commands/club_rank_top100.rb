module Fifa
  module Proclubs
    module DiscordBot
      module Commands
        module ClubRankTop100
          extend Discordrb::Commands::CommandContainer

          # Bucket for rate limiting. Limits to x uses every y seconds at z intervals.
          bucket :limiter, limit: 1, time_span: 5, delay: 1

          command(:searchClubTop100,
                  description: 'To get datas about a club from the Top100',
                  usage: "#{Constants::PREFIX}clubTop100 <platform>#{Fifa::Proclubs::Apis::Helper.platforms}",
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

                result = Fifa::Proclubs::Apis.club_rank_top100(_platform, club_name)
                if result.error_message_handler
                  _event.respond result.error_message_handler
                else
                  embed_club_top_100(_event, result.obj_result)
                end
              end
            end

            nil
          end

          def self.embed_club_top_100(_event, _club)
            _event.send_embed do |e|
              e.title = 'Top100 club statistics'
              e.color = 0xFF00FF
              e.description = "Details about #{_club.clubName}"

              e.fields = [
                Discordrb::Webhooks::EmbedField.new(name: 'Seasons', value: _club.seasons, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Ranking points', value: _club.rankingPoints, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Best division', value: _club.bestDivision, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Current division', value: _club.currentDivision, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Titles won', value: _club.titlesWon, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Leagues won', value: _club.leaguesWon, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Total games', value: _club.totalGames, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Wins', value: _club.wins, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Ties', value: _club.ties, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Losses', value: _club.losses, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Goals', value: _club.goals, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Goals against', value: _club.goalsAgainst, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Average goals per game', value: _club.averageGoalsPerGame, inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Average goals against per game', value: _club.averageGoalsAgainstPerGame, inline: true)
              ]
            end
          end
        end
      end
    end
  end
end
