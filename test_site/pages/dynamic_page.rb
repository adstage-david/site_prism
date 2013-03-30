class TestDynamicPage < SitePrism::Page
  set_url {"/dynamic_page_#{@letter}.htm" }
  set_url_matcher { url }

  def initialize(letter)
    @letter = letter
  end
end

