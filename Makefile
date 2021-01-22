TESTDATA_DIR = testdata
BIN_DIR = bin
UTIL = ${BIN_DIR}/util
UTIL_SRCS = $(wildcard cmd/util/*.go)

VALIDATEPCAP = ${BIN_DIR}/validatepcap
VALIDATEPCAP_SRCS = $(wildcard cmd/validatepcap/*.go)

all: testdata

util: $(UTIL_SRCS)
	mkdir -p ${BIN_DIR}
	go get ./cmd/util/...
	go build -o ${UTIL} ./cmd/util/...

validatepcap: $(VALIDATEPCAP_SRCS)
	mkdir -p ${BIN_DIR}
	go get ./cmd/validatepcap/...
	go build -o ${VALIDATEPCAP} ./cmd/validatepcap/...

.PHONY: testdata
testdata: util
	mkdir -p ${TESTDATA_DIR}
	${UTIL} -make-root -out ${TESTDATA_DIR}/root.crt -key-out ${TESTDATA_DIR}/root.key -host root.com
	${UTIL} -make-intermediate -cert-in ${TESTDATA_DIR}/root.crt -key-in ${TESTDATA_DIR}/root.key -out ${TESTDATA_DIR}/example.crt -key-out ${TESTDATA_DIR}/example.key -host example.com
	${UTIL} -make-intermediate -cert-in ${TESTDATA_DIR}/root.crt -key-in ${TESTDATA_DIR}/root.key -out ${TESTDATA_DIR}/client_facing.crt -key-out ${TESTDATA_DIR}/client_facing.key -host client-facing.com
	${UTIL} -make-dc -cert-in ${TESTDATA_DIR}/example.crt -key-in ${TESTDATA_DIR}/example.key -out ${TESTDATA_DIR}/dc.txt
	${UTIL} -make-ech -out ${TESTDATA_DIR}/ech_configs -key-out ${TESTDATA_DIR}/ech_key -host client-facing.com

clean:
	rm -fr ${BIN_DIR}
	rm -fr ${TESTDATA_DIR}

clean-docker:
	docker network prune
	docker builder prune
