RoundTrip
=========

Bidirectional sychronisation between Redmine and Trello

* RoundTrip keeps a Redmine project and a Trello board aligned.
* Cards are created on Trello to match Redmine issues and vice versa.
* Changes to ticket state on either are also reflected to the other system.

RoundTrip should be run as a cron job.

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

Configuration
=============

In order to know which lists on Trello to classify as dormant, backlog, current and
done, RoundTrip requies a series of regular expressions.

Run the configuration program as follows:

```shell
$ round_trip configure
```

Synchorinsation
===============

Start a synchorinsation run as follows:

```shell
$ round_trip run
```

