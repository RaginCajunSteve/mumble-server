FROM mumblevoip/mumble-server:latest
# Add any custom init scripts here if needed
COPY config/murmur.ini /config/murmur.ini
