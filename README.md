# University Management System – README

Ruby on Rails web app to manage students, enterprises and internships.

[Open screenshots](./SCREENSHOTS.md)

## History of this project

### September 2013: Study project

A few DFHI/ISFATES BBA and CS students decided to accomplish the following task: Analyze every “business process” inside the institute and its partner universities that involves a contact between the university and enterprises:

E.g.:

- enterprise sends offer: how is it transmitted to the students?
- student has found internship: how can a study program director authorize and validate an internship?

In January 2014, a group of 6 students created a prototype in vanilla PHP, based on MVC. A large part of the time went into the (relational) data model design and refinement.

### August 2014: Bachelor’s Thesis

During my Bachelor internship, I worked with Oracle Application Express (Apex). I used my acquired experience in Apex to rebuild the app with Oracle technologies (including PL/SQL). The project did not go into production, since it was still a prototype and difficult to host, especially with Oracle’s licensing policy.

### September 2014: Ruby on Rails

I was curious to learn new technologies, so I decided to learn Ruby on Rails. As a test project, I wanted to rebuild the app, this time with Open Source technologies.

I worked on the app between:

- November 2014 - December 2014
- March 2015 - April 2015
- October 2016 - January 2017 (see below)
- March 2017 - April 2017 (_SPA_, see below)
- May 2017 - July 2017
- March 2019

### October 2016: DFHI-VZ

After having finished my studies, I worked for the university on an existing alumni app, built with Apache Tapestry (Java framework). I removed duplicate parts from my RoR app (e.g. edit and delete students) and adjusted it to the Tapestry web app data model. It was a very interesting experience to build an app on an existing “legacy” database.

Moreover, I discovered that [the university’s alumni organisation](https://isfates-dfhi-alumni.org) also created an app to manage students and offers, so I removed the offer functionality from my app.

### March 2017

I wanted to try out Vue.js, so I created REST / JSON routes in the existing RoR app and built a SPA Front end with Vue.js.

### March 2019

I decided to revert the changes made in October 2016, and publish the app on GitHub, under a new name: _University management system_.

## Installation

### Dependencies

Install ruby version 2.3, and PostgreSQL version 9.6. (Rails also works with MySQL.)
Configure your database (credentials) in the file `config/database.yml`.

Next, make sure, the `bundle` command works, and that you are in the project's root.
Then, execute `bundle install`, which will install the dependencies.

### Create database tables

Then, you have to create the database tables with `rake db:migrate`.
You can also insert test data with `rake db:seed`.

### Create a secret key base

You need a secret key for verifying the integrity of signed cookies.

Execute `rake secret` to generate the key. Copy the displayed key and create an environment variable `SECRET_KEY_BASE` with it.
You could also insert it in `config/secrets.yml`.

### Configure the mailer

Open `config/environments/{development,production}.rb` and edit the `config.action_mailer.smtp_settings` and the `config.action_mailer.default_url_options` settings to configure your mailer.

### Start the server

Finally, execute `rails server -p 3000` to start the application in development mode.
Add `-e production` to start the application in production mode.
You can then open the application under `localhost:3000`.

## Docker

If you know how to use Docker and have Docker and Docker Compose installed, you can follow the following instructions.

Go to `path/to/project/` and run `docker-compose build`, with `--no-cache` option if needed.

In order to run the Rails app and the database, run `docker-compose run`.

You can get a list of all the containers with `docker ps -a`.
This list also contains the ID of each container.

On Ubuntu, I ran `docker inspect <CONTAINER_ID>` to get the IP address of the Rails app container to access the server.

In order to run a command in a container (`web` or `db`), use `docker-compose run --rm (web|db) your_command`.
`your_command` could be `rake db:create db:migrate` or `bash`.

## Migration and seeding

You need to create (= _migrate_) the tables. Do it with:

```
bin/rails db:migrate RAILS_ENV=development
```

Seed the tables (e.g. insert countries) with:

```
bin/rails db:seed RAILS_ENV=development
```

## Tests

Create the test database by adding `RAILS_ENV=test` at the end.

Run the tests with the command `... bundle exec cucumber`.

Open a Rails console for the test environment with `... rails console test`
