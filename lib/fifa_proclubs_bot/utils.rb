module Fifa
  module Proclubs
    module DiscordBot
      module Utils
        def self.platform_exist(_event, _platform)
          platforms = Fifa::Proclubs::Apis::Helper.platforms

          if platforms.find { |platform| platform == _platform }
            true
          else
            _event.respond "🎮 Platform '#{_platform}' not found in #{platforms} !"
            false
          end
        end

        def self.club_name(_event)
          _event.respond '✈️ What\'s your club name?'
          response = _event.message.await!(timeout: Constants::EVENT_TIMEOUT)
          if response
            response.message.content
          else
            _event.respond '🟥 You took too long to write your club name! 🟥'
            nil
          end
        end
      end
    end
  end
end
