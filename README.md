
```
████████╗██╗   ██╗██████╗ ██████╗  ██████╗ ████████╗
╚══██╔══╝██║   ██║██╔══██╗██╔══██╗██╔═══██╗╚══██╔══╝
   ██║   ██║   ██║██████╔╝██████╔╝██║   ██║   ██║
   ██║   ██║   ██║██╔══██╗██╔══██╗██║   ██║   ██║
   ██║   ╚██████╔╝██║  ██║██████╔╝╚██████╔╝   ██║
   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═════╝  ╚═════╝    ╚═╝
```


Turbot is a bot for the [Plenty of Fish](https://www.pof.com/) dating site.

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


Copy the config file and set it up as desired

```
cp config/config_exampe.yml config/config.yml
```

Next, fire up Turbot and set up the database

```
docker-compose up
docker-compose run --rm app rails db:setup

```

Load the DB seed data. This actually just adds a default admin user so you can
log in.


```
docker-compose run --rm app rails db:seed

```

**Set up your POF user**


Log into ActiveAdmin, at `http://localhost:3000/admin` with email:
`admin@example.com` and password: `password`

Click 'Users' from the top nav, click the 'New User' button and fill in the
form. Leave the topics empty for now.

**Pull down your profile and associate it to your newly created user**

This part is ugly and, at some point, there will be a pretty UI to do it.

```
docker-compose run --rm app rails bootstrapper:setup_profile pof_profile_id=POF_ID user_id=USER_ID
```

Replace `POF_ID` with the your own POF ID. To find this, go to your profile
page and look at the number on the end of the url.

Example: `http://www.pof.com/viewprofile.aspx?profile_id=1234567`

Replace `USER_ID` with the ID of the user from the previous step (almost
certainly "1").

**Create some topics**

Now the fun part. You can create some canned messages and rules to figure out
which profiles these can be sent to.

Log into ActiveAdmin and edit the user you just created and start adding topics!

Read more about topics below and how they are matched to profiles.

Now you're ready to rock and roll baby!


Usage
=====

Once you have your User and Topics set up, you can kick off a POF session by
visiting your User page in ActiveAdmin and clicking "Enqueue POF Session". This
will queue up the session in a background job.

The background job processor (delayed job) should already be running from the
`docker-compose up`.


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
For example if one of these sentences appeared in a bio:

> I enjoy cycling, horse riding, card games and coffee.
>
> In my spare time I go cycling, horse riding, card games and coffee.
>
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

* Finish making the app multi-user. For example give each user their own set of
  Topics.
* Clean up the Profile model - getting pretty messy and overloaded.
* Make turbot ignore messages from POF admins.
* Finish testing PofMessageInfoExtractor - there are a couple of untested
  methods.
