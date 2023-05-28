# frozen_string_literal: true

require "money"

Money.default_currency = Money::Currency.new("AUD")
Money.rounding_mode = BigDecimal::ROUND_HALF_UP
I18n.config.available_locales = :en
Money.locale_backend = :i18n
I18n.locale = :en
