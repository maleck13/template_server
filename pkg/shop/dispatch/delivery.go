package dispatch

type Dispatch struct {
}

func (d Dispatch) Schedule(orderID int) error {
	//do scheduling logic
	return nil
}

func NewDispatch() *Dispatch {
	return &Dispatch{}
}
