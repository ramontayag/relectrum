require "relectrum"
require "rspec"
require "pry"
require "yaml"
require "dedent"

SPEC_DIR = File.expand_path(File.dirname(__FILE__), "..")
CONFIG = YAML.load_file(File.join(SPEC_DIR, "config.yml")).
  with_indifferent_access

RSpec.configure do |c|
  c.before(:each) do
    Relectrum.configure do |conf|
      conf.electrum_path = CONFIG[:electrum_path]
      conf.sx_path = CONFIG[:sx_path]
    end
  end

  c.order = "random"
end
