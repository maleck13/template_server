package web

import "net/http"

// SysHandler handles /sys routes
type SysHandler struct {
}

// Ping simple response to assert app is running
func (sh SysHandler) Ping(rw http.ResponseWriter, req *http.Request) {
	rw.Write([]byte("Ok"))
}

// Health simple health endpoint to check this service dependencies
func (sh SysHandler) Health(rw http.ResponseWriter, req *http.Request) {

}
