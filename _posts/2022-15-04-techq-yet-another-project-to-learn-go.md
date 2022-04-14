---
title: TechQ, yet another project to learn Go
date: 2022-04-15
description: >-
  I built a small application called TechQ to learn a couple of things about Go
---

I've been coding for more than 10 years, and I've used a variety of languages, but when it comes to fill my pockets I code in Ruby.

I have been checking out Go for a while now. I like it's simplicity while maintaining consistency across its methods and standard libraries. I have little experience with typed languages, but Go makes it feel easy, and the IDE tools it has makes it fun to use.

So what is this *Tech Q* I'm talking about? It's a web application where I can randomly get questions for technical interviews I sometimes do at my work. I was looking to learn the following:

1. **Embedding with `go:embed`**[^1] : I'm blown away with the idea you can compile statics in a binary. I tested `go-bindata` and `packr`, but Go introduced a way in 2021.
2. **Serving paths with `http`**: I've experimented with `gorilla/mux`[^2] but wanted to use the `http`[^3] module.
3. **Using `gorm`[^4] with SQLite[^5]**: I've been keeping an eye on this library for a while, wanted to give it a try using SQLite.
4. **Organizing the app**: I have experimented on how to modularize a Go application, but wanted to give it another *go*, to see what feels natural.
5. Last but not least, to **deploy something**: It's been a while and it's always fun.

Let's dive into what I learned for each of these points.

## Embedding with `go:embed`

Turns out you can use the directive `//go:embed` to access embedded files in a Go program. For this application I created the following structure.

```
resources
├── resources.go
├── static
│   ├── css
│   ├── fonts
│   └── images
└── templates
    ├── index.gohtml
    └── layout.gohtml
```

Where `resources.go` contains the following code:

```go
package resources

import "embed"

var (
	//go:embed templates
	Templates embed.FS

	//go:embed static
	Statics embed.FS
)
```

This allows me to use the embedded files like this, for example the `IndexHandler`:

```go
func IndexHandler(w http.ResponseWriter, r *http.Request) {
	// ...
	tpl, err := template.ParseFS(
		resources.Templates,
		"templates/index.gohtml",
		"templates/layout.gohtml",
	)
	// ...
}
```

For `Statics`, which can be fonts, images, CSS, etc. my handler looks like this:

```go
func StaticHandler() http.Handler {
	var staticFS = http.FS(resources.Statics)
	return http.FileServer(staticFS)
}
```

Finally, since my handlers are pointing to either `/` in the case of the `IndexHandler` and `/statics/` for the `StaticHandler`, I can access for example a CSS file from a layout with `/statics/css/styles.css`.

While developing the application I even embedded a CSV file, the SQLite database itself, and images, just to try it out. It's nice.

## Serving paths with `http`

My server skills are still a mess, and I'm still copying and pasting some code I've used before. But I learned something this time, take a look at this code:

```go
func NewServer(port string) *Server {
	mux := http.NewServeMux()
	httpServer := &http.Server{Addr: ":" + port, Handler: mux}

	s := &Server{
		httpServer: httpServer,
	}

	mux.HandleFunc("/", indexHandler)

	return s
}

func indexHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("indexHandler called")
}
```

Whenever I visited `localhost:3000` I would get two log lines for the `indexHandler`. I was confused so I added more information to the log line:

```go
func IndexHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("indexHandler called", r.URL.Path)
}
```

Which logged:

```
indexHandler called /
indexHandler called /favicon.ico
```

That's a request from me and the browser looking for `/` and `/favicon.ico`. The documentation about `NewServerMux` says the following[^6]:

> Note that since a pattern ending in a slash names a rooted subtree, the pattern "/" matches all paths not matched by other registered patterns, not just the URL with Path == "/".

Which makes sense, that's the kind of flexibility I like. This small patch achieved what I was looking for to only match `GET` at `/`.

```go
func IndexHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" || r.URL.Path != "/" {
		w.WriteHeader(http.StatusNotFound)
		return
	}
}
```

## Using `gorm` with SQLite

I'm used to Ruby on Rails[^7] and its wonderfully bloated `ActiveRecord` and `ActiveModel`. Don't get me wrong, I love it, but when it comes to use other ORMs like `gorm`, you feel there's something missing, like migrations and seeds in my case.

I created a method to connect to the database:

```go
var DB *gorm.DB

func ConnectDatabase() {
	database, _ := gorm.Open(sqlite.Open("./data/database.db"), &gorm.Config{})
	DB = database
}
```

And three methods to conviniently manage the database with my `Questions` struct.

```go
func DropDB(db *gorm.DB) {
	db.Migrator().DropTable(&models.Question{})
}

func CreateDB(db *gorm.DB) {
	db.AutoMigrate(&models.Question{})
}

func SetupDB(db *gorm.DB) {
	DropDB(db)
	CreateDB(db)
}
```

For the seeds I found this awesome article from Redha Juanda[^8], I adapted a method to read from a TXT file with the questions I needed.

```go
func (s Seed) QuestionSeed() {
	file, _ := os.Open("db/seeds/questions.txt")
	defer file.Close()
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		s.db.Create(&models.Question{Body: line})
	}
}
```

I used this code[^9] to handle arguments using `flag` and adapted it to my needs.

```go
func HandleArgs() {
	flag.Parse()
	args := flag.Args()

	if len(args) >= 1 {
		switch args[0] {
		case "seed":
			db.ExecuteSeed(db.DB, args[1:]...)
			os.Exit(0)
		case "create":
			db.CreateDB(db.DB)
			os.Exit(0)
		case "drop":
			db.DropDB(db.DB)
			os.Exit(0)
		case "setup":
			db.SetupDB(db.DB)
			db.ExecuteSeed(db.DB)
			os.Exit(0)
		}
	}
}
```

Allowing me to execute them like this:

```shell
$ go run main.go create
$ go run main.go seed # or seed QuestionSeed
```

## Organizing the app

I learned in my `csgo_exporter`[^10] project how to organize a Prometheus Exporter, or at least what its usually done. For this case I took a similar approach but trying not to put everything in the `internal` folder.

I kept `config` because it makes sense. `db` and `seeds` in the same directory to maintain database logic in one place. `resources` as I mentioned before it's where the statics are. And `internal` is everything that has to do with business logic.

```
.
├── config
├── data
├── db
│   └── seeds
├── internal
│   ├── handlers
│   ├── models
│   └── server
└── resources
    ├── static
    │   ├── css
    │   ├── fonts
    │   └── images
    └── templates
```

Now that I'm writing this maybe the `server` package needs to be outside `internal`? Or maybe inside `config`? Trivialities, but I like this kind of stuff.

## Deploy something

Feels good to deploy, no? I have an instance in DigitalOcean[^11] instance full of Docker containers with Traefik[^12] as a reverse proxy. The easiest way for me is to create an image and set it up with Docker Compose.

I really like this Dockerfile, it's very similar to the one in the `csgo_exporter`.

```dockerfile
ARG IMAGE=scratch
ARG OS=linux
ARG ARCH=amd64

FROM golang:1.18.1-alpine3.15 as builder

WORKDIR /go/src/github.com/kinduff/techq

RUN apk --no-cache --virtual .build-deps add git alpine-sdk sqlite

COPY . .

RUN go mod download
RUN GOOS=$OS GOARCH=$ARCH go build -a -ldflags '-linkmode external -extldflags "-static"' -o binary .

FROM $IMAGE

LABEL name="techq"

WORKDIR /root/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/src/github.com/kinduff/techq/binary techq

EXPOSE 3000

CMD ["./techq"]
```

This generates a compressed image of ~8MB. The Docker Compose file is trivial.

![TechQ in the browser](/assets/images/posts/techqpreview.png)

You can see the final result at [TechQ.kinduff.com](https://techq.kinduff.com) and the source code at [github.com/kinduff/techq](https://github.com/kinduff/techq).

Hope you enjoyed this blog post, it was really fun to write and I'm always happy to share what I know and what I'm learning.

See you next time!

**Footnotes**

[^1]: [Go's Embed](https://pkg.go.dev/embed)
[^2]: [Gorilla's mux](https://github.com/gorilla/mux)
[^3]: [Go's http](https://pkg.go.dev/net/http)
[^4]: [GORM](https://gorm.io)
[^5]: [SQLite](https://sqlite.org)
[^6]: [Go's http#ServeMux](https://pkg.go.dev/net/http#ServeMux)
[^7]: [Ruby on Rails](https://rubyonrails.org)
[^8]: [How I Seed My Database With Go](https://medium.com/easyread/how-i-seed-my-database-with-go-27488d2e6a75)
[^9]: [main.go](https://gist.github.com/redhajuanda/a802ed3b59d15da39609ce4e3c6ef999#file-main-go)
[^10]: [CSGO Exporter](https://github.com/kinduff/csgo_exporter)
[^11]: [DigitalOcean](https://m.do.co/c/10222848465a) (affiliate link)
[^12]: [Traefik](https://doc.traefik.io/traefik/)
