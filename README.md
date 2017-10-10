
```
████████╗██╗   ██╗██████╗ ██████╗  ██████╗ ████████╗
╚══██╔══╝██║   ██║██╔══██╗██╔══██╗██╔═══██╗╚══██╔══╝
   ██║   ██║   ██║██████╔╝██████╔╝██║   ██║   ██║
   ██║   ██║   ██║██╔══██╗██╔══██╗██║   ██║   ██║
   ██║   ╚██████╔╝██║  ██║██████╔╝╚██████╔╝   ██║
   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═════╝  ╚═════╝    ╚═╝
```


Turbot is a dating bot for the [Plenty of Fish](https://www.pof.com/) dating site.

[![Build Status](https://travis-ci.org/scrooloose/turbot.svg?branch=master)](https://travis-ci.org/scrooloose/turbot)

Purpose
=======

For a long time I found the world of internet dating to be quite painful. I
sent out lots of messages and, regardless of how much effort I put in, received
very few responses. Ow! My soul!

The vast majority of the pain/time-wasting was in sending that first message -
in reading through profiles to find someone interesting and then writing a message
to them about something we have in common. I realised that this activity is not
complicated and can be automated!  So I wrote a bot to do the job for me.

Being single can suck, but we can program ourselves out of this hole!

Setup
=====

**Set up the DB**

Copy `config/db_example.yml` to `config/db.yml`.

Create the databases and fill in the auth details.

**Run the database migrations**

```
rails db:migrate
```

**Add the default admin user**

```
rails db:seed

```

**Set up your POF user**

Fire up the rails server:

```
rails server
```

Log into ActiveAdmin, by visiting `/admin` and entering the email
*admin@example.com* and *password*


Click 'Users' from the top nav, then click the 'New User' button. Fill in the
form, leaving profile blank for now, and submit.

Note: Your profile's `Name` is used to sign the messages you send.

**Pull down your profile and associate it to your newly created user**

This part is ugly and, at some point, there will be a pretty UI to do it.

```
rails bootstraper:setup_profile pof_profile_id=YOUR_ID user_id=YOUR_USER_ID
```

Replace `YOUR_ID` with the POF ID. To find this, go to your profile page and
look at the number on the end of the url.

Example: `http://www.pof.com/viewprofile.aspx?profile_id=1234567`

Replace `YOUR_USER_ID` with the ID of the user from the previous step.

**Create some topics**

Now the fun part. You can create some canned messages and rules to figure out
which profiles these can be sent to.

Log into ActiveAdmin and click 'Topics' from the top nav and start creating!

Read more about topics below and how they are matched to profiles.

Now you're ready to rock and roll baby!


Usage
=====

Once you have your User and Topics set up, you can kick off a POF session by
visiting your User page in ActiveAdmin and clicking "Enqueue POF Session". This
will queue up the session in a background job.

Note: You must also start the delayed job queue processor which runs the session:

```
./bin/delayed_job start
```

Topic Matching
==============

A topic consists of:

1. A canned message that is sent to profiles matching this topic.
2. A set of regular expressions that are checked against the interests, and
   derived interests, of a profile. If one of the regular expressions matches,
   then this profile is a candidate to receive the canned message.

How do we know what the interests are for a given profile? There are two
methods. Firstly, a profile has an 'interests' section which is a comma
separated list. This is trivial to match against.

The second method is more involved, but necessary since many people don't use
the proper 'interests' section but instead put lists of interests into their
bio section. Turbot knows how to recognise the most common of these structures.
For example if a sentence like this is in a bio:

> I enjoy cycling, horse riding, card games and coffee.
> In my spare time I go cycling, horse riding, card games and coffee.
> In really enjoy cycling, horse riding, card games and coffee.

Then turbot will correctly pick out 'cycling', 'horse riding', 'card games' and
'coffee' as interests.

Similarly, turbot can recognise vertical lists of things like this:

> In my spare time I enjoy:
> * cycling
> * horse riding
> * card games
> * coffee

Once turbot has a list of interests, it will check these against each Topic to
see if it matches any of the Topic's matchers.

For example:

If a profile has the interest 'cycling' and we have a this Topic:

```
Topic:
    name: Cycling
    message: Hi there, I like cycling too ...
    matchers: (?<!motor |motor)bik(e|ing)|cycling

```

Then this topic would match the profile and the message "Hi there, I like
cycling too ..." could be sent to that profile.

Todo
====

* Dockerize the app.
* Finish making the app multi-user. For example give each user their own set of
  Topics.
* Clean up the Profile model a bit.
* Make turbot ignore messages from POF admins.
* Finish testing PofMessageInfoExtractor - there are a couple of untested
  methods.
