class Site
  attr_reader :pages, :navigations

  def initialize
    @pages = []
    @navigations = []
  end
end

class Page
  attr_reader :site, :widgets

  def initialize(site)
    @site = site
    @widgets = []
  end
end

class Navigation
  attr_reader :page, :link

  def initialize(page, link)
    @page = page
    @link = link
  end
end

module Widgets
  class Text
    attr_reader :body

    def initialize(body)
      @body = body
    end
  end

  class Menu
    attr_reader :navigation

    def initialize(navigation)
      @navigation = navigation
    end
  end
end
