install-deps:
	go install github.com/chrusty/protoc-gen-jsonschema/cmd/protoc-gen-jsonschema@1.4.1
	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

generate-json-schema:
	$(MAKE) generate-json-schema-version VERSION=v2
	$(MAKE) generate-json-schema-version VERSION=v3

BUILD_DIR=./build
BUILD_TMP_DIR=$(BUILD_DIR)/tmp

generate-json-schema-version:
	@-rm -rf $(BUILD_TMP_DIR) && mkdir -p $(BUILD_TMP_DIR)
	@protoc --jsonschema_out=$(BUILD_TMP_DIR) \
		--plugin=${HOME}/go/bin/protoc-gen-jsonschema \
		-I$(PWD)/libs/github.com/cncf/xds \
		-I$(PWD)/libs/github.com/envoyproxy/protoc-gen-validate \
		-I$(PWD)/libs/github.com/googleapis/googleapis \
		-I$(PWD)/libs/github.com/census-instrumentation/opencensus-proto/src \
		-I$(PWD)/libs/github.com/open-telemetry/opentelemetry-proto \
		-I$(PWD)/libs/github.com/prometheus/client_model \
		-I$(PWD)/libs/github.com/envoyproxy/envoy/api \
		$(PWD)/libs/github.com/envoyproxy/envoy/api/envoy/config/bootstrap/$(VERSION)/bootstrap.proto
	ls $(BUILD_TMP_DIR) | xargs -I {} mv $(BUILD_TMP_DIR)/{} $(BUILD_DIR)/$(VERSION)_{}
	rm -rf $(BUILD_TMP_DIR)
