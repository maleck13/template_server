package inmemdb

import "{{index . "root_package"}}/pkg/shop"

type OrderRepo struct {
	orders map[int]*shop.Order
}

func NewOrderRepo() *OrderRepo {
	return &OrderRepo{
		orders: make(map[int]*shop.Order),
	}
}

func (or *OrderRepo) Save(order *shop.Order) error {
	or.orders[order.ID] = order
	return nil
}

func (or *OrderRepo) List(customerID int) ([]*shop.Order, error) {
	orders := []*shop.Order{}
	for _, o := range or.orders {
		if o.CustomerID == customerID {
			orders = append(orders, o)
		}
	}
	return orders, nil
}

type InventoryRepo struct{}

func (ir InventoryRepo) Decrement(productID int) error {
	return nil
}
func (ir InventoryRepo) Available(productID int) (int, error) {
	return 2, nil
}

func NewIventoryRepo() *InventoryRepo {
	return &InventoryRepo{}
}
