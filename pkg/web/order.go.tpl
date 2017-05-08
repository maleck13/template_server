package web

import (
	"net/http"

	"encoding/json"

	"{{index . "root_package"}}/pkg/shop"
	"{{index . "root_package"}}/pkg/shop/orders"
)

// OrderHandler handles order requests
type OrderHandler struct {
	Orders *orders.PlaceOrder
}

// Order handles an order request adapting the raw body to the required type before handing to the buinsess logic layer
func (oh OrderHandler) Order(rw http.ResponseWriter, req *http.Request) {
	var (
		encoder = json.NewEncoder(rw)
		decoder = json.NewDecoder(req.Body)
		order   = &shop.Order{}
	)
	rw.Header().Add("content-type", "application/json")
	if err := decoder.Decode(order); err != nil {
		http.Error(rw, "failed to decode body "+err.Error(), http.StatusBadRequest)
		return
	}
	if err := oh.Orders.Place(order); err != nil {
		http.Error(rw, "failed to place order unexpected error "+err.Error(), http.StatusInternalServerError)
		return
	}
	if err := encoder.Encode(order); err != nil {
		http.Error(rw, "failed to encode response "+err.Error(), http.StatusInternalServerError)
		return
	}
}
