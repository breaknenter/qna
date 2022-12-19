ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes text
  indexes author.email, as: author, sortable: true

  has author_id, created_at, updated_at, commentable_id, commentable_type
end
