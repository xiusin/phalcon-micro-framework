namespace Pine\Support\Facades;

use Pine\Support\Facade;

use Pine\Env;

class Env extends Facade {

    protected static instance;

    /**
     * Get the registered name of the component.
     *
     * @return Env
     */
    public static function getFacadeAccessor() {
        if !self::instance {
            let self::instance = new Env;
        }
        return self::instance;
    }
}