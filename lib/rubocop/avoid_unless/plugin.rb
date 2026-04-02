# frozen_string_literal: true

require "lint_roller"

module RuboCop
  module AvoidUnless
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: "rubocop-avoid_unless",
          version: VERSION,
          homepage: "https://github.com/endoze/rubocop-avoid_unless"
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(context)
        LintRoller::Rules.new(
          type: :path,
          config_format: :rubocop,
          value: File.join(__dir__, "..", "..", "..", "config", "default.yml")
        )
      end
    end
  end
end
