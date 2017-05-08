package web

import (
	"net/http"

	"github.com/codegangsta/negroni"
	"github.com/gorilla/mux"
	"{{index . "root_package"}}/pkg/shop/orders"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/rs/cors"
)

// BuildRouter is the main place we build the mux router
func BuildRouter() *mux.Router {
	r := mux.NewRouter().StrictSlash(true)
	return r
}

// BuildHTTPHandler constructs a http.Handler it is also where common middleware is added via negroni
func BuildHTTPHandler(r *mux.Router) http.Handler {
	//recovery middleware for any panics in the handlers
	recovery := negroni.NewRecovery()
	recovery.PrintStack = false
	//add middleware for all routes
	n := negroni.New(recovery)
	n.UseFunc(CorrellationID)
	n.Use(cors.New(
		cors.Options{
			AllowedOrigins: []string{"*"},
		},
	))
	n.UseHandler(r)
	return n
}

// SysRoute sets up the sys routes
func SysRoute(r *mux.Router) {
	sysHandler := SysHandler{}
	r.HandleFunc("/sys/info/ping", prometheus.InstrumentHandlerFunc("ping", sysHandler.Ping)).Methods("GET")
	r.HandleFunc("/sys/info/health", prometheus.InstrumentHandlerFunc("health", sysHandler.Health)).Methods("GET")
}

// OrderRoute sets up the order route
func OrderRoute(r *mux.Router, orderPlacer *orders.PlaceOrder) {
	orderHandler := OrderHandler{
		Orders: orderPlacer,
	}
	r.HandleFunc("/order/{productID}", prometheus.InstrumentHandlerFunc("orders", orderHandler.Order))
}
