install-deps:
	go install github.com/chrusty/protoc-gen-jsonschema/cmd/protoc-gen-jsonschema@1.4.1
	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

BUILD_DIR=./build

generate-json-schemas:
	@-rm -rf $(BUILD_DIR) && mkdir -p $(BUILD_DIR)
	@protoc --jsonschema_out=$(BUILD_DIR) \
		--plugin=${HOME}/go/bin/protoc-gen-jsonschema \
		-I$(PWD)/libs/github.com/cncf/xds \
		-I$(PWD)/libs/github.com/envoyproxy/protoc-gen-validate \
		-I$(PWD)/libs/github.com/googleapis/googleapis \
		-I$(PWD)/libs/github.com/census-instrumentation/opencensus-proto/src \
		-I$(PWD)/libs/github.com/open-telemetry/opentelemetry-proto \
		-I$(PWD)/libs/github.com/prometheus/client_model \
		-I$(PWD)/libs/github.com/envoyproxy/envoy/api \
		$(PWD)/libs/github.com/envoyproxy/envoy/api/envoy/config/bootstrap/v3/bootstrap.proto \
		$(PWD)/libs/github.com/envoyproxy/envoy/api/envoy/extensions/transport_sockets/tls/v3/tls.proto \
		$(PWD)/libs/github.com/envoyproxy/envoy/api/envoy/extensions/access_loggers/file/v3/file.proto
