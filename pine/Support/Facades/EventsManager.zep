namespace Pine\Support\Facades;

use Pine\Support\Facade;

class EventsManager extends Facade {

    /**
     * Get the registered name of the component.
     *
     * @return string
     */
    public static function getFacadeAccessor() {
        return "eventsManager";
    }
}