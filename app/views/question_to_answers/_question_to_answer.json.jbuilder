json.extract! question_to_answer, :id, :question_id, :answer_id, :created_at, :updated_at
json.url question_to_answer_url(question_to_answer, format: :json)
