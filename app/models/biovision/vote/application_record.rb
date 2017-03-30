module Biovision
  module Vote
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
