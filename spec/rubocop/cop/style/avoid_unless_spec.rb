# frozen_string_literal: true

require "spec_helper"

RSpec.describe RuboCop::Cop::Style::AvoidUnless do
  subject(:cop) { described_class.new }

  it "registers an offense for unless modifier" do
    expect_offense(<<~RUBY)
      do_something unless condition
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Style/AvoidUnless: Avoid `unless`. Use `if` with an inverse or negated condition instead.
    RUBY

    expect_correction(<<~RUBY)
      do_something if !condition
    RUBY
  end

  it "registers an offense for unless block" do
    expect_offense(<<~RUBY)
      unless condition
      ^^^^^^^^^^^^^^^^ Style/AvoidUnless: Avoid `unless`. Use `if` with an inverse or negated condition instead.
        do_something
      end
    RUBY

    expect_correction(<<~RUBY)
      if !condition
        do_something
      end
    RUBY
  end

  it "corrects any? to none?" do
    expect_offense(<<~RUBY)
      do_something unless items.any?
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Style/AvoidUnless: Avoid `unless`. Use `if` with an inverse or negated condition instead.
    RUBY

    expect_correction(<<~RUBY)
      do_something if items.none?
    RUBY
  end

  it "corrects present? to blank?" do
    expect_offense(<<~RUBY)
      return unless value.present?
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Style/AvoidUnless: Avoid `unless`. Use `if` with an inverse or negated condition instead.
    RUBY

    expect_correction(<<~RUBY)
      return if value.blank?
    RUBY
  end

  it "corrects double negation" do
    expect_offense(<<~RUBY)
      do_something unless !condition
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Style/AvoidUnless: Avoid `unless`. Use `if` with an inverse or negated condition instead.
    RUBY

    expect_correction(<<~RUBY)
      do_something if condition
    RUBY
  end

  it "corrects == to !=" do
    expect_offense(<<~RUBY)
      do_something unless x == 1
      ^^^^^^^^^^^^^^^^^^^^^^^^^^ Style/AvoidUnless: Avoid `unless`. Use `if` with an inverse or negated condition instead.
    RUBY

    expect_correction(<<~RUBY)
      do_something if x != 1
    RUBY
  end

  it "corrects > to <=" do
    expect_offense(<<~RUBY)
      do_something unless x > 1
      ^^^^^^^^^^^^^^^^^^^^^^^^^ Style/AvoidUnless: Avoid `unless`. Use `if` with an inverse or negated condition instead.
    RUBY

    expect_correction(<<~RUBY)
      do_something if x <= 1
    RUBY
  end

  it "corrects include? to exclude?" do
    expect_offense(<<~RUBY)
      do_something unless list.include?(item)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Style/AvoidUnless: Avoid `unless`. Use `if` with an inverse or negated condition instead.
    RUBY

    expect_correction(<<~RUBY)
      do_something if list.exclude?(item)
    RUBY
  end

  it "applies De Morgan's law for ||" do
    expect_offense(<<~RUBY)
      do_something unless a || b
      ^^^^^^^^^^^^^^^^^^^^^^^^^^ Style/AvoidUnless: Avoid `unless`. Use `if` with an inverse or negated condition instead.
    RUBY

    expect_correction(<<~RUBY)
      do_something if !a && !b
    RUBY
  end

  it "applies De Morgan's law for &&" do
    expect_offense(<<~RUBY)
      do_something unless a && b
      ^^^^^^^^^^^^^^^^^^^^^^^^^^ Style/AvoidUnless: Avoid `unless`. Use `if` with an inverse or negated condition instead.
    RUBY

    expect_correction(<<~RUBY)
      do_something if !a || !b
    RUBY
  end

  it "does not register an offense for if" do
    expect_no_offenses(<<~RUBY)
      do_something if condition
    RUBY
  end
end
