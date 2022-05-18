<?php

namespace App\Pine;

use Crunz\Event;

class Schedule extends \Crunz\Schedule
{
    public function command(string $command, $parameters = []): Event
    {
        return $this->run(PINE_BIN_PATH . " " . $command, $parameters);
    }
}
