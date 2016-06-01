module Pod
  module Generator
    class Plist < Acknowledgements
      def self.path_from_basepath(path)
        Pathname.new(path.dirname + "#{path.basename}.plist")
      end

      def save_as(path)
        Xcodeproj::Plist.write_to_path(plist, path)
      end

      def plist
        {
          :Title => plist_title,
          :StringsTable => plist_title,
          :PreferenceSpecifiers => licenses,
        }
      end

      def plist_title
        'Acknowledgements'
      end

      def licenses
        licences_array = [header_hash]
        specs.each do |spec|
          if (hash = hash_for_spec(spec))
            licences_array << hash
          end
        end
        licences_array << footnote_hash
      end

      def hash_for_spec(spec)
        if (license = license_text(spec))
          {
            :Type => 'PSGroupSpecifier',
            :Title => sanitize_encoding(spec.name),
            :FooterText => sanitize_encoding(license),
            :License => spec.license[:type],
          }
        end
      end

      def header_hash
        {
          :Type => 'PSGroupSpecifier',
          :Title => sanitize_encoding(header_title),
          :FooterText => sanitize_encoding(header_text),
        }
      end

      def footnote_hash
        {
          :Type => 'PSGroupSpecifier',
          :Title => sanitize_encoding(footnote_title),
          :FooterText => sanitize_encoding(footnote_text),
        }
      end

      #-----------------------------------------------------------------------#

      private

      # !@group Private methods

      # Returns the sanitized text with UTF-8 invalid characters eliminated.
      #
      # @param  [String] text
      #         the text we want to sanitize.
      #
      # @return [String] The sanitized UTF-8 text.
      #
      def sanitize_encoding(text)
        text.encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '')
      end

      #-----------------------------------------------------------------------#
    end
  end
end
