module Novaposhta
  module Parser
    class CloseParser < Nokogiri::XML::SAX::Document

      attr_reader :closes

      def initialize
        @closes = {}
        @current_close = {}
        @close_element = false
        @tag_content = ''
      end

      def start_element(name, attrs = [])
        return if name.downcase != "close" && !@close_element
        case name.downcase
          when "close"
            pattrs = parse_attr(attrs)
            @current_close = pattrs[:id]
            @close_element = true
        end
      end

      def characters(string)
        return if @tag_content.empty?
        @closes[@current_close] = string
        @tag_content = ''
      end

      def end_element(name)
        if name.downcase == "close"
          @close_element = false
        end
      end

      private
      def parse_attr(attrs = [])
        pattrs = {}
        attrs.each do |attr|
          if attr[0].downcase == "id"
            pattrs[:id] = attr[1]
          end
        end
        pattrs
      end
    end
  end
end
