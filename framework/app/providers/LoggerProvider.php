<?php

namespace App\Providers;

use Phalcon\Di\ServiceProviderInterface;
use Phalcon\Di\DiInterface;

class LoggerProvider implements ServiceProviderInterface
{
    public function register(DiInterface $di): void
    {
    }
}
