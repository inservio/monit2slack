# Monit2slack

Send messages to Slack via Monit.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'monit2slack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install monit2slack

## Usage

This gem provides a binary `monit2slack`.

````
monit2slack --webhook 'https://hooks.slack.com/services/xxx/xxx/xxx' --host MyServer --service NginX --status error --text 'Process NginX is down'
````

If using `rbenv`

````
/usr/local/rbenv/shims/monit2slack --webhook 'https://hooks.slack.com/services/xxx/xxx/xxx' --host MyServer --service NginX --status error --text 'Process NginX is down'
````

If you prefer you can call if manually from a rb file.

````
#!/usr/bin/env ruby

require "monit2slack"

Monit2Slack::Post
````

## Monit configuration examples

### Process monitoring

#### Implicit configuration

In this case `hostname`, `service` and `description` gets read from the environment variables that monit provides.

````
check process NginX
  with pidfile /run/nginx.pid
  start program = "/etc/init.d/nginx start" with timeout 30 seconds
  stop program = "/etc/init.d/nginx stop" with timeout 30 seconds
  if does not exist for 1 cycle
    then exec "/usr/local/rbenv/shims/monit2slack --webhook 'https://hooks.slack.com/services/xxx/xxx/xxx' --status error'"
    else if succeeded for 1 cycle then exec "/usr/local/rbenv/shims/monit2slack --webhook 'https://hooks.slack.com/services/xxx/xxx/xxx' --status ok"
  if does not exist then restart
````

#### Explicit configuration

You control settings like `hostname`, `service` and `description`.

````
check process NginX
  with pidfile /run/nginx.pid
  start program = "/etc/init.d/nginx start" with timeout 30 seconds
  stop program = "/etc/init.d/nginx stop" with timeout 30 seconds
  if does not exist for 1 cycle
    then exec "/usr/local/rbenv/shims/monit2slack --webhook 'https://hooks.slack.com/services/xxx/xxx/xxx' --host MyServer --service NginX --status error --text 'Process NginX is down'"
    else if succeeded for 1 cycle then exec "monit2slack --webhook 'https://hooks.slack.com/services/xxx/xxx/xxx' --host MyServer --service NginX --status ok --text 'Process NginX is up'"
  if does not exist then restart
````

### Disk usage monitoring

````
check filesystem rootfs with path /
if space usage > 80%
then exec "/usr/local/rbenv/shims/monit2slack --webhook 'https://hooks.slack.com/services/xx/xx/xx' --status error"
else if succeeded then exec "/usr/local/rbenv/shims/monit2slack --webhook 'https://hooks.slack.com/services/xx/xx/xx' --status ok"

````

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
