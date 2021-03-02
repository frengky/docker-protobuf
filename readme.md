# Protobuf

Alpine based docker image to generate source file from `*.proto`

## Usage

Generate php source file from `your.proto` to `out/`
```
$ docker run -it --rm -v $(pwd):/app frengky/protobuf --php_out=/app/out your.proto
```

Generate go source file from `your.proto` to `out/`
```
$ docker run -it --rm -v $(pwd):/app frengky/protobuf --go_out=/app/out your.proto
```
