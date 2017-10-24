json.extract! comment, :id, :bug_id, :text, :created_at, :updated_at
json.url comment_url(comment, format: :json)
