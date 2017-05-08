package orders

import (
	"fmt"

	"{{index . "root_package"}}/pkg/shop"
	"github.com/pkg/errors"
)

//PlaceOrder  handles order placing business logic
type PlaceOrder struct {
	logger    Logger
	store     OrderRepo
	inventory InventoryRepo
	delivery  Delivery
}

// NewPlaceOrder creates a new PlaceOrder usecase
func NewPlaceOrder(logger Logger, repo OrderRepo, inventory InventoryRepo, delivery Delivery) *PlaceOrder {
	return &PlaceOrder{
		logger:    logger,
		store:     repo,
		inventory: inventory,
		delivery:  delivery,
	}
}

// Place places an order ensuring availability, recording the order updating the inventory and asking for delivery to be scheduling
func (o *PlaceOrder) Place(order *shop.Order) error {
	isAvailable, err := o.ensureAvailability(order.ProductID)
	if err != nil {
		return err
	}
	if !isAvailable {
		return errors.New(fmt.Sprintf("the product %v  cannot be ordered. Not currently available", order.ProductID))
	}
	if err := o.store.Save(order); err != nil {
		return errors.Wrap(err, "failed placing order saving order error ")
	}
	if err := o.inventory.Decrement(order.ProductID); err != nil {
		return errors.Wrap(err, "failed placing order decrementing the inventory caused and error ")
	}
	if err := o.delivery.Schedule(order.ID); err != nil {
		return errors.Wrap(err, "failed to place order. Scheduling delivery error ")
	}
	return nil
}

func (o *PlaceOrder) ensureAvailability(ProductID int) (bool, error) {
	available, err := o.inventory.Available(ProductID)
	if err != nil {
		return false, errors.Wrap(err, "ensuring availibility failed. Error checking available products with inventory")
	}
	return (available > 0), nil
}
