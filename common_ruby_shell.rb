require "#{ENV['HOME']}/aki_colours"

# application name
def app_prompt
  rails_klass = Rails.application.class

  app_name =
    if rails_klass.respond_to? :module_parent
      rails_klass.module_parent
    else
      rails_klass.parent
    end

  "#{bold}#{lcyan}#{app_name.name.underscore}#{reset}"
end

def env_prompt
  env =
    case Rails.env
    when "development"
      "#{green}dev"
    when "production"
      "#{lred}prod"
    else
      "#{cyan}#{Rails.env}"
    end

  "#{bold}#{env}#{reset}"
end

# target log path for irb history
def log_path
  rails_root = Rails.root
  "#{rails_root}/log/.irb-save-history"
end

# pbcopy helper: Copied from: https://stackoverflow.com/a/46065116/5863438
def pbcopy(arg)
  out = arg.is_a?(String) ? arg : arg.inspect
  IO.popen('pbcopy', 'w') { |io| io.puts out }
  puts out
  true
end
