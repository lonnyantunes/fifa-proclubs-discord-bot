module Fifa
  module Proclubs
    module DiscordBot
      module Commands
        module ClubMatchesHistory
          extend Discordrb::Commands::CommandContainer

          # Bucket for rate limiting. Limits to x uses every y seconds at z intervals.
          bucket :limiter, limit: 1, time_span: 5, delay: 1

          command(:clubMatchesHistory,
                  description: 'To get the history of the last 10 matches of a club',
                  usage: "#{Constants::PREFIX}clubMatchesHistory <platform>#{Fifa::Proclubs::Apis::Helper.platforms}",
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
                  embed_clubs_matches_history(_event, result.obj_result, club_name)
                end
              end
            end
            nil
          end

          def self.embed_clubs_matches_history(_event, _club, _club_name)
            _event.send_embed do |e|
              e.title = 'Club matches history'
              e.color = 0xFF00FF
              e.description = "Details about the last 10 matches of '#{_club_name}'"

              e.fields = [
                Discordrb::Webhooks::EmbedField.new(name: 'Match 1 (the last)', value: convert_to_emoji(_club.matches.lastMatch0), inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Match 2', value: convert_to_emoji(_club.matches.lastMatch1), inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Match 3', value: convert_to_emoji(_club.matches.lastMatch2), inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Match 4', value: convert_to_emoji(_club.matches.lastMatch3), inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Match 5', value: convert_to_emoji(_club.matches.lastMatch4), inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Match 6', value: convert_to_emoji(_club.matches.lastMatch5), inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Match 7', value: convert_to_emoji(_club.matches.lastMatch6), inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Match 8', value: convert_to_emoji(_club.matches.lastMatch7), inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Match 9', value: convert_to_emoji(_club.matches.lastMatch8), inline: true),
                Discordrb::Webhooks::EmbedField.new(name: 'Match 10', value: convert_to_emoji(_club.matches.lastMatch9), inline: true),
              ]
            end
          end

          def self.convert_to_emoji(_match_result)
            case _match_result
            when Fifa::Proclubs::Apis::Matches::RESULT::WINS
              ':green_circle:'
            when Fifa::Proclubs::Apis::Matches::RESULT::TIES
              ':white_circle:'
            when Fifa::Proclubs::Apis::Matches::RESULT::LOSSES
              ':red_circle:'
            end
          end
        end
      end
    end
  end
end
