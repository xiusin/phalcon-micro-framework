<?php

use Pine\Support\Facades\Router;

Router::get("/", function () {
    echo "hello world";
});


Router::group("/api", function () {
    Router::get("/{name}", function ($name) {
        return "hello $name";
    });
});
