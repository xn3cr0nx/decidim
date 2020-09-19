FROM decidim/decidim:latest-dev

RUN sudo apt-get update && sudo apt-get install -y vim
ENV EDITOR=vim

RUN sudo mkdir -p /code
RUN sudo chown decidim:decidim /code