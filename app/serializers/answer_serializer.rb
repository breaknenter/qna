class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :author_id, :text, :created_at, :updated_at

  def author_id
    object.author_id
  end
end
