# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # Disallows the use of `unless` in all forms.
      # Use `if` with an inverse or negated condition instead.
      #
      # @example
      #   # bad
      #   do_something unless items.any?
      #   return unless value.present?
      #   return unless condition
      #
      #   # good
      #   do_something if items.none?
      #   return if value.blank?
      #   return if !condition
      class AvoidUnless < Base
        extend AutoCorrector

        MSG = "Avoid `unless`. Use `if` with an inverse or negated condition instead."

        INVERSE_METHODS = {
          any?: :none?,
          none?: :any?,
          present?: :blank?,
          blank?: :present?,
          empty?: :present?,
          even?: :odd?,
          odd?: :even?,
          zero?: :nonzero?,
          nonzero?: :zero?,
          true?: :false?,
          false?: :true?
        }.freeze

        INVERSE_METHODS_WITH_ARGS = {
          include?: :exclude?,
          exclude?: :include?
        }.freeze

        INVERSE_OPERATORS = {
          :== => :!=,
          :!= => :==,
          :> => :<=,
          :< => :>=,
          :>= => :<,
          :<= => :>,
          :=~ => :!~,
          :!~ => :=~
        }.freeze

        def on_if(node)
          return if !node.unless?

          add_offense(node) do |corrector|
            condition = node.condition
            replacement = inverted_condition(condition)
            corrector.replace(node.loc.keyword, "if")
            corrector.replace(condition, replacement)
          end
        end

        private

        def inverted_condition(node)
          case node.type
          when :send
            invert_send(node)
          when :begin
            # Parenthesized expression: (expr)
            inner = node.children.first
            "(#{inverted_condition(inner)})"
          when :or
            # De Morgan: !(a || b) => !a && !b
            lhs, rhs = *node
            "#{inverted_condition(lhs)} && #{inverted_condition(rhs)}"
          when :and
            # De Morgan: !(a && b) => !a || !b
            lhs, rhs = *node
            "#{inverted_condition(lhs)} || #{inverted_condition(rhs)}"
          else
            negate(node)
          end
        end

        def invert_send(node)
          receiver, method_name, *args = *node

          if method_name == :!
            # unless !x => if x
            return receiver.source
          end

          if (inverse = INVERSE_OPERATORS[method_name]) && args.size == 1
            return "#{receiver.source} #{inverse} #{args.first.source}"
          end

          if (inverse = INVERSE_METHODS[method_name]) && args.empty?
            receiver_source = receiver ? "#{receiver.source}." : ""
            return "#{receiver_source}#{inverse}"
          end

          if (inverse = INVERSE_METHODS_WITH_ARGS[method_name]) && args.any?
            receiver_source = receiver ? "#{receiver.source}." : ""
            args_source = args.map(&:source).join(", ")

            return "#{receiver_source}#{inverse}(#{args_source})"
          end

          negate(node)
        end

        def negate(node)
          if requires_parens_for_negation?(node)
            "!(#{node.source})"
          else
            "!#{node.source}"
          end
        end

        def requires_parens_for_negation?(node)
          node.or_type? || node.and_type?
        end
      end
    end
  end
end
