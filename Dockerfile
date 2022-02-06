FROM jekyll/jekyll as build
ENV JEKYLL_ENV="production"
WORKDIR /app
COPY . /app
RUN jekyll build

FROM jitesoft/lighttpd:latest
EXPOSE 80
COPY --from=build /app/_site /var/www/html
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
