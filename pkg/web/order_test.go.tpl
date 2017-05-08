package web_test

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"strings"

	"encoding/json"

	"github.com/Sirupsen/logrus"
	"{{index . "root_package"}}/pkg/inmemdb"
	"{{index . "root_package"}}/pkg/shop"
	"{{index . "root_package"}}/pkg/shop/orders"
	"{{index . "root_package"}}/pkg/web"
)

type mockDelivery struct {
	err error
}

func (md mockDelivery) Schedule(orderID int) error {
	return md.err
}

func setUpOrderRoute() http.Handler {
	router := web.BuildRouter()
	logger := logrus.StandardLogger()
	orderRepo := inmemdb.NewOrderRepo()
	inventory := inmemdb.NewIventoryRepo()
	delivery := mockDelivery{}
	orderPlacer := orders.NewPlaceOrder(logger, orderRepo, inventory, delivery)
	web.OrderRoute(router, orderPlacer)
	return web.BuildHTTPHandler(router)
}

func TestOrderEndpoint(t *testing.T) {
	handler := setUpOrderRoute()
	s := httptest.NewServer(handler)
	defer s.Close()
	r := strings.NewReader(`{"productID":10,"customerID":2}`)
	res, err := http.Post(s.URL+"/order/1", "application/json", r)
	if err != nil {
		t.Fatalf("unexpexted error making request to order %s", err.Error())
	}
	if res.StatusCode != http.StatusOK {
		t.Fatalf("expected status code %v but got %v", http.StatusOK, res.StatusCode)
	}
	defer res.Body.Close()
	dec := json.NewDecoder(res.Body)
	o := shop.Order{}
	if err := dec.Decode(&o); err != nil {
		t.Fatalf("failed to decode response %s", err.Error())
	}
	if o.CustomerID != 2 {
		t.Fatalf("expected customerID to be 2 but got %v", o.CustomerID)
	}
	if o.ProductID != 10 {
		t.Fatalf("expected productID to be 10 but got %v", o.ProductID)
	}

}
