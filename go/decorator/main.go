package main

import (
	"fmt"
	"log"
	"math"
	"os"
	"sync"
	"time"
)

type piFunc func(int) float64

// Pi is a function to approximate the value of PI
func Pi(n int) float64 {
	ch := make(chan float64)

	for k := 0; k < n; k++ {
		go func(ch chan float64, k float64) {
			ch <- 4 * math.Pow(-1, k) / (2*k + 1)
		}(ch, float64(k))
	}

	result := 0.0
	for k := 0; k < n; k++ {
		result += <-ch
	}

	return result
}

func wrapLogger(fn piFunc, l *log.Logger) piFunc {
	return func(n int) (result float64) {
		defer func(t time.Time) {
			l.Printf("took=%v, result=%v", time.Since(t), result)
		}(time.Now())
		return fn(n)
	}
}

func wrapLoggerAndExecution(originalFunc piFunc, l *log.Logger) piFunc {
	return func(n int) float64 {
		fn := func(n int) (result float64) {
			t := time.Now()
			defer func(t time.Time) {
				l.Printf("took=%v, result=%v", time.Since(t), result)
			}(t)
			return originalFunc(n)
		}
		return fn(n)
	}
}

func wrapCache(fn piFunc, cache *sync.Map) piFunc {
	return func(n int) float64 {
		key := fmt.Sprintf("n=%d", n)
		val, ok := cache.Load(key)
		if ok {
			return val.(float64)
		}
		result := fn(n)
		cache.Store(key, result)
		return result
	}
}
func main() {
	logger := log.New(os.Stdout, "PI ", 1)
	loggingPi := wrapLogger(Pi, logger)
	logginAndExecuting := wrapLoggerAndExecution(Pi, logger)
	loggingPi(100000)
	logginAndExecuting(100000)
}
