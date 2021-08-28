# frozen_string_literal: true

module Forms::Recordable
  extend ActiveSupport::Concern

  included do
    attr_accessor :oauth_application, :record, :watched_at
    attr_reader :instant, :rating, :share_to_twitter, :skip_to_share

    validates :body, length: {maximum: 1_048_596}
    validates :rating, allow_nil: true, inclusion: {in: Record::RATING_KINDS.map(&:to_s)}

    def body=(value)
      @body = value&.strip
    end

    def rating=(rating)
      @rating = rating&.downcase.presence
    end

    def share_to_twitter=(value)
      @share_to_twitter = ActiveModel::Type::Boolean.new.cast(value)
    end

    def instant=(value)
      @instant = ActiveModel::Type::Boolean.new.cast(value)
    end

    def skip_to_share=(value)
      @skip_to_share = ActiveModel::Type::Boolean.new.cast(value)
    end

    def body
      @body.presence || ""
    end

    # @overload
    def persisted?
      !record.nil?
    end

    def unique_id
      @unique_id ||= SecureRandom.uuid
    end
  end
end
