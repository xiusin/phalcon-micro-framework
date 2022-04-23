namespace Pine;

use Phalcon\Mvc\Micro;
use Phalcon\Mvc\Micro\Collection as MicroCollection;
use Phalcon\Annotations\AdapterInterface;
use Phalcon\Mvc\Router\RouteInterface;
use Phalcon\Di\Injectable;
use Pine\Bootstrap;
use Pine\Mvc\Micro\AnnotationsRouter;
use Pine\Support\Facades\Env;

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

    protected _env;

    static app;

    public function __construct(string! basePath, <\Phalcon\Di\DiInterface> container = null) {
        
        \Pine\Env::enablePutenv();

        let this->_env = new \Pine\Env();

        let this->basePath = basePath;

        if container !== null {
            this->setDi(container);
        }

        this->getDi()->setShared("app", this);

        let self::app = this;

        if !this->_bootstrap {
            let this->_bootstrap = new Bootstrap(this->basePath, this->getDi());
        }
    }

    public function getBootstrap() -> <Bootstrap>
    {
        return this->_bootstrap;
    }

    public function bootstrap() 
    {
        this->_bootstrap->bootstrap();
    }

    /**
     * 运行命令行数据
     */
    public function runCommand() {
        var commands, command, cls, console;
        let commands = require this->getBootstrap()->getAppPath() . DIRECTORY_SEPARATOR . "commands.php";
        let console = this->getDi()->getShared("console");

        for cls in commands {
            let command = new {cls}();
            console->add(command);
        }
        console->run();
    }

    public function run(uri = null)
    {
        this->bootstrap();

        this->router();

        require this->_bootstrap->getAppPath() . DIRECTORY_SEPARATOR . "router.php";

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

    /**
     * 获取环境变量
     */
    public function env(string key, var _default = null) {
        return this->_env->get(key, _default);
    }
}