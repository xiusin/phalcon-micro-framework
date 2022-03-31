<?php

use Pine\Mvc\Micro\Application;

$di = new \Phalcon\Di\FactoryDefault();

$app = new Application(dirname(__DIR__), $di);

try {
    $app->run("/api/xiusin");
} catch (Throwable $e) {
    echo $e->getMessage();
}
