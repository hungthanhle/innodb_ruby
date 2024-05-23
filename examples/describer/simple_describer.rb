# frozen_string_literal: true

require "innodb/record_describer"

class SimpleDescriber < Innodb::RecordDescriber
  type :clustered
  key "i", :INT, :NOT_NULL
  row "s", "VARCHAR(100)", :NOT_NULL
end

class SimpleTDescriber < Innodb::RecordDescriber
  type :clustered
  key "i", :INT, :UNSIGNED, :NOT_NULL
end
