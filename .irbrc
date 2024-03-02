# Refer https://github.com/rafmagana/irbrc/blob/master/dot_irbrc

require "#{ENV['HOME']}/common_ruby_shell"

#history
IRB.conf[:SAVE_HISTORY] = 5000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:PROMPT_MODE] = :CLASSIC
IRB.conf[:USE_MULTILINE] = false
IRB.conf[:USE_AUTOCOMPLETE] = false

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

if defined?(Rails)
  def rails_prompt(separator)
    format(
      '%<app>s[%<env>s]:%%03n %<sep>s ',
      app: app_prompt,
      env: env_prompt,
      sep: separator
    )
  end

  IRB.conf[:HISTORY_FILE] = FileUtils.touch(log_path).join
  IRB.conf[:PROMPT] ||= {}

  IRB.conf[:PROMPT][:RAILS] = {
    :PROMPT_I => rails_prompt(">>"),
    :PROMPT_N => rails_prompt(">"),
    :PROMPT_S => rails_prompt("*"),
    :PROMPT_C => rails_prompt("?"),
    :RETURN   => "  #{bold}=>#{reset} %s\n"
  }

  IRB.conf[:PROMPT][:RAILS_EMOJI] = {
    :PROMPT_I => rails_prompt("\u{1F601}  >"),
    :PROMPT_N => rails_prompt("\u{1F609}  >"),
    :PROMPT_S => rails_prompt("\u{1F606}  >"),
    :PROMPT_C => rails_prompt("\u{1F605}  >"),
    :RETURN   => "  #{bold}=>#{reset} %s\n"
  }

  IRB.conf[:PROMPT_MODE] = :RAILS
end

def my_methods obj
  (obj.methods - Object.methods).sort
end
