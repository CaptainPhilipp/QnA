ThinkingSphinx::Index.define :user, delta: true, with: :active_record do
  indexes email, sortable: true

  has created_at, updated_at
end
