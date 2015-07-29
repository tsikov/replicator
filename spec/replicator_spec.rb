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

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
