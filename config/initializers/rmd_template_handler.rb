module ActionView
  module Template::Handlers
    class RMarkdown
      class_attribute :default_format
      self.default_format = Mime::HTML

      def call(template)
        k = Kumquat::Knit2HTML.new(Rails.root.join(template.inspect))
        k.knit.inspect + '.html_safe'
      end
    end
  end
end

ActionView::Template.register_template_handler(:Rmd, ActionView::Template::Handlers::RMarkdown.new)
