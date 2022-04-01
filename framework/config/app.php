<?php

return [

    /**
     * Application Name
     */
    'name' => \Pine\Support\Facades\Env::env('APP_NAME', "pine"),

    /**
     * Application Environment
     */
    'env' => getenv('APP_ENV'),

    /**
     * Application Debug Mode
     */
    'debug' => getenv('APP_DEBUG'),


    /**
     * 时区
     */
    'timezone' => 'Asia/Shanghai',

   /*
    |--------------------------------------------------------------------------
    | Encryption Key
    |--------------------------------------------------------------------------
    |
    | This key is used by the Illuminate encrypter service and should be set
    | to a random, 32 character string, otherwise these encrypted strings
    | will not be safe. Please do this before deploying an application!
    |
    */
    'key' => getenv('APP_KEY'),

    'cipher' => 'AES-256-CBC',


    /**
     * 一般注册门面模式
     *
     * Class Aliases
     */
    'aliases' => [

    ],

    /**
     * Autoloaded Service Providers
     */
    'providers' => [
        \App\Providers\DatabaseProvider::class,
        \App\Providers\LoggerProvider::class,
        \App\Providers\CacheProvider::class,
    ]
];
