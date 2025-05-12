FROM alpine:3.18 as builder

# Install build dependencies
RUN apk add --no-cache build-base git linux-headers

# Clone and build udp2raw
WORKDIR /build
RUN git clone https://github.com/wangyu-/udp2raw.git
WORKDIR /build/udp2raw
RUN make dynamic

FROM alpine:3.18

# Install runtime dependencies
RUN apk add --no-cache libstdc++ bash

# Copy the compiled binary from the builder stage
COPY --from=builder /build/udp2raw/udp2raw_dynamic /usr/local/bin/udp2raw

# Add the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]