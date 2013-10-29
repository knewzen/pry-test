require File.join(File.dirname(__FILE__), "base_formatter")

module MicroTest
  class DefaultFormatter < MicroTest::BaseFormatter
    set_short_name "default"

    def before_class(test_class)
      puts
      puts test_class.name.ljust(80, "-")
    end

    def after_test(test)
      duration = (test.duration * 10**4).round.to_f / 10**4
      color = duration < 0.01 ? :yellow : :red
      print send(color, "  #{duration.to_s.ljust(6, "0")}")

      if test.passed?
        print green(" #{test.desc}")
      else
        print_test_failure test
      end

      puts
    end

    def after_suite(test_classes)
      puts
      puts "".ljust(80, "-")
      print " #{passed + failed} Tests finished in #{yellow duration} seconds. "
      totals = []
      totals << green("#{passed} Passed") if passed > 0
      totals << red("#{failed} Failed") if failed > 0
      print "(#{totals.join(", ")})"
      puts
      puts
    end

    private

    def print_test_failure(test)
      puts red(" #{test.desc}")
      test.failed_asserts.each do |assert|
        print_assert_failure assert
      end
    end

    def print_assert_failure(assert)
      puts
      print "".ljust(9)
      puts "#{assert[:file_path]}:#{red(assert[:line_num])}"
      puts "".ljust(9) + "".rjust(71, "-")
      index = assert[:line_num] - 1
      start = index - 2
      start = 0 if start <= 0
      finish = index + 2
      finish = assert[:lines].length - 1 if finish >= assert[:lines].length
      print_assert_failure_lines assert, start, finish
    end

    def print_assert_failure_lines(assert, start, finish)
      (start..finish).each do |i|
        print "".ljust(9)
        if i == index
          print red((i + 1).to_s.rjust(3, "0"))
          print red("|")
          print red(assert[:lines][i])
        else
          print (i + 1).to_s.rjust(3, "0")
          print "|"
          print assert[:lines][i]
        end
      end
    end

  end
end
