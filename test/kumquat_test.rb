require 'minitest/autorun'
require 'test_helper'

class KumquatTest < Minitest::Test
  def test_truth
    assert_kind_of Module, Kumquat
  end

  def test_knit2html
    assert_kind_of Class, Knit2HTML
  end

  def test_knitr_call
    template = "app/reports/test_report.Rmd"
    k = Knit2HTML.new(Rails.root.join(template.inspect))
    output = k.knit
    assert_equal(output.scan(/simple_math_true: (.+)/).flatten.first, "TRUE")
    assert_equal(output.scan(/simple_math_false: (.+)/).flatten.first, "FALSE")
  end

end

