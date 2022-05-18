<?php

namespace App\Pine;

use Crunz\Application;
use Phalcon\Di\DiInterface;

class Console extends Application
{
    public function __construct(DiInterface $di,string $appName = "", string $appVersion = "")
    {
        parent::__construct($appName ?: 'pine', $appVersion);

        $this->setAutoExit(true);
        $this->setCatchExceptions(true);

        $di->setShared("console", $this);
    }
}
