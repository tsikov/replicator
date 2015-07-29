require "replicator/version"

class Object
  module Replicator

    def replicate(options = {})
      Marshal.load(Marshal.dump(self)) if options.empty?
    end

  end

  include Replicator
end
