require_relative "gemplate/version"

module Gemplate

  class << self
    def inspect
      "Gemplate #{Gemplate::VERSION} on #{Gemplate::RELEASE_DATE}"
    end
  end

end
