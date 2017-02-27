FROM ruby:2.4.0
MAINTAINER Gebhard Woestemeyer <g@ctr.lc>
ENV LANG=C.UTF-8
ENV PATH=/app/bin:$PATH
WORKDIR /app
COPY . .
RUN bundle install --local
CMD ["rspec"]
