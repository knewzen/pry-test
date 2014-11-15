require_relative "base_formatter"

module MicroTest
  class DefaultAsyncFormatter < MicroTest::BaseFormatter
    set_short_name "default_async"

    def after_test(test)
      render_inline "default_async/test", test
    end

    def after_suite(test_classes)
      puts
      test_classes.each do |test_class|
        render_output_for_test_class test_class
      end
    #  puts
    #  puts "".ljust(80, "-")
    #  print " #{passed + failed} Tests finished in #{yellow duration} seconds. "
    #  totals = []
    #  totals << green("#{passed} Passed") if passed > 0
    #  totals << red("#{failed} Failed") if failed > 0
    #  print "(#{totals.join(", ")})"
    #  puts
    #  puts
    end

    private

    def render_output_for_test_class(test_class)
      render "default/class", test_class
      test_class.tests.each do |test|
        render_output_for_test test
      end
    end

    def render_output_for_test(test)
      return unless test.finished?

      if test.passed?
        render "default/test_pass", test
      else
        render "default/test_fail", test
      end
    end

  end
end
