FROM nginx:1.19-alpine

# Change uid for process user to avoid permission issues to 1000 (same as host user, normally)
RUN apk add shadow && usermod -u 1000 nginx && groupmod -g 1000 nginx
