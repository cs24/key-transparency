// Copyright 2015 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"flag"
	"fmt"
	"log"
	"net"

	"github.com/gdbelvin/e2e-key-transparency/proxy"
	"github.com/gdbelvin/e2e-key-transparency/rest"

	v1pb "github.com/gdbelvin/e2e-key-transparency/proto"
)

var port = flag.Int("port", 50051, "TCP port to listen on")

func main() {
	flag.Parse()

	portString := fmt.Sprintf(":%d", *port)
	// TODO: fetch private TLS key from repository
	lis, err := net.Listen("tcp", portString)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	v1 := proxy.New()
	s := rest.New(v1)

	// Manually add routing paths.  TODO: Auto derive from proto.
	s.AddHandler("/v1/user/{userid}", "GET", v1pb.GetUser_Handler)

	s.Serve(lis)
}
