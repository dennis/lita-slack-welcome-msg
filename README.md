# lita-slack-welcome-msg

[![Build Status](https://travis-ci.org/dennis/lita-slack-welcome-msg.png?branch=master)](https://travis-ci.org/dennis/lita-slack-welcome-msg)
[![Coverage Status](https://coveralls.io/repos/dennis/lita-slack-welcome-msg/badge.png)](https://coveralls.io/r/dennis/lita-slack-welcome-msg)

Simple handler that will greet new users that joins slack. You can also do
`welcome stranger` to send the greeting to the user `stranger`.

## Installation

This handler requires a new event from slack (`team_join`) which is currently not supported
by `lita-slack`. So until my [PR](https://github.com/litaio/lita-slack/pull/130) gets merged, you
need to use my version of `lita-slack`.

Add the following to your Gemfile:

``` ruby
gem "lita-slack", github: "dennis/lita-slack", branch: "team-join-events"
gem "lita-slack-welcome-msg", github: "dennis/lita-slack-welcome-msg"
```

## Configuration

You can customize the greeting in your `lita_config.rb`
```
  ..

  config.handlers.slack_welcome_msg.message = "Yo %<mention_name>s! Welcome to the posse"
  ..
```

Currently the handler will expand `%<mention_name>s` (e.g.: `Dennis`) and
`%<name>s` (e.g.: `Dennis Møllegaard`).

## Usage

It supports the command `welcome <username>`, to manually make the bot send the
welcome message to a specific user.
