# rubocop-avoid_unless

A [RuboCop](https://rubocop.org/) extension that bans `unless` in favor of `if` with an inverse or negated condition. It provides a single cop, `Style/AvoidUnless`, with full auto-correction support.

## Why

`unless` can harm readability, especially with compound or negated conditions (`unless !done?`, `unless x && y`). This cop enforces a consistent `if`-only style across your codebase.

## Installation

Add the gem to your `Gemfile` or gemspec:

```ruby
gem "rubocop-avoid_unless"
```

Then run `bundle install`.

## Setup

### With Standard Ruby

If you use [Standard Ruby](https://github.com/standardrb/standard), add the plugin to your `.standard.yml`:

```yaml
plugins:
  - rubocop-avoid_unless
```

Standard will load the cop automatically via the `lint_roller` plugin system. No other configuration is needed.

### With RuboCop directly

If you use RuboCop without Standard, there are two options:

**Option A** - Use the `lint_roller` plugin system (RuboCop 1.72+). Add to your `.rubocop.yml`:

```yaml
plugins:
  - rubocop-avoid_unless
```

**Option B** - Use the traditional `require` approach. Add to your `.rubocop.yml`:

```yaml
require:
  - rubocop-avoid_unless
```

## Configuration

The cop is enabled by default once loaded. To disable or customize it, add to your `.rubocop.yml`:

```yaml
Style/AvoidUnless:
  Enabled: false
```

## How it works

The cop flags every use of `unless` (both modifier and block forms) and auto-corrects to `if` by inverting the condition:

```ruby
# bad
do_something unless items.any?
return unless value.present?
return unless condition

# good (auto-corrected)
do_something if items.none?
return if value.blank?
return if !condition
```

It handles:

- **Inverse methods** - `any?`/`none?`, `present?`/`blank?`, `include?`/`exclude?`, `even?`/`odd?`, etc.
- **Inverse operators** - `==`/`!=`, `>`/`<=`, `=~`/`!~`, etc.
- **Double negation removal** - `unless !x` becomes `if x`
- **De Morgan's law** - `unless a && b` becomes `if !a || !b`

## Requirements

- Ruby >= 3.2
- RuboCop >= 1.72

## License

MIT
