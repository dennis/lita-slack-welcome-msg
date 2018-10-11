module Lita
  module Handlers
    class SlackWelcomeMsg < Handler
      config :message, type: String, default: "Hi %<mention_name>s, and welcome to our chat!"

      on :slack_team_joined, :handle_slack_team_join

      #route(/^welcome\s+(.+)$/, :handle_welcome_command, command: true, restrict_to: :admins, help: {
      route(/^welcome\s+(.+)$/, :handle_welcome_command, command: true, help: {
        "welcome USERNAME" => "Send welcome message to USERNAME"
      })

      def handle_slack_team_join(slack_user)
        welcome_message(slack_user)
      end

      def handle_welcome_command(response)
        stranger_name = response.matches.flatten.first
        stranger = Lita::User.fuzzy_find(stranger_name)

        if stranger
          response.reply "Sending message to #{stranger.mention_name}"
          welcome_message(stranger)
        else
          response.reply "I don't know #{stranger_name} :("
        end
      end

      private

      def welcome_message(user)
        target = Source.new(user: user)
        message = config.message % { mention_name: user.mention_name, name: user.name }

        robot.send_message(target, message)
      end

      Lita.register_handler(self)
    end
  end
end
