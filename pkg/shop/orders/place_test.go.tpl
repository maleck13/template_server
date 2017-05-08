package orders_test

import (
	"errors"
	"testing"

	"github.com/Sirupsen/logrus"
	"{{index . "root_package"}}/pkg/inmemdb"
	"{{index . "root_package"}}/pkg/shop"
	"{{index . "root_package"}}/pkg/shop/orders"
)

type mockInventory struct {
	err       error
	available int
}

func (mi mockInventory) Decrement(productID int) error {
	return mi.err
}
func (mi mockInventory) Available(productID int) (int, error) {
	return mi.available, mi.err
}

type mockDelivery struct {
	err error
}

func (md mockDelivery) Schedule(orderID int) error {
	return md.err
}
func TestPlaceOrder(t *testing.T) {
	cases := []struct {
		Name           string
		Available      int
		DeliveryError  error
		InventoryError error
		ExpectError    bool
	}{
		{
			Name:      "happy orders ok",
			Available: 10,
		},
		{
			Name:        "errors on unavailable product",
			Available:   0,
			ExpectError: true,
		},
		{
			Name:          "errors if fails to schedult",
			Available:     10,
			DeliveryError: errors.New("oops"),
			ExpectError:   true,
		},
	}
	for _, tc := range cases {
		t.Run(tc.Name, func(t *testing.T) {
			orderRepo := inmemdb.NewOrderRepo()
			logger := logrus.StandardLogger()
			inventory := mockInventory{err: tc.InventoryError, available: tc.Available}
			delivery := mockDelivery{err: tc.DeliveryError}
			orderPlacer := orders.NewPlaceOrder(logger, orderRepo, inventory, delivery)
			order := &shop.Order{
				ID:         1,
				CustomerID: 1,
				ProductID:  1,
			}
			err := orderPlacer.Place(order)
			if tc.ExpectError && err == nil {
				t.Fatal("expected an error but got none")
			} else if !tc.ExpectError && err != nil {
				t.Fatalf("unexpected error placing order %s", err.Error())
			}
		})
	}

}
