<?php

return [

    // 默认数据库连接
    'database' => [
        'adapter' => 'Mysql',
        'host' => getenv('DB_HOST', 'localhost'),
        'port' => getenv('DB_PORT', '3306'),
        'username' => getenv('DB_USERNAME', 'root'),
        'password' => getenv('DB_PASSWORD', ''),
        'dbname' => getenv('DB_DATABASE', ''),
        'charset' => 'utf8mb4',
    ],

    // sqlite  数据库 做缓存和日志用, 不做具体数据存储
    'sqlite' => [
        'dbname' => "data/data.db"
    ],

];
