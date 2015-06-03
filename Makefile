# Go support for Protocol Buffers - Google's data interchange format
#
# Copyright 2010 The Go Authors.  All rights reserved.
# https://github.com/golang/protobuf
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#     * Neither the name of Google Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#include $(GOHOME)/src/pkg/github.com/golang/protobuf/Make.protobuf
DEPS:= $(shell find . -type f -name '*.proto' | sed 's/proto$$/pb.go/')
OUTPUT:= .

#REPLACE=Mgoogle/protobuf/timestamp.proto=github.com/google/googleapis/google/protobuf
FLAGS+= --go_out=plugins=grpc,$(REPLACE):$(OUTPUT)
INCLUDES+= -I=.
INCLUDES+= -I=$(GOPATH)/src/
INCLUDES+= -I=$(GOPATH)/src/github.com/google/protobuf/src/ # proto descriptor

main: proto
	go build -o svr server.go

test:
	go test ./rest ./keyserver

proto: gapis $(DEPS) 

%.pb.go:  %.proto
	protoc $(INCLUDES) $(FLAGS) $<

# We depend on the google api proto files
GAPIS := $(GOPATH)/src/github.com/google/googleapis
gapis:
	cd $(GAPIS) && $(MAKE) all LANGUAGE=go OUTPUT=.

clean:
	rm $(DEPS)
	cd $(GAPIS) && OUTPUT=. $(MAKE) clean

