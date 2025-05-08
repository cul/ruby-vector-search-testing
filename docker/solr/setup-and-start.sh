#!/bin/bash

# Set up symlinks if they don't exist.  The conditional checks ensure that this only runs if
# the volume is re-created.
[ ! -L /var/solr/ruby-vector-search-testing ] && ln -s /data/ruby-vector-search-testing /var/solr/ruby-vector-search-testing

precreate-core ruby-vector-search-testing /template-cores/ruby-vector-search-testing

# Start solr
solr-foreground
