FROM ubuntu:focal as base
LABEL maintainer="patrick.jusic@protonmail.com"

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/Rome"

RUN apt update && apt install -y vim nano git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev nodejs imagemagick libicu-dev libpq-dev ruby-dev

RUN useradd -ms /bin/bash decidim
USER decidim
ENV HOME /home/decidim

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && \
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc

ENV PATH "$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
ENV RUBY_VERSION=${RUBY_VERSION:-2.6.6}

RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

RUN rbenv install $RUBY_VERSION
RUN rbenv global $RUBY_VERSION && rbenv versions && ruby -v

RUN echo "gem: --no-document" > ~/.gemrc && \
  gem install bundler


#########################################################################################
FROM base

USER decidim
WORKDIR /home/decidim

ARG decidim_version

RUN gem install decidim:$decidim_version
RUN decidim azione-decidim

WORKDIR /home/decidim/azione-decidim

RUN echo 'gem "figaro"\n' >> Gemfile

RUN bundle install

RUN sed -i 's/config\.application_name = "My Application Name"/config.application_name = "PartecipAzione"/g' ./config/initializers/decidim.rb
RUN sed -i 's/config\.mailer_sender = "change-me\@domain\.org"/config.mailer_sender = "decidim@azione.it"/g' ./config/initializers/decidim.rb
RUN sed -i 's/config\.available_locales \= \[\:en\, \:ca\, \:es\]/config\.available_locales \= \[\:en\, \:es\, \:it\]/g' ./config/initializers/decidim.rb
RUN sed -i 's/config\.default_locale = \:en/config\.default_locale = \:it/g' ./config/initializers/decidim.rb
RUN sed -i 's/# config\.force_ssl \= true/config\.force_ssl \= false/g' ./config/initializers/decidim.rb
RUN sed -i 's/# config\.force_ssl \= true/config\.force_ssl \= false/g' ./config/environments/production.rb

COPY ./entrypoint.sh .

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]
