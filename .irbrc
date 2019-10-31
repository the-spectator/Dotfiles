# Refer https://github.com/rafmagana/irbrc/blob/master/dot_irbrc

#history
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:PROMPT_MODE] = :CLASSIC

def app_prompt
  Rails.application.class.parent.name.underscore
end

def log_path
  rails_root = Rails.root
  "#{rails_root}/log/.irb-save-history"
end

def env_prompt
  case Rails.env
  when "development"
    "dev"
  when "production"
    "prod"
  else
    Rails.env
  end
end

# Loaded when we fire up the Rails console
# among other things I put the current environment in the prompt

if defined?(Rails) && (Rails.env.development? || Rails.env.test?)
  IRB.conf[:HISTORY_FILE] = FileUtils.touch(log_path).join
  IRB.conf[:PROMPT] ||= {}

  prompt = "#{app_prompt}[#{env_prompt}]:%03n "

  IRB.conf[:PROMPT][:RAILS] = {
    :PROMPT_I => "#{prompt}>> ",
    :PROMPT_N => "#{prompt}> ",
    :PROMPT_S => "#{prompt}* ",
    :PROMPT_C => "#{prompt}? ",
    :RETURN   => "=> %s\n"
  }

  IRB.conf[:PROMPT_MODE] = :RAILS
end
