require 'spec_helper'
require "awesome_example_classes"

describe Replicator do

  before(:all) do
    @s = Site.new
    p1 = Page.new(@s)
    @s.pages << p1
    p2 = Page.new(@s)
    @s.pages << p2

    n1 = Navigation.new(p1, 'n1')
    @s.navigations << n1
    n2 = Navigation.new(p2, 'n2')
    @s.navigations << n2

    wt1 = Widgets::Text.new('wt1')
    p1.widgets << wt1
    wm1 = Widgets::Menu.new(n1)
    p1.widgets << wm1

    wt2 = Widgets::Text.new('wt2')
    p1.widgets << wt2
    wm2 = Widgets::Menu.new(n2)
    p1.widgets << wm2
  end

  it 'has a version number' do
    expect(Replicator::VERSION).not_to be nil
  end

  context "#replicate" do
    it 'should create a deep copy of an object' do
      expect(@s).to ob_eq(Replicator::replicate(@s))
    end
  end

end

# expect(@s).to eql(@replicated) doesn't do the job ->
# incorreclty assumes the hashes should be the same
RSpec::Matchers.define :ob_eq do |expected|
  match do |actual|

    # calling the matcher recursively will return a matcher as a result
    # => what we want is a boolean
    # => extract into a function
    ob_eq_fn(actual, expected, [])

  end

  failure_message do |actual|
    "expected that #{actual} would be a the same as #{expected}"
  end
end

def ob_eq_fn(source, replica, visited)

  # we already checked if this two objects are identical -> move on
  return true if visited.include? source.object_id

  # mark object as visited
  visited << source.object_id

  # don't do complex checks for string objects
  return source == replica if source.class == String

  # the class should be the same, meaning it has the same methods/behaviour
  return source.class == replica.class &&
  # the hashes should be different, meaning the instances are different
  source.hash != replica.hash &&
  # the instance variables should be the same number
  source.instance_variables.count == replica.instance_variables.count &&

  # we can now check if instance variables are the same
  # recursively check if all instance variables are replicated (and their
  # instance variables, and so on...)
  source.instance_variables.map do |iv|

    siv = source.instance_variable_get(iv)
    riv = replica.instance_variable_get(iv)

    # if an instance variable is a collection -> check individual iv
    if siv.class == Array
      siv.zip(riv).map do |ivs|
        ob_eq_fn(ivs[0], ivs[1], visited)
      end.reduce(true) { |memo, new| memo && new }
    else
      ob_eq_fn(source.instance_variable_get(iv), replica.instance_variable_get(iv), visited)
    end

  end.reduce(true) { |memo, new| memo && new }

end
