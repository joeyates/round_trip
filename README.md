RoundTrip
=========

Bidirectional synchronisation between Redmine and Trello tickets.

* RoundTrip keeps a Redmine project and a Trello board aligned,
* Cards are created on Trello to match Redmine issues and vice versa,
* Changes to ticket state on either are copied to the other system.

RoundTrip is normally run as a cron job.

# Warning

This is pre-alpha software - do not use!

Assumptions
===========

RoundTrip assumes the following:

* you manage tickets on Redmine and Trello in parallel, i.e. you want every card on
  Trello to exist as a Redmine issue, and vice versa.
* your workflow is sprint style, i.e. you have a backlog from which you select
  tickets for a sprint,
* during sprints, you move cards to a 'done' list which is specific to that sprint.

Requirements
============

## Trello

For each sprint, you must have the following:

* exactly one list where you initially place cards to be worked on (the 'sprint list'),
* exactly one list for completed cards (the 'done list'),
* these two lists must be uniquely identifiable according to the configuration.

Example:

* sprint list: 'current sprint',
* done list: 'done 201304'.

During configuration (see below), you will need to input regular expressions to
identify these lists.

Structure
=========

RoundTrip classifies your Trello lists as follows:

* dormant (ideas, etc.),
* backlog (stuff to be worked on some time),
* current (contents of the current sprint),
* done (work that has been completed during the current sprint),
* archived (closed tickets).

![Equivalence between Redmine tickets and Trello cards](https://raw.github.com/joeyates/round_trip/master/doc/redmine-trello%20state%20mapping.png)
_Equivalence between Redmine tickets and Trello cards_

Configuration
=============

In order to know which lists on Trello to classify as dormant, backlog, current and
done, RoundTrip requies a series of regular expressions.

Run the configuration program as follows:

```shell
$ round_trip configure
```

## Accounts

### Redmine

For each Redmine site that you access, you will need to get a users' API key.

* Go to https://THE_REDMINE_SITE/my/account,
* In the column on the right (normally), click on 'Show' under 'API access key',
* Copy the key to the Redmine site settings.

### Trello

For each Trello account that you want to access, you will need an app key and secret
plus a user authentication token.

For the app key and secret:

* Go to https://trello.com/1/appKey/generate
* Copy the 'Key' and the 'Secret'.

Next, insert your app key into the following URL and paste it into a browser where
you are logged in to Trello:

```
https://trello.com/1/authorize?key=YOU_KEY_HERE&name=RoundTrip&expiration=never&response_type=token&scope=read,write
```

That will take you to an authorization page. Click on the button to authorize RoundTrip
and you will be presentedwith a token.

Synchorinsation
===============

Start a synchorinsation run as follows:

```shell
$ round_trip run
```

Testing
=======

## Setup

```shell
rake db:migrate ROUND_TRIP_ENVIRONMENT=test
```

## All tests

```
rake
```

