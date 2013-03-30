module SitePrism
  class Page
    include Capybara::DSL
    include ElementChecker
    extend ElementContainer

    def load
      raise SitePrism::NoUrlForPage if url.nil?
      visit url
    end

    def displayed?
      raise SitePrism::NoUrlMatcherForPage if url_matcher.nil?
      !(page.current_url.match(url_matcher)).nil?
    end

    def self.set_url page_url = nil
      if block_given?
        @url = Proc.new
      else
        @url = page_url
      end
    end

    def self.set_url_matcher page_url_matcher = nil
      if block_given?
        @url_matcher = Proc.new
      else
        @url_matcher = page_url_matcher
      end
    end

    def self.url
      @url
    end

    def self.url_matcher
      @url_matcher
    end

    def url
      if self.class.url.respond_to?(:call)
        instance_eval(&self.class.url)
      else
        self.class.url
      end
    end

    def url_matcher
      if self.class.url_matcher.respond_to?(:call)
        instance_eval(&self.class.url_matcher)
      else
        self.class.url_matcher
      end
    end

    def secure?
      !current_url.match(/^https/).nil?
    end

    def title
      title_selector = 'html > head > title'
      using_wait_time(0) { page.find(title_selector).text if page.has_selector?(title_selector) }
    end

    private

    def find_first *find_args
      first *find_args
    end

    def find_all *find_args
      all *find_args
    end

    def element_exists? *find_args
      has_selector? *find_args
    end
  end
end

