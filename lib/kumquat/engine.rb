module Kumquat
  class Engine < ::Rails::Engine
    isolate_namespace Kumquat

    REPORTS_PATH        = "app/reports"

    initializer :kumquat_logger do
      Kumquat.logger = Logger.new(Rails.root.join('log', "kumquat.log"))
    end

    initializer :rmd_template_handler do
      ActionView::Template.register_template_handler(:Rmd, RmdTemplateHandler.new)
    end

    initializer :register_report_interceptor do
      ActionMailer::Base.register_interceptor(KumquatReportInterceptor)
    end

  end
end
