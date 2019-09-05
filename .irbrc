# Refer https://github.com/rafmagana/irbrc/blob/master/dot_irbrc

#history
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:PROMPT_MODE] = :SIMPLE

# Loaded when we fire up the Rails console
# among other things I put the current environment in the prompt

if defined?(Rails) && (Rails.env.development? || Rails.env.test?)
  rails_env = Rails.env
  rails_app = Rails.application.class.parent.name.underscore
  rails_root = Rails.root
  prompt = "#{rails_app}[#{rails_env.sub('production', 'prod').sub('development', 'dev')}]:%03n "
  log_file = "#{rails_root}/log/.irb-save-history"

  IRB.conf[:HISTORY_FILE] = FileUtils.touch(log_file).join

  IRB.conf[:PROMPT] ||= {}

  IRB.conf[:PROMPT][:RAILS] = {
    :PROMPT_I => "#{prompt}>> ",
    :PROMPT_N => "#{prompt}> ",
    :PROMPT_S => "#{prompt}* ",
    :PROMPT_C => "#{prompt}? ",
    :RETURN   => "=> %s\n"
  }

  IRB.conf[:PROMPT_MODE] = :RAILS
end

### IRb HELPER METHODS

#clear the screen
def clear
  system('clear')
end
alias :cl :clear

#ruby documentation right on the console
# ie. ri Array#each
def ri(*names)
  system(%{ri #{names.map {|name| name.to_s}.join(" ")}})
end
