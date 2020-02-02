class UrlRecord < ApplicationRecord
  ALLOWED_CHARACTERS = [('A'..'Z').to_a, ('a'..'z').to_a, (0..9).to_a, '-', '.', '_', '~', ':', '/', '?', '#', '[', ']', '@', '!', '$', '&', '\'' '(', ')', '*', '+', ',', ';', '%', '=' ].flatten

  class << self
    def find_by_url(url)
      UrlRecord.where(path: url)
    end

    def find_by_shortened_url(shortened_url)
      UrlRecord.where(shortened_url: shortened_url)
    end

    def create_record(path)
      record = UrlRecord.create(path: path, num_visits: 0)
      byebug
      shortened_url = generate_custom_url(record&.id)
      record.update(shortened_url: shortened_url)
      record.save
      record
    end

    def redirect(url)
      UrlRecord.decode_url(url)
    end
  
    private

    def generate_custom_url(id)
      encoded = ''
      base = ALLOWED_CHARACTERS&.length
      while (id > 0)
        encoded << ALLOWED_CHARACTERS[id % base]
        id /= base
      end
      encoded.reverse
    end

    def decode_url(url)
      base = ALLOWED_CHARACTERS&.length
      id = 0
      url.each { |char| id = (id * base + ALLOWED_CHARACTERS&.index(char)) }
      id
    end
  end

  def increment_visit_statistics
    self.update(num_visits: self.num_visits + 1)
    self.save
  end
end