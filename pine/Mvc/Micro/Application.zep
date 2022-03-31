namespace Pine\Mvc\Micro;

use Phalcon\Mvc\Micro;
use Phalcon\Mvc\Micro\Collection as MicroCollection;
use Phalcon\Annotations\AdapterInterface;
use Phalcon\Mvc\Router\RouteInterface;
use Phalcon\Di\Injectable;
use Pine\Bootstrap;

/**
 * Application 应用类
 * 
 * Pine\Mvc\Micro\Application
 */
class Application extends Injectable
{
    protected _bootstrap;

    protected _router;

    protected basePath;

    static app;

    public function __construct(string! basePath, <\Phalcon\Di\DiInterface> container = null) {
        
        let this->basePath = basePath;

        if container !== null {
            this->setDi(container);
        }

        this->getDi()->setShared("app", this);

        let self::app = this;

        if !this->_bootstrap {
            let this->_bootstrap = new Bootstrap(this->basePath, this->getDi());

            this->getDi()->setShared("bootstrap", this->_bootstrap);
        }
    }

    public function run(uri = null)
    {
        this->_bootstrap->bootstrap(uri);

        this->router();

        require this->_bootstrap->getRoutersPath() . DIRECTORY_SEPARATOR . "router.php";

        if !uri {
            fetch uri, _SERVER["REQUEST_URI"];
        }

        this->_router->handle(uri);
    }

    /**
     * 获取全局路由对象
     */
    public function router() -> <AnnotationsRouter>
    {
        if !this->_router {
            let this->_router = new AnnotationsRouter(this->getDi());

            this->getDi()->setShared("micro", this->_router);
        }   
        return this->_router;
    }
}