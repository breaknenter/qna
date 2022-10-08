class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :links, :files

  has_many :comments, if: -> { object.comments.present? }

  def files
    object.files.map do |file|
      { 'id'   => file.id,
        'name' => file.filename.to_s,
        'url'  => file.url }
    end
  end
end
