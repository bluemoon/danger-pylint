require 'json'

module Danger
  # This is your plugin class. Any attributes or methods you expose here will
  # be available from within your Dangerfile.
  #
  # To be published on the Danger plugins site, you will need to have
  # the public interface documented. Danger uses [YARD](http://yardoc.org/)
  # for generating documentation from your plugin source, and you can verify
  # by running `danger plugins lint` or `bundle exec rake spec`.
  #
  # You should replace these comments with a public description of your library.
  #
  # @example Ensure people are well warned about merging on Mondays
  #
  #          my_plugin.warn_on_mondays
  #
  # @see  Bradford Toney/danger-pylint
  # @tags monday, weekends, time, rattata
  #
  class DangerPylint < Plugin
    MARKDOWN_TEMPLATE = ""\
      "## DangerPylint found issues\n\n"\
      "| File | Line | Column | Reason |\n"\
      "|------|------|--------|--------|\n"\

    # @return   [Array<String>]
    attr_accessor :warnings
    # @return   [Array<String>]
    attr_accessor :errors

    def lint(dir=".")
        errors = run_pylint(dir)
        print_markdown_table(errors)
    end

    def run_pylint(dir)
        command = "pylint #{dir}"
        command << " --output-format=json"
        `#{command}`.split("\n").join("")
    end

    def print_markdown_table(errors)
        message(errors)
        data = JSON.parse(errors)
        report = data.inject(MARKDOWN_TEMPLATE) do |out, error_line|
            file = error_line['path']
            line = error_line['line']
            column = error_line['column']
            reason = error_line['msg_id']
            out += "| #{short_link(file, line)} | #{line} | #{column} | #{reason.strip.gsub("'", "`")} |\n"
        end

        markdown(report)
    end

    def short_link(file, line)
        if danger.scm_provider.to_s == "github"
            return github.html_link("#{file}#L#{line}", full_path: false)
        end

        file
    end
  end
end
