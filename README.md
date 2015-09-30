# Resque Concurrency example

How we make things run concurrently with Resque at Innovative Travel

Created for this [blog post](http://blog.innovativetravel.eu/2015/09/concurrency-with-resque-hacking-our-way-through/).

## Instructions

```
# start resque
$ rake resque:workers QUEUE=* COUNT=8 INTERVAL=0.1

# run the benchmark
$ ruby main.rb
```

