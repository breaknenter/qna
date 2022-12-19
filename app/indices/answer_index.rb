ThinkingSphinx::Index.define :answer, with: :active_record do
  indexes text
  indexes author.email, as: author, sortable: true

  has author_id, created_at, updated_at
end
