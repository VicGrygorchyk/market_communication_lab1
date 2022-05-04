# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'json'

def read_json(file_path)
    File.open(file_path, "r+") do |json_file|
        json_ = json_file.read
        parsed = JSON.parse(json_)
        parsed
     end
end

def seed_question_n_answers
    file_path = 'questions.json'
    puts "Seeding #{file_path}."
    json_ = read_json(file_path)
    Question.delete_all
    Answer.delete_all
    Result.delete_all
    QuestionToAnswer.delete_all
    json_.each do |question|
        q_id = nil
        ans_ids = []
        # for question
        data = {
            text: question["question"],
        }
        inv = Question.create(data)
        q_id = inv.id
        
        # for answers
        question["answers"].each do |answer|
            data = {
                text: answer["answer"],
                score: answer["score"]
            }
            inv_ans = Answer.create(data)  
            ans_ids.push(inv_ans.id) 
        end

        ans_ids.each do |id|
            data = {
                question_id: q_id,
                answer_id: id
            }
            puts data
            res = QuestionToAnswer.create(data)
            puts res.id
        end
    end
    puts "Seeding #{file_path} done."
end

def seed_results
    file_path = 'results.json'
    puts "Seeding #{file_path}."
    json_ = read_json(file_path)
    Result.delete_all
    json_.each do |result|
        data = {
            text: result["text"],
            min: result["min"],
            max: result["max"]
        }
        inv = Result.create(data) 
    end
    puts "Seeding #{file_path} done."
end

seed_question_n_answers
seed_results
