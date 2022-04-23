<?php

namespace App\Pine;

use Crunz\Event;

class Schedule extends \Crunz\Schedule
{
    public static $BIN = "./bin/pine";

    public function command(string $command, $parameters = []): Event
    {
        return $this->run(self::$BIN . " " . $command, $parameters);
    }
}