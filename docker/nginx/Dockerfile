FROM nginx:1.29-alpine

# Install tzdata for proper timezone configuration
RUN set -ex \
    && apk --no-cache add tzdata

# Change uid for process user to avoid permission issues to 1000 (same as host user, normally)
RUN apk add shadow && usermod -u 1000 nginx && groupmod -g 1000 nginx
