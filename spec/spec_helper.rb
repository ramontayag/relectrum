require "relectrum"
require "rspec"
require "pry"
require "yaml"

SPEC_DIR = File.expand_path(File.dirname(__FILE__), "..")
CONFIG = YAML.load_file(File.join(SPEC_DIR, "config.yml")).
  with_indifferent_access

RSpec.configure do |c|
  c.order = "random"
end
