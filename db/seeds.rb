# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

class DateTime
  def self.fake_time_from(start = 1.year.ago)
    start+(rand(24*7).hours)
  end
end

class Fake
  def self.user
    user = User.new do |u|
      u.username = Faker::Internet.domain_word
      u.name = Faker::Name.name
      u.bio = Faker::Lorem.paragraph(3)[0..250]
    end

    user.save

    user
  end

  def self.grit(user)
    user.grits.build(body: Faker::Lorem.paragraph(2)[0..139])
  end

  def self.full_user
    user = Fake.user
    user.save

    g = Fake.grit(user)
    user.save
    g.created_at = rand(24).hours.ago + rand(60).minutes
    user.latest_grit = g
    user.save

    grits_to_date = (rand(150)+10)
    while user.grits.count < grits_to_date
      g = Fake.grit(user)
      user.save
      g.previous = user.latest_grit
      g.created_at = g.previous.created_at - rand(3).days - rand(16).hours - rand(60).minutes
      user.latest_grit = g
      user.save
    end

    user
  end
end

def seed!
  40.times.map do
    u = Fake.full_user
    puts [u.username, u.grits.count]
    u
  end
end
