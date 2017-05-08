package web_test

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"testing"

	"{{index . "root_package"}}/pkg/web"
)

func setUpSysRoute() http.Handler {
	router := web.BuildRouter()
	web.SysRoute(router)
	return web.BuildHTTPHandler(router)
}

func TestSysPing(t *testing.T) {
	handler := setUpSysRoute()
	s := httptest.NewServer(handler)
	defer s.Close()
	url := fmt.Sprintf("%s/sys/info/ping", s.URL)
	res, err := http.Get(url)
	if err != nil {
		t.Fatalf("did not expect an error getting sys/info/ping endpoint. %s", err.Error())
	}
	if res.StatusCode != http.StatusOK {
		t.Fatalf("expected response code 200 but got %v ", res.StatusCode)
	}
	defer res.Body.Close()
	cont, err := ioutil.ReadAll(res.Body)
	if err != nil {
		t.Fatalf("did not expect an error reading the response body %s", err.Error())
	}
	if string(cont) != "Ok" {
		t.Fatalf("expected sys info ping to return Ok but instead got %s", string(cont))
	}

}
