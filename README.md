# Setup

Prerequisites

- [Ruby 3.3.0](https://www.ruby-lang.org/en/downloads/)
- [PostgreSQL](https://www.postgresql.org/download/)
- [Node.js 20.10.0](https://nodejs.org/en/blog/release/v20.10.0)

Create `.env` file at the root of the project directory. Copy the content of `.env.template.erb` to `.env` then update the `username` and `password` based on your database credentials

Install dependencies

```
yarn install
```

```
bundle i
```

Setup database

```
bin/rails db:setup
```

Start local web server

```
bin/dev
```
