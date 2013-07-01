namespace :db do
  desc "Seed the database with Users, Grits, and Following Relationships."
  task :seed => [:environment] do
    require 'db/seeds'
    puts "Seeding!"
    seed!
  end

  desc "Clean out the database by deleting everything"
  task :nuke => [:environment] do
    print "Nuking Neo4j database from orbit! In...3..."
    sleep(1)
    print "2..."
    sleep(1)
    print "1..."
    sleep(1)
    puts ''

    User.destroy_all
    puts "Users gone!"
    Grit.destroy_all
    puts "Grits gone!"
    Credential.destroy_all
    puts "Creds gone!"
  end
end
