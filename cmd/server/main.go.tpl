package main

import (
	"flag"
	"net/http"

	"github.com/Sirupsen/logrus"
	"{{index . "root_package"}}/pkg/inmemdb"
	"{{index . "root_package"}}/pkg/shop/dispatch"
	"{{index . "root_package"}}/pkg/shop/orders"
	"{{index . "root_package"}}/pkg/web"
)

var logLevel string
var port string
var logger *logrus.Logger

func setupLogger() *logrus.Logger {
	logrus.SetFormatter(&logrus.JSONFormatter{})
	switch logLevel {
	case "info":
		logrus.SetLevel(logrus.InfoLevel)
	case "error":
		logrus.SetLevel(logrus.ErrorLevel)
	case "debug":
		logrus.SetLevel(logrus.DebugLevel)
	default:
		logrus.SetLevel(logrus.ErrorLevel)
	}
	return logrus.StandardLogger()
}

func main() {
	flag.StringVar(&logLevel, "log-level", "info", "use this to set log level: error, info, debug")
	flag.StringVar(&port, "port", "3000", "set the port to listen on. e.g 3000")
	flag.Parse()
	logger = setupLogger()
	router := web.BuildRouter()
	orderRepo := inmemdb.NewOrderRepo()
	inventryRepo := inmemdb.NewIventoryRepo()
	delivery := dispatch.NewDispatch()
	//sys route
	{
		web.SysRoute(router)
	}
	//order route
	{
		orderPlacer := orders.NewPlaceOrder(logger, orderRepo, inventryRepo, delivery)
		web.OrderRoute(router, orderPlacer)
	}

	//http handler
	{
		logger.Info("starting {{index . "app"}} on  port " + port)
		httpHandler := web.BuildHTTPHandler(router)
		if err := http.ListenAndServe(":"+port, httpHandler); err != nil {
			logger.Error(err)
		}
	}
}
