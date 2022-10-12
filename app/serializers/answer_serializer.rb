class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :author_id, :text, :links, :files, :created_at, :updated_at

  has_many :comments, if: -> { object.comments.present? }

  def files
    object.files.map do |file|
      { 'id'   => file.id,
        'name' => file.filename.to_s,
        'url'  => file.url }
    end
  end
end
