class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :short_title, :text, :created_at, :updated_at

  belongs_to :author

  has_many :answers, if: -> { object.answers.present? }

  def short_title
    object.title.truncate(7)
  end
end
