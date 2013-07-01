# Gritter

Gritter is a graph database Twitter clone. It was built as a trial and demonstration of the [Neo4j](http://neo4j.org) graph database. I wanted to see how difficult
normal Rails development was using [Neo4j.rb](https://github.com/andreasronge/neo4j) as the primary database layer. **CONCLUSION: quite nice**

Users can sign up for accounts, login, post updates (grits), and follow other users. I tried to pick features that were interesting graph problems, as well as normal Rails stuff. I hadn't seen anyone do basic User auth/sessions, so I tried it.

I also setup the High Availability server. This let me use the normal Neo4j web console to try Cypher queries as I was learning the Ruby DSL, as well as have a normal Rails Console running. It was a little extra work, but worth it.

#### Seeing is Believing

[![Grits](http://i.imgur.com/Mywn4ccs.png)](http://imgur.com/Mywn4cc.png)
[![Recommended Users](http://i.imgur.com/SFCRuqws.png)](http://imgur.com/SFCRuqw.png)

I didn't style all the pages, but threw up something basic to get the point across.

## Getting Started

So you'd like to fire it up yourself, eh? Great! Let's do this.

```bash
git clone git@github.com:saterus/gritter.git   # or your personal fork
cd gritter

rvm install jruby-1.7.4
rvm use --create jruby-1.7.4@gritter           # or rbenv, your choice
bundle install

rake neo4j:install[enterprise,1.9.1]           # use neography's install tasks to grab enterprise jar
rm -rf neo4j-enterprise-1.9.1                  # delete the redundant one (not sure why it downloads twice)
cd neo4j
mv neo4j-enterprise-1.9.1/* .                  # avoid overriding HA conf files
rm -rf neo4j-enterprise-1.9.1
cd ..

neo4j/bin/neo4j start                          # start Neo4j High Availability server
be rake neo:seed                               # pre-fill database

be rails server
```

*If these instructions don't work for you, please let me know so I can fix them!*

Point your browser to `localhost:3000` and Sign Up for an account. I recommend following a few people. Woo Twitter clone!

*Note: as you can tell, some of the setup for this is a little wonky. I'd love to know what would be easier. \*cough\**


## Code

The important stuff is in the normal Rails places. I recommend looking through models/controllers. The views are kinda messy.

#### Pros

The [Neo4j.rb](https://github.com/andreasronge/neo4j) library was quite nice. It generally worked as expected. Any places it didn't, I was able to figure out out (it works quite sensically) and then update the documentation on their wiki.

Modeling everything as Nodes and Relationships was great. It is much easier conceptually than worrying about join tables for everything. Setting up my models was a breeze. Rails worked right away. Getting stuff up on the page was quite simple.

The Cypher DSL was nice once I figured out a couple of the quirks. These read better to me than complex ActiveRecord queries. The most complex query was for [`Users#get_recommended_users`](https://github.com/saterus/gritter/blob/master/app/models/user.rb#L23] and it worked wonderfully.

#### Cons

I am not really happy with the way I am forced to check for uniqueness of the Following relationships in the UsersController. I'd rather have that handled by Neo4j. Also, the lack of Cypher UNION in `neo4j-cypher` makes the "timeline" code a little messier than I'd like it to be. I'd also like a better solution for pagination across the whole app.

## Questions/Comments

You can find me on (real) [Twitter](http://twitter.com/Saterus). I'm also trying to watch the [Neo4j.rb mailing list](http://groups.google.com/group/neo4jrb)
and the [#neo4j IRC channel](http://webchat.freenode.net/?channels=neo4j) on a regular basis.

## Contributions

Fork it. Open issues. Send pull requests. This is a demo, so any input is welcome. This was all repl-driven-development, there are no tests. \*shrug\*

## License

MIT/BSD/Apache. This is just a demo, so, whatever. I'm open to a strong opinion.
