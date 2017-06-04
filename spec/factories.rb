FactoryGirl.define do
  factory :user do
    name "Yolanda"
    email "random@hello.com"
  end

  factory :competition do
  end

  factory :bot do
    name "Awesome bot"
    code {"class Player; def next_turn; #{['p','r','s'].sample}; end; end;"}
    user
  end

  factory :match_score do
    association :player_1, factory: :bot
    association :player_2, factory: :bot
    player_1_score 0
    player_2_score 0
    draws
    competition
  end
end