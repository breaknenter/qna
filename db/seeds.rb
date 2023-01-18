# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = [
  { email: 'admin@qna.io', password: 'qwerty', admin: true },
  { email: 'fragnatic@mail.to', password: 'qwerty' },
  { email: 'polymorph@mail.to', password: 'qwerty' },
  { email: 'eliza@mail.to', password: 'qwerty' },
]

questions = [
  { title: 'Препроцессоры в Rails', text: 'Какой препроцессор выбрать: erb, haml или slim?' },
  { title: 'Аутентификация и авторизация', text: 'В чём между ними разница?' },
  { title: 'Rails консоль', text: 'Как запустить rails консоль в режиме песочницы?' },
  { title: 'Генерация модели в Rails', text: 'Как создать модель с заданными атрибутами?' }
]

for user in users do
  new_user = User.new(user)
  new_user.skip_confirmation!
  new_user.save!
end

question_author = User.second

for question in questions do
  new_question = Question.new(question)
  new_question.author = question_author
  new_question.save!
end
