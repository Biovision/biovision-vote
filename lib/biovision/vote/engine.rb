module Biovision
  module Vote
    require 'biovision/base'

    class Engine < ::Rails::Engine
      config.assets.precompile << %w(biovision/vote/**/*)

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      end
    end
  end
end
