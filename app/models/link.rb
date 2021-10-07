class Link < ApplicationRecord
  belongs_to :question

  validates :name, :url, presence: true
  validates :url, format: { with:    URI::DEFAULT_PARSER.make_regexp(%w[http https]),
                            message: 'Invalid URL format' }
end
