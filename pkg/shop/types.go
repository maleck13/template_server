/*
Package shop represents our domain model. These are our domain entities
*/
package shop

type Product struct {
	ID int `json:"id"`
}

type Customer struct {
	ID      int     `json:"id"`
	Address Address `json:"address"`
}

type Order struct {
	ID         int `json:"id"`
	ProductID  int `json:"productID"`
	CustomerID int `json:"customerID"`
}

type Address struct {
	House  string `json:"house"`
	Street string `json:"street"`
	County string `json:"county"`
}
