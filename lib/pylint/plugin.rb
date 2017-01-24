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

    attr_writer :base_dir

    def base_dir
      @base_dir || "."
    end

    def lint
        errors = run_pylint
        print_markdown_table(errors)
    end

    def run_pylint
        command = "pylint #{base_dir}"
        command << " --output-format=json"
      `#{command}`.split("\n")
    end

    def print_markdown_table(errors=[])

        #report = errors.inject(MARKDOWN_TEMPLATE) do |out, error_line|
        #     file, line, column, reason = error_line.split(":")
        #    out += "| #{short_link(file, line)} | #{line} | #{column} | #{reason.strip.gsub("'", "`")} |\n"
        #end
        markdown(errors)
    end
  end
end
