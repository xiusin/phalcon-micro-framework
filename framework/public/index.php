<?php

use Pine\Application;

$di = new \Phalcon\Di\FactoryDefault();

$app = new Application(dirname(__DIR__), $di);

try {
    $app->run();
} catch (Throwable $e) {
    echo $e->getMessage();
}
