namespace Pine\Support\Facades;

use Phalcon\Di\DiInterface;
use Pine\Support\Facade;

class App extends Facade {

    /**
     * 获取启动对象
     */
    public static function bootstrap() {
        return Facade::getDI()->getShared("bootstrap");
    }

    /**
     * Get the registered name of the component.
     *
     * @return string
     */
    public static function getFacadeAccessor() {
        return "app";
    }
}