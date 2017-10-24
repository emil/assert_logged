module LogCapture

  module Assertions

    # The result of capturing:
    attr_accessor :captured_lines

    # checks the test_xxx.log files
    # records the number of lines in the log file before and after the action being
    # performed, then use tail to grab the last n lines logged
    def assert_logged(targets, log_level = nil, match = true, &block)
      
      self.captured_lines = capture_log_lines(log_file_name, &block)

      log_level_str = LOG4R_LEVELS[log_level] || 'All'

      restrict_to_log_level!(log_level_str)

      if match
        assert !captured_lines.blank?, "Should have logged some message at given level #{log_level_str}"
      else
        return if captured_lines.blank?
      end

      build_regexes(targets).each do |regex|
        matches = captured_lines.detect {|msg| msg =~ regex }
        if match
          assert matches, "A log entry should have matched the regular expression #{regex} at the given level: #{log_level_str} in file #{log_file_name}}"
        else
          assert !matches, "No log entry should have matched the regular expression #{regex} at the given level: #{log_level_str}. in file #{log_file_name}}"
        end
      end

      return captured_lines
    end

    # just the opposite of assert_logged
    def assert_not_logged(targets, log_level = nil, &block)
      assert_logged(targets, log_level, false, &block)
    end

    private

    LOG4R_LEVELS = { 1 => "DEBUG" , 2 => "INFO", 3 => "AUDIT", 4 => "WARN", 5 => "ERROR" }.freeze unless defined?(LOG4R_LEVELS)

    def log_file_name
      @__log_file_nmame ||= "#{Rails.root}/log/test_#{Time.now.strftime("%Y%m%d")}.log"
    end

    def capture_log_lines(log_file_name, &block)
      assert File.exist? log_file_name
      # lines before the test
      start_lines = `wc -l #{log_file_name}`

      yield block
      # lines after the test
      end_lines = `wc -l #{log_file_name}`

      assert !start_lines.nil? && !end_lines.nil?, "Unable to find log file at #{log_file_name}"
      # calculate 'tail' arguments
      start_lines = start_lines.strip.split(/\s/)[0].to_i
      end_lines = end_lines.strip.split(/\s/)[0].to_i

      `tail -n #{end_lines - start_lines} #{log_file_name}`.split(/\n/)
    end

    def restrict_to_log_level!(log_level_name)
      return if log_level_name.blank? || log_level_name == "All"
      expected_log_str = log_level_name + ":"

      captured_lines.select! {|x|
        tokens = x.split(/\s/)[3..4]
        tokens && tokens.include?(expected_log_str)
      }
    end

    def build_regexes(targets)
      regexes = [] << targets # in case we get a non-array (single string/regex)
      regexes.flatten!
      regexes.map! {|regex| regex.is_a?(String) ? /#{Regexp.escape(regex)}/m : regex}
    end

  end
end
