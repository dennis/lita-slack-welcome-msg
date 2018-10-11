require "spec_helper"

describe Lita::Handlers::SlackWelcomeMsg, lita_handler: true do
  context "slack_team_joined" do
    context "handling slack_team_joined" do
      it { is_expected.to route_event(:slack_team_joined).to(:handle_slack_team_join) }

      it "sends welcome message to new users" do
        robot.trigger(:slack_team_joined, user)

        expect(replies.first).to eq("Hi Test User, and welcome to our chat!")
      end
    end

    context "handle commands" do
      let(:stranger) { Lita::User.create("2", name: "Stranger") }

      before do
        allow(robot.auth).to receive(:user_is_admin?).with(user).and_return(true)
      end

      it { is_expected.to route_command("welcome stranger").with_authorization_for(:admins).to(:handle_welcome_command) }

      it "sends welcome message to a known user" do
        allow(Lita::User).to receive(:fuzzy_find).and_return(stranger)

        send_command("welcome stranger")

        expect(replies).to include("Hi Stranger, and welcome to our chat!")
        expect(replies).to include("Sending message to Stranger")
      end

      it "sends error message back, if user not found" do
        send_command("welcome stranger")

        expect(replies.last).to include("I don't know stranger :(")
      end
    end

    context "message" do
      let(:stranger) { Lita::User.create("2", name: "name", mention_name: "mention_name") }

      before do
        allow(robot.auth).to receive(:user_is_admin?).with(user).and_return(true)
        allow(Lita::User).to receive(:fuzzy_find).and_return(stranger)
      end

      it "is configurable" do
        robot.config.handlers.slack_welcome_msg.message = "ASDF"

        send_command("welcome name")

        expect(replies).to include("ASDF")
      end

      it "expands %<name>s" do
        robot.config.handlers.slack_welcome_msg.message = "Hi %<name>s"

        send_command("welcome name")

        expect(replies).to include("Hi name")
      end

      it "expands %<mention_name>s" do
        robot.config.handlers.slack_welcome_msg.message = "Hi %<mention_name>s"

        send_command("welcome name")

        expect(replies).to include("Hi mention_name")
      end
    end
  end
end
