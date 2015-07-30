require "replicator/version"

module Replicator
  @visited = []

  def self.replicate(object)
    return object if @visited.include? object.object_id

    @visited << object.object_id unless object.class == Array

    replica = object.clone

    if object.class == Array
      replica = object.map do |element|
        replicate(element)
      end
    else
      object.instance_variables.each do |iv|
        oiv = object.instance_variable_get(iv)
        cloned_oiv = replicate(oiv)
        replica.instance_variable_set(iv, cloned_oiv)
      end
    end

    replica
  end

end
