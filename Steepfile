# frozen_string_literal: true
# rbs_inline: enabled

D = Steep::Diagnostic

target :lib do
  signature 'sig'

  check 'lib'

  library 'bigdecimal'

  configure_code_diagnostics(D::Ruby.lenient)
end
