# Viewing Party
  - A web app for scheduling movie watch parties with other users on the site.


## Authors

  - [Harrison Blake](https://github.com/harrison-blake)
  - [Jacob Arellano](https://github.com/jakejakearell)
  - [Genevieve Nuebel](https://github.com/Gvieve)

See also the list of
[Contributors](#contributors)
who participated in this project.

## Summary

  - [Getting Started](#getting-started)
  - [Database Normalization](#database-schema)
  - [Running the test suite](#running-the-test-suite)
  - [Built With](#built-with)
  - [How to Contribute](#how-to-contribute)
  - [Roadmap](#roadmap)
  - [Contributors](#contributors)
  - [Acknowledgments](#acknowledgments)

## Getting Started

These instructions will get you a copy of the project up and running on
your local machine for development and testing purposes. See deployment
for notes on how to deploy the project on a live system.

### Prerequisites

* __Ruby__

  - The project is built with rubyonrails using __ruby version 2.5.3p105__, you must install ruby on your local machine first. Please visit the [ruby](https://www.ruby-lang.org/en/documentation/installation/) home page to get set up. Please ensure you install the version of ruby noted above.

* __Rails__
  ```sh
  gem install rails --version 5.2.4.3
  ```

* __Postgres database__
  - Visit the [postgresapp](https://postgresapp.com/downloads.html) homepage and follow their instructions to download the latest version of Postgres.app.

* __Movie DB API__
  - This project consumes an API from [The Movie DB](https://www.themoviedb.org/settings/api). You need to setup your own account and request an API key in order to use this app. This API key should never be exposed and is hidden using the [figaro gem](https://github.com/laserlemon/figaro), see installation instructions for more details on how to configure.  

### Installing

1. Clone the repo
   ```sh
   git clone https://github.com/harrison-blake/viewing_party
   ```

2. Bundle Install
   ```sh
   bundle install
   ```

3. Create rails database and migrate
```sh
$ rails db:create
$ rails db:migrate
```

4. Configure your API key environmental variable. Run the below command to create an application.yml that is included in the .gitignore file.
```sh
$ bundle exec figaro install
```

5. Open the application.yml file in your text editor, in the example below it is using atom as the text editor.
```sh
$ atom config/application.yml
```

6. Inside of the application.yml create environment variable for your Movie DB api key. At the bottom of the file enter the following:
```
MOVIE_API: <your api key goes here>
```

7. Start rails server
```sh
$ rails s
```

## DB Schema

[Database Design](insertlinkhere)

## Running the test suite

The tests are all built using the [RSpec](https://rspec.info/) and [Capybara](https://github.com/teamcapybara/capybara) test suites.


## Built With

  * [Ruby on Rails](https://rubyonrails.org)
  * [HTML](https://html.com)
  * [JavaScript](https://www.javascript.com)
  * [CoffeeScript](https://coffeescript.org/)
  * [Bootstrap](https://getbootstrap.com/)

## How to Contribute

In the spirit of Viewing Party, things done together are better than done on our own. If you have any amazing ideas or contributions on how we can improve this app they are **greatly appreciated**. To contribute:

  1. Fork the Project
  2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
  3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
  4. Push to the Branch (`git push origin feature/AmazingFeature`)
  5. Open a Pull Request

## Roadmap

See the [open issues](https://github.com/harrison-blake/viewing_party/issues) for a list of proposed features (and known issues). Please open an issue ticket if you see an existing error or bug.

## Contributors

  - [Harrison Blake](https://github.com/harrison-blake)
  - [Jacob Arellano](https://github.com/jakejakearell)
  - [Genevieve Nuebel](https://github.com/Gvieve)

    See also the list of
    [contributors](https://github.com/harrison-blake/viewing_party/graphs/contributors)
    who participated in this project.

## Acknowledgments
  -- **Billie Thompson** - *Provided README Template* -
    [PurpleBooth](https://github.com/PurpleBooth)
  - Our fantastically amazing instructors at [Turing School of Software and Design](https://turing.io/):
    * Ian Douglas
    * Alex Robinson
    * Tim Tyrell
