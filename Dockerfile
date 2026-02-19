FROM alpine:latest


RUN apk add --no-cache curl bash git


CMD ["echo", "Hello from Docker! Week 10 Container is ready."]