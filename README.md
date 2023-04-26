# QnA

Проект QnA представляет собой учебный проект, который реализует основные функции популярного ресурса stackoverflow. Этот проект позволяет пользователям задавать вопросы, отвечать на них и оценивать ответы других пользователей.
Технологии


## Используемые технологии:

    Ruby on Rails 6
    PostgreSQL
    Slim
    Bootstrap 5
    TDD/BDD (RSpec, Capybara)
    Devise
    CanCanCan
    ActionCable
    ActiveJob, Sidekiq
    OAuth
    SphinxSearch
    
  
## Как запустить проект

Склонировать репозиторий:

      git clone https://github.com/NazarovSV/qna.git

Установить все зависимости с помощью команды:

      bundle install

Создать базу данных и выполнить миграции:

      bundle exec rails db:create
      bundle exec rails db:migrate

Запустить локальный сервер:

      bundle exec rails s

Открыть приложение в браузере по адресу http://localhost:3000.


## Как запустить тесты

Чтобы запустить тесты, необходимо выполнить команду:

      bundle exec rspec
    
