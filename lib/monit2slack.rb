require "monit2slack/version"
require 'optparse'
require 'slack-notifier'

module Monit2Slack
  class Post
    options = {}

    opt_parser = OptionParser.new do |opt|

      opt.banner = "Usage: COMMAND [OPTIONS]"

      opt.on '--webhook WEBHOOK', 'Slack webhook.' do |arg|
        options[:webhook] = arg
      end

      opt.on '--channel CHANNEL', "name of the channel to post to" do |arg|
        options[:channel] = arg
      end

      opt.on '--emoji EMOJI', 'emoji icon' do |arg|
        options[:emoji] = arg
      end

      opt.on '--username USERNAME', 'username' do |arg|
        options[:username] = arg
      end

      opt.on '--status [error,ok]', "message satus" do |arg|
        options[:status] = arg
      end

      opt.on '--service SERVICE', "Monit service" do |arg|
        options[:service] = arg
      end

      opt.on '--text TEXT', "text of the message" do |arg|
        options[:text] = arg
      end

      opt.on '--color [good,bad,danger]', "text of the message" do |arg|
        options[:color] = arg
      end

      opt.on '--ping PING', "ping message" do |arg|
        options[:ping] = arg
      end

      opt.on '--service SERVICE', "The monitored service" do |arg|
        options[:service] = arg
      end

      opt.on '--host HOST', "Server hostname" do |arg|
        options[:host] = arg
      end
    end

    opt_parser.parse!

    options[:service] ||= ENV['MONIT_SERVICE']

    options[:host] ||= ENV['MONIT_HOST']

    options[:color] ||= case options[:status]
    when "error"
      "danger"
    when 'ok'
      'good'
    else
      'info'
    end

    options[:emoji] ||= case options[:status]
    when "error"
      ':bangbang:'
    when 'ok'
      ':ok:'
    else
      ':ghost:'
    end

    options[:text] ||= case options[:status]
    when "error"
      "Error, process is down."
    when 'ok'
      'Status is OK, process seems to be running.'
    else
      'Not sure.'
    end

    username = "#{options[:service]}@#{options[:host]}-#{options[:status]}"

    options[:username] ||= username

    attachment = {
      fallback: "#{options[:status]} status from Monit",
      text: options[:text],
      color: options[:color]
    }

    if options[:webhook]
      notifier = Slack::Notifier.new options[:webhook] do
        defaults channel: options[:channel],
        username: options[:username]
      end
      notifier.post text: "Message from Monit: #{ENV['MONIT_DESCRIPTION']}", icon_emoji: options[:emoji] if options[:text] && options[:emoji]
      notifier.post attachments: [attachment] if attachment
      notifier.ping options[:ping] if options[:ping]
    end
  end
end
