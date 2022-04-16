<?php

namespace App\Providers;

use Phalcon\Di\ServiceProviderInterface;
use Phalcon\Di\DiInterface;
use Pine\Support\Facades\Config;

class DatabaseProvider implements ServiceProviderInterface
{
    public function register(DiInterface $di): void
    {
        $di->setShared('db', function () use ($di) {
            
            $config = Config::get("database");

            $class = 'Phalcon\Db\Adapter\Pdo\\' . $config->database->adapter;

            $params = [
                'host' => $config->database->host,
                'port' => $config->database->port ?: 3306,
                'username' => $config->database->username,
                'password' => $config->database->password,
                'dbname' => $config->database->dbname,
                'charset' => $config->database->charset
            ];

            if ($config->database->adapter == 'Postgresql') {
                unset($params['charset']);
            }

            $connection = new $class($params);
            $connection->setEventsManager($di['eventsManager']);

            return $connection;
        });
    }
}
