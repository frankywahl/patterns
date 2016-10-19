package main

import (
	"os"
	"github.com/frankywahl/patterns/go/factory"
)

func main() {
	doc := &svg.Document{
		ShapeFactories: []svg.ShapeFactory{
			&svg.CircleFactory{},
			&svg.RactangleFactory{},
		},
	}

	doc.Draw(os.Stdout)
}
