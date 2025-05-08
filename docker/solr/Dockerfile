FROM solr:9.8.1

WORKDIR /data

COPY ./setup-and-start.sh .

COPY --chown=solr:solr './solr_cores/ruby-vector-search-testing-solr-9' /template-cores/ruby-vector-search-testing
RUN echo 'name=ruby-vector-search-testing' > /template-cores/ruby-vector-search-testing/core.properties

CMD /bin/bash ./setup-and-start.sh
