# frozen_string_literal: true

module Fifa
  module Proclubs
    module DiscordBot
      module Commands
        module ClubMembers
          extend Discordrb::Commands::CommandContainer

          # Bucket for rate limiting. Limits to x uses every y seconds at z intervals.
          bucket :limiter, limit: 1, time_span: 5, delay: 1

          command(:clubMembers,
                  description: 'To get members of a club',
                  usage: "#{Constants::PREFIX}clubMembers <platform>#{Fifa::Proclubs::Apis::Helper.platforms}",
                  permission_level: Constants::PERM_USER,
                  rate_limit_message: Constants::COMMAND_RATE_LIMIT_MSG,
                  min_args: 1,
                  max_args: 1,
                  bucket: :limiter) do |_event, _platform, _player_name|
            # Command Body
            if Utils.platform_exist(_event, _platform)
              club_name = Utils.club_name(_event)
              if club_name
                _event.respond Constants::SEARCH_IN_PROGRESS

                result = Fifa::Proclubs::Apis.club_members(_platform, club_name)

                if result.error_message_handler
                  _event.respond result.error_message_handler
                else
                  club_members = result.obj_result
                  embed_club_members(_event, club_name, club_members)
                end
              end
            end

            nil
          end

          def self.embed_club_members(_event, _club_name, _club_members)
            if _club_members
              _event.send_embed do |e|
                e.title = 'Club members'
                e.color = 0xFF00FF
                e.description = "List of members of the club '#{_club_name}'"

                _club_members.each do |_member|
                  e.fields.push(Discordrb::Webhooks::EmbedField.new(name: _member.name, value: Emoji.find_by_alias(rand_emoji).raw, inline: true))
                end
              end
            else
              _event.respond "No datas/members found about '#{_club_name}'!"
            end
          end

          private

          def self.rand_emoji
            %w[
              dog
              mouse
              hamster
              rabbit
              wolf
              frog
              tiger
              koala
              bear
              pig
              cow
              boar
              monkey_face
              monkey
              horse
              racehorse
              camel
              sheep
              elephant
              panda_face
              snake
              bird
              baby_chick
              hatched_chick
              hatching_chick
              chicken
              penguin
              turtle
              bug
              honeybee
              ant
              beetle
              snail
              octopus
              tropical_fish
              fish
              whale
              whale2
              dolphin
              cow2
              ram
              rat
              water_buffalo
              tiger2
              rabbit2
              dragon
              goat
              rooster
              dog2
              pig2
              mouse2
              ox
              dragon_face
              blowfish
              crocodile
              dromedary_camel
              leopard
              cat2
              poodle
            ].sample
          end
        end
      end
    end
  end
end
