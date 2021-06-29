module Fifa
  module Proclubs
    module DiscordBot
      module Constants
        PREFIX = '/'.freeze
        EVENT_TIMEOUT = 30

        # Permission Constants
        PERM_ADMIN = 2
        PERM_MOD = 1
        PERM_USER = 0

        COMMAND_RATE_LIMIT_MSG = '🟥 Command Rate-Limited to Once every 5 seconds! 🟥'.freeze
        SEARCH_IN_PROGRESS = "🚀 Search in progress..... ⏱ Please wait a few seconds".freeze
      end
    end
  end
end
