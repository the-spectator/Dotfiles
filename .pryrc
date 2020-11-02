require "#{ENV['HOME']}/common_ruby_shell"

Pry::Prompt.add(:aki_rails, "Customized Rails prompt by AKI") do |context, nesting, pry_instance, sep|
  format(
    '%<app>s[%<env>s]%<context>s:%<in_count>s %<nesting>s%<separator>s ',
    app: app_prompt,
    env: env_prompt,
    nesting: (nesting.positive? ? ":#{nesting}": ''),
    separator: sep,
    context: (context == 'main' ? '' : context),
    in_count: pry_instance.input_ring.count
  )
end


if defined?(::Rails)
  Pry.config.prompt = Pry::Prompt[:aki_rails][:value]
end
