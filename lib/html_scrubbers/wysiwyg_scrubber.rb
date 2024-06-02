# frozen_string_literal: true

# This is a custom Rails::Html::PermitScrubber that removes the entire node and its contents
# rather than the default behavior of just removing the tags and leaving the contents there.
module HtmlScrubbers
  class WysiwygScrubber < Rails::Html::PermitScrubber
    def initialize
      super
      self.attributes = %w[href title src style name id target rel class]
      self.tags = tags
    end

    def scrub_node(node)
      unless microsoft_node?(node.children)
        node.before(node.children) # strip only the surrounding node and leave the children.
      end

      node.remove
    end

    def scrub_attribute(node, attr_node) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      attr_name =
        if attr_node.namespace
          "#{attr_node.namespace.prefix}:#{attr_node.node_name}"
        else
          attr_node.node_name
        end

      if Loofah::HTML5::SafeList::ATTR_VAL_IS_URI.include?(attr_name)
        # this block lifted nearly verbatim from HTML5 sanitization
        val_unescaped =
          CGI
            .unescapeHTML(attr_node.value)
            .gsub(Loofah::HTML5::Scrub::CONTROL_CHARACTERS, "")
            .downcase
        url_parts = val_unescaped.split(Loofah::HTML5::SafeList::PROTOCOL_SEPARATOR)

        # URL parts should only have two parts. If there's more,
        # remove the attribute because there's an extra colon.
        if url_parts.size > 2
          scrub_node(node)
        elsif url_parts.size == 2
          # Check the validity of the address itself.
          address = url_parts[1]
          scrub_node(node) unless address.match?(%r{\A(http(s)?://|mailto:)}i)
        end

        # Check the protocol used and its validity.
        # Regex is checking for pattern string + ":", i.e. https:, http:, etc..
        attr_node.remove if val_unescaped =~ /^[a-z0-9][-+.a-z0-9]*:/ && !protocol_allowed?(url_parts[0])
      end

      if Loofah::HTML5::SafeList::SVG_ATTR_VAL_ALLOWS_REF.include?(attr_name) && attr_node.value
        attr_node.value = attr_node.value.gsub(/url\s*\(\s*[^#\s][^)]+?\)/m, " ")
      end

      if Loofah::HTML5::SafeList::SVG_ALLOW_LOCAL_HREF.include?(node.name) &&
           attr_name == "xlink:href" && attr_node.value =~ /^\s*[^#\s].*/m
        attr_node.remove
      end

      node.remove_attribute(attr_node.name) if attr_name == "src" && attr_node.value.match?(/[^[:space:]]/)

      Loofah::HTML5::Scrub.force_correct_attribute_escaping! node
    end

    private

    def protocol_allowed?(protocol)
      Loofah::HTML5::SafeList::ALLOWED_PROTOCOLS.include?(protocol)
    end

    # If the child has 'mso' text it means it's coming from a microsoft file.
    def microsoft_node?(child_node)
      child_node.to_s.include?("mso")
    end

    def tags # rubocop:disable Metrics/MethodLength
      %w[
        a
        acronym
        b
        strong
        i
        u
        em
        li
        ul
        ol
        h1
        h2
        h3
        h4
        h5
        h6
        blockquote
        br
        cite
        sub
        sup
        ins
        p
        div
        span
        table
        thead
        tbody
        tr
        td
        img
        iframe
        strike
      ]
    end
  end
end
