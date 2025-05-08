# transformers-ruby testing

## Requirements for running this script

- Docker
- Ruby 3.3 (probably works with other versions too, but only tested with 3.3)
- libtorch (see "Getting Started" section for more info about this)

## Getting Started

1. First, make sure that you're able to install the 0.20.0 version of the torch-rb gem.  See this repository for installation instructions:
https://github.com/ankane/torch.rb#installation

2. Run `bundle install`

3. Run `docker compose build && docker compose up` to start the Docker compose process, which will start Solr.  This process will build a Docker image based on the latest conigurations specified in the docker-compose.yml file, and will then run the Docker compose process in the foreground.  You'll want to use a different terminal for the steps that follow.

4. Execute the main script: `ruby ./main.rb`

5. When you're done, go to the terminal window where docker is running, and hit ctrl+c to stop the process.  Then run `docker compose down` to clean up the Solr container.
