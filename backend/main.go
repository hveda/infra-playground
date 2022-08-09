package main

import (
	// "encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"
)

func getenv(key, fallback string) string {
	value := os.Getenv(key)
	if len(value) == 0 {
		return fallback
	}
	return value
}

func trivia(w http.ResponseWriter, r *http.Request) {
	_, _, day := time.Now().Date()
	switch r.Method {
	case "GET":
		response, err := http.Get("http://numbersapi.com/" + strconv.Itoa(day) + "/trivia")

		if err != nil {
			fmt.Print(err.Error())
			os.Exit(1)
		}

		responseData, err := ioutil.ReadAll(response.Body)
		if err != nil {
			log.Fatal(err)
		}
		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, string(responseData))
	default:
		w.WriteHeader(http.StatusNotFound)
		w.Write([]byte(`{"message":"Not Found"`))
	}
}
func main() {
	port := getenv("SERVER_PORT", "3030")
	http.HandleFunc("/", trivia)
	http.HandleFunc("/trivia", trivia)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
