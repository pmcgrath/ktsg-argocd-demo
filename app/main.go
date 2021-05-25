package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

var (
	port    = 5000
	version = "not-set"
)

type response struct {
	Greeting string `json:"greeting"`
	Hostname string `json:"hostname"`
	Time     string `json:"time"`
	Version  string `json:"version"`
}

func main() {
	log.SetFlags(log.Llongfile | log.Ltime | log.LUTC)

	log.Printf("Version: %s\n", version)

	hostname, _ := os.Hostname()
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s on %s", r.Method, r.URL.Path)

		data := response{
			Greeting: "Hello",
			Hostname: hostname,
			Time:     time.Now().UTC().Format("15:04:05"),
			Version:  version,
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		json.NewEncoder(w).Encode(data)
	})

	addr := fmt.Sprintf(":%d", port)
	log.Printf("Starting server listening at %s\n", addr)
	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatal(err)
	}
}
