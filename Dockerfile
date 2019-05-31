# Pull base image
FROM ubuntu:18.04

EXPOSE 4000

# Install packages
RUN \
  apt update -y && apt upgrade -y && \
  \
  apt install -y ruby-full && apt install -y apt-utils && \
  ruby --version && \
  \
  # build-essential installs gcc g++ and make
  apt install -y build-essential && gcc -v && g++ -v && make -v && \
  \
  # download and extract rubygems package
  apt install -y wget && apt install -y curl && \
  wget "https://rubygems.org/rubygems/rubygems-3.0.3.tgz" && \
  \
  tar xvfz rubygems-3.0.3.tgz && \
  \
  cd rubygems-3.0.3 && ruby setup.rb && cd .. && \
  \
  # install jekyll and bundler
  gem install jekyll bundler

WORKDIR /c/repo/jekyll/myblog

COPY . /c/repo/jekyll/myblog

RUN bundle install 


CMD ["bundle", "exec", "jekyll", "serve", "--baseurl=/","--drafts", "--host=0.0.0.0", "--force-polling"]
# --force-pooling continiously monitors the changes and updates the deployment
# drafts allows drafts to be available for viewing

# docker build -t jekyll:ubuntu-18.04 .

# ```docker
# docker run \
# -p 4000:4000 -p 35729:35729 \
# --volume="//c/repo/jekyll/:/c/repo/jekyll/" \
# -it jekyll:ubuntu-18.04
# ```