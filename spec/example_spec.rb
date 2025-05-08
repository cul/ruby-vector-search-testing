# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'An example spec' do # rubocop:disable RSpec/DescribeClass
  it 'performs a basic check' do
    expect(1).to eq(1) # rubocop:disable RSpec/ExpectActual
  end
end
