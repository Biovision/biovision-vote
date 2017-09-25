Biovision::Vote
===============

Модуль голосования для приложений на базе `biovision-base`.

Используйте на свой страх и риск без каких-либо гарантий.

Использование
-------------

Для возможности голосовать за модель у неё должны быть поля такого вида:

```ruby
class AddVotableToModels < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :upvote_count, :integer, default: 0, null: false
    add_column :posts, :downvote_count, :integer, default: 0, null: false
    add_column :posts, :vote_result, :integer, default: 0, null: false
  end
end
```

Функционал примешивается через `include VotableItem`.

По умолчанию голосовать за сущности могут только авторизованные пользователи.
Допустимость голосования определяется методом `VotableItem#votable_by?`, который
можно переопределить в моделях, если требуется.

Чтобы заработал фронт, нужно в `application.js` добавить это:

```javascript
//= require biovision/vote/biovision-vote.js
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'biovision-vote'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install biovision-vote
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
