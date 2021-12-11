package main

import (
	"fmt"
	"net/http"
)

func hello(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "Hello world from iotbuddy.dev/dude!\n")
}

func main() {
	http.HandleFunc("/hello", hello)

	http.ListenAndServe(":8080", nil)
}
