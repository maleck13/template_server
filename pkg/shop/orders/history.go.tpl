package orders

import "{{index . "root_package"}}/pkg/shop"

//History handles history business logic
type History struct {
}

// List returns a list of a customer's orders
func (h History) List(customerID int) ([]*shop.Order, error) {
	return nil, nil
}

// NewHistory returns a new order histroy usecase
func NewHistory() *History {
	return &History{}
}
