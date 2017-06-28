# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

require 'json'
require 'crack'

# This  filter will replace the contents of the default 
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an .
class LogStash::Filters::XsdParser < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #    {
  #     message => "My message..."
  #   }
  # }
  #
  def parse_xml (xmldata)
        newData= xmldata.
                   gsub("<m:NOOP xmlns:m=\"NOOP\">", "").
                   gsub("<\/m:NOOP>", "").
                   gsub("<m:NOOP>", "").
                   gsub("xsi:type=\"xsd:string\"" , "").
                   gsub("xsi:type=\"xsd:int\"","")

        
        xml= Crack::XML.parse(newData)
        
        k,v =xml.first
        envelope= xml[k]
        k1,v1 =envelope.first
        #puts k1, v1
        body = envelope[k1]
        
        k2,v2 = body.first
        result=body
        if k2 == 'return' 
              result =body[k2] 
        end
        
       return result
        
end
  
  config_name "xsdparser"
  
  # Replace the message with this value.
  config :message, :validate => :string, :default => "Hello World!"
  

  public
  def register
    # Add instance variables 
  end # def register

  public
  def filter(event)

        return unless filter?(event)
        xmldata =event.get("xmldata")
        
        parsedXml= parse_xml(xmldata)
        event.set("parsed_xml",parsedXml)
          # filter_matched should go in the last line of our successful code
        filter_matched(event)
  end # def filter
end # class LogStash::Filters::XsdParser
