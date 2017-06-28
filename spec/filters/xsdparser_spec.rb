# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/xsdparser"

describe LogStash::Filters::XsdParser do
  describe "Set to Hello World" do
    let(:config) do <<-CONFIG
      filter {
        xsdparser {
        }
      }
    CONFIG
    end

  end
end
