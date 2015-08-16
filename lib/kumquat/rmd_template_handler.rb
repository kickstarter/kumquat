class RMarkdownTemplateHandler
  class_attribute :default_format
  self.default_format = Mime::HTML

  def call(template)
    k = Knit2HTML.new(Rails.root.join(template.inspect))
    k.knit.inspect + '.html_safe'
  end
end

ActionView::Template.register_template_handler(:Rmd, RMarkdownTemplateHandler.new)
