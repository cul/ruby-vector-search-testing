#!/usr/bin/env ruby

# frozen_string_literal: true

# Require all gems in Gemfile
require 'bundler'
Bundler.require(:default)

# Auto-load all files in lib directory
loader = Zeitwerk::Loader.new
loader.push_dir('lib')
loader.setup # ready!

# Run code!

fulltext_values = [
  'The cat went to the store and bought some milk.',
  'Traveling from the US to Canada.',
  'Traveling from Canada to the US.'
]

query = 'go to Canada'

model_768 = Transformers.pipeline('embedding', 'BAAI/bge-base-en-v1.5')
model_1024 = Transformers.pipeline('embedding', 'BAAI/bge-large-en-v1.5')

documents = fulltext_values.map.with_index do |fulltext, i|
  fulltext_vector768 = model_768.call(fulltext)
  fulltext_vector1024 = model_1024.call(fulltext)

  {
    id: "doc:#{i}",
    title_ssi: "Document #{i}",
    fulltext_ss: fulltext,
    fulltext_vector768i: fulltext_vector768,
    fulltext_vector768si: fulltext_vector768,
    fulltext_vector1024i: fulltext_vector1024,
    fulltext_vector1024si: fulltext_vector1024
  }
end

solr = RSolr.connect(url: 'http://localhost:8983/solr/ruby-vector-search-testing')
documents.each { |document| solr.add(document) }
solr.commit

# Now let's query solr
query_vector768 = model_768.call(query)
query_vector1024 = model_1024.call(query)

# Queries that return top x ranked results
max_results = 2
knn_formatted_768_top_x_query = "{!knn f=fulltext_vector768i topK=#{max_results}}[#{query_vector768.join(', ')}]"
knn_formatted_1024_top_x_query = "{!knn f=fulltext_vector1024i topK=#{max_results}}[#{query_vector1024.join(', ')}]"

# Queries that return similar min threshold results
knn_formatted_768_min_threshold_query =
  "{!vectorSimilarity f=fulltext_vector768i minReturn=0.8}[#{query_vector768.join(', ')}]"
knn_formatted_1024_min_threshold_query =
  "{!vectorSimilarity f=fulltext_vector1024i minReturn=0.8}[#{query_vector1024.join(', ')}]"

# response = solr.post('select', data: { q: 'title_ssi:*Document*', fl: '*,score' })['response']
response_768_top_x = solr.post('select', data: { q: knn_formatted_768_top_x_query, fl: '*,score' })['response']
response_1024_top_x = solr.post('select', data: { q: knn_formatted_1024_top_x_query, fl: '*,score' })['response']
response_768_min_threshold = solr.post('select',
                                       data: { q: knn_formatted_768_min_threshold_query, fl: '*,score' })['response']
response_1024_min_threshold = solr.post('select',
                                        data: { q: knn_formatted_1024_min_threshold_query, fl: '*,score' })['response']

puts '----- 768 top x results -----'
puts "Query is: #{query}"
puts "Found #{response_768_top_x['numFound']} documents:"
puts(response_768_top_x['docs'].map { |doc| "#{doc['fulltext_ss']} (score: #{doc['score']})" })
puts '----- 1024 top x results -----'
puts "Query is: #{query}"
puts "Found #{response_1024_top_x['numFound']} documents:"
puts(response_1024_top_x['docs'].map { |doc| "#{doc['fulltext_ss']} (score: #{doc['score']})" })
puts '----- 768 min threshold results -----'
puts "Query is: #{query}"
puts "Found #{response_768_min_threshold['numFound']} documents:"
puts(response_768_min_threshold['docs'].map { |doc| "#{doc['fulltext_ss']} (score: #{doc['score']})" })
puts '----- 1024 min threshold results -----'
puts "Query is: #{query}"
puts "Found #{response_1024_min_threshold['numFound']} documents:"
puts(response_1024_min_threshold['docs'].map { |doc| "#{doc['fulltext_ss']} (score: #{doc['score']})" })
puts '-----------------------'
