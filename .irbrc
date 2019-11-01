# Refer https://github.com/rafmagana/irbrc/blob/master/dot_irbrc

require "#{ENV['HOME']}/aki_colours"

#history
IRB.conf[:SAVE_HISTORY] = 5000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:PROMPT_MODE] = :CLASSIC

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

# target log path for irb history
def log_path
  rails_root = Rails.root
  "#{rails_root}/log/.irb-save-history"
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

# Loaded when we fire up the Rails console
# among other things I put the current environment in the prompt

# Constants +PROMPT_I+, +PROMPT_S+ and +PROMPT_C+ specify the format. In the
# prompt specification, some special strings are available:
#
#     %N    # command name which is running
#     %m    # to_s of main object (self)
#     %M    # inspect of main object (self)
#     %l    # type of string(", ', /, ]), `]' is inner %w[...]
#     %NNi  # indent level. NN is digits and means as same as printf("%NNd").
#           # It can be omitted
#     %NNn  # line number.
#     %%    # %

#     IRB.conf[:PROMPT][:MY_PROMPT] = { # name of prompt mode
#       :AUTO_INDENT => false,          # disables auto-indent mode
#       :PROMPT_I =>  ">> ",		        # simple prompt
#       :PROMPT_S => nil,		            # prompt for continuated strings
#       :PROMPT_C => nil,		            # prompt for continuated statement
#       :RETURN => "    ==>%s\n"	      # format to return value
#     }

if defined?(Rails) && (Rails.env.development? || Rails.env.test?)
  IRB.conf[:HISTORY_FILE] = FileUtils.touch(log_path).join
  IRB.conf[:PROMPT] ||= {}

  prompt = "#{app_prompt}[#{env_prompt}]:%03n "

  IRB.conf[:PROMPT][:RAILS] = {
    :PROMPT_I => "#{prompt}>> ",
    :PROMPT_N => "#{prompt}> ",
    :PROMPT_S => "#{prompt}* ",
    :PROMPT_C => "#{prompt}? ",
    :RETURN   => "  => %s\n"
  }

  IRB.conf[:PROMPT_MODE] = :RAILS
end
