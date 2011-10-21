class Command < ActiveRecord::Base
  has_many :dependencies
  has_many :required_commands, :through => :dependencies
  serialize :options, Hash

  def self.default_options
    return {}
  end

  def command_name
    self.class.to_s[0..-8].downcase
  end

  def to_ruby(global_options = {})
    return script if script.any?

    option_array = []

    if (options || {}).any?
      option_array = options.collect do |key, value|
        ":#{key} => #{value.inspect}" if !value.empty?
      end
      option_array = [nil] + option_array.compact
    end

    spacing = ",\n" + (" " * (command_name.size + 1))

    result = "#{command_name} '#{name}'#{option_array.join(spacing)}\n"

    if (description || "").any?
      result = "# #{description}\n" + result
    end

    result
  end
end
