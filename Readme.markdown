```
████████╗██╗   ██╗██████╗ ██████╗  ██████╗ ████████╗
╚══██╔══╝██║   ██║██╔══██╗██╔══██╗██╔═══██╗╚══██╔══╝
   ██║   ██║   ██║██████╔╝██████╔╝██║   ██║   ██║
   ██║   ██║   ██║██╔══██╗██╔══██╗██║   ██║   ██║
   ██║   ╚██████╔╝██║  ██║██████╔╝╚██████╔╝   ██║
   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═════╝  ╚═════╝    ╚═╝
```


Turbot is a dating bot for the [Plenty of Fish](https://www.pof.com/) dating site.


Purpose
=======

For a long time I found the world of internet dating to be quite painful. I
sent out lots of messages and, regardless of how much effort I put in, received
very few responses. Ow! My soul!

The vast majority of the pain/time-wasting was in sending that first message. I
realised that this activity (sending the first message) is not complicated and
can be automated!  So I wrote a bot to do the job for me.

Being single can suck, but we can program ourselves out of this hole!

Setup
=====

Turbot is in a bit of a transitional period, moving from a single user console
app, to a multi user rails app. So the setup is not completely trivial.


**Set up the DB**

Copy `config/db_example.yml` to `config/db.yml`.

Create the databases and fill in the auth details.

**Run the database migrations**

```
bundle exec rake db:migrate
```

This will create the tables etc.

**Set up your POF user**

```
bundle exec irb -r ./lib/turbot
```

Now create your user:

```
User.create!(pof_username: 'your-pof-login', pof_password: 'your-password', name: 'your-name')
```

Note: Your name is used to sign the messages you send.

**Pull down your profile**

```
bundle exec rake bootstrap:setup_profile pof_profile_id=YOUR_ID
```

Replace `YOUR_ID` with the POF ID. To find this, go to your profile page and look at the number on the end of the url.

Example: `http://www.pof.com/viewprofile.aspx?profile_id=1234567`

**Create some topics**

Now the fun part. You can create some canned messages and rules to figure
out which profiles these can be sent to.

There is an interface for this coming soon, but for now you must do it via something like PhpMyAdmin or via the console:

```
bundle exec irb -r ./lib/autopof
```

Now create your first topic:

```
Topic.create!(name: "Biking",
             message: "Hi, I see you like biking, have you gone on any fun rides recently? ...",
             matchers: "biking\ncycling")
```

Read more about topics below and how they are matched to profiles, but the
short story is: The message in this Topic is a candidate to be sent to any
profile that is interested in biking/cycling.


Now you're ready to rock and roll baby!


Usage
=====

```
Usage: TURBOT_ENV=[env-name] ./bin/pof_session_runner.rb [options]

Required
    -u, --user-id       ID of user to act as

Optional
    -p, --search-pages  Number of 'Search pages' to extract & cache profiles from (default: 3)
    -m, --messages      Number of messages to send (default: 2)
    -d, --dry-run       Whether to do a dry run (no messages sent) (default: false)
    -h, --help          Display usage
```

Example:

```
TURBOT_ENV=production ./bin/pof_session_runner.rb --user-id=1 --search-pages=1 --messages=1
```


Topic Matching
==============

Coming soon


TODO
====

Make the message extractor handle messages from POF admins - they don't have a
profile, which goes against our assumptions.
