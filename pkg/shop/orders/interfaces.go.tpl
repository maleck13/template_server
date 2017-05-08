package orders

import "{{index . "root_package"}}/pkg/shop"

// Logger describes a logging interface
type Logger interface {
	Info(args ...interface{})
	Error(args ...interface{})
	Debug(args ...interface{})
}

//OrderRepo defines how we want to save orders
type OrderRepo interface {
	Save(order *shop.Order) error
	List(id int) ([]*shop.Order, error)
}

//InventoryRepo handles inventory actions
type InventoryRepo interface {
	Decrement(productID int) error
	Available(productID int) (int, error)
}

//Delivery defines how deliveries should be handled
type Delivery interface {
	Schedule(orderID int) error
}
