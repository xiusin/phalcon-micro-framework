<?php

declare(strict_types=1);


use App\Pine\Schedule;

$scheduler = new Schedule();
$task = $scheduler->command('app:version');
$task->description('定时打印版本号')->everyMinute();

return $scheduler;
