namespace Pine;

use Phalcon\Config;
use Phalcon\Loader;
use Phalcon\Di\DiInterface;
use Phalcon\Di\Injectable;
use Pine\Support\Facade;

class Bootstrap extends Injectable {

    protected bootstraped;

    public basePath;

    protected _loader;

    protected _config;

    public function __construct(string basePath, <DiInterface> container = null)
    {
        var autoload; 

        if !is_dir(basePath) {
            throw new \RuntimeException(basePath . " is not a valid directory");
        }

        this->setBathPath(basePath);
        
        if container !== null {
            this->setDi(container);
        }

        this->getDi()->setShared("bootstrap", this);

        // 门面初始化
        Facade::clearResolvedInstances();  

        /**
         * 设置门面依赖
         */
        Facade::setDI(this->getDi());

        /**
         *  加载vendor
         */
        let autoload =  this->getPath().DIRECTORY_SEPARATOR . "vendor" . DIRECTORY_SEPARATOR . "autoload.php";

        if (is_file(autoload)) {
            require autoload;
        }

        let this->_providers = [];

        /**
         * 初始化配置对象
         */
        this->config();

    }

    public function config() {
        var config;
        if !this->_config {

            let config = [
                "app": require this->getConfigPath() . DIRECTORY_SEPARATOR . "app.php",
                "cache": require this->getConfigPath() . DIRECTORY_SEPARATOR . "cache.php",
                "logger": require this->getConfigPath() . DIRECTORY_SEPARATOR . "logger.php",
                "databases": require this->getConfigPath() . DIRECTORY_SEPARATOR . "databases.php"
            ];

            let this->_config = new Config(config);
            this->getDi()->setShared("config", this->_config);
        }
        return this->_config;
    }

    public function loader() -> <Loader> {
        if !this->_loader {
            let this->_loader = new Loader();
        }

        return this->_loader;
    }

    /**
     * 注册基本绑定
     */
    public function registerBaseBindings() {
        this->getDi()->setShared("bootstrap", this);
    }

    /**
     * 设置基础路径
     */
    public function setBathPath(string basePath)
    {
        let this->basePath = rtrim(basePath, "/");

    }

    /**
     * 获取指定目录
     */
    public function getPath(string! path = null) {
        if path === null {
            return this->basePath;
        }

        return  this->basePath . DIRECTORY_SEPARATOR . ltrim(path, "\\\//");
    }

    /**
     * 获取应用目录
     */
    public function getAppPath() {
        
        return this->getPath("app");
    }


    /**
     * 获取配置目录
     */
    public function getConfigPath() {

        return this->getPath("config");
    }


    /**
     * 获取配置目录
     */
     public function getRoutersPath() {

        return this->getPath("routers");
    }

    /**
     * 获取存储目录
     */
    public function storagePath(string! path = null )
    {
        var storagePath; 
        let storagePath = this->getPath("storage");

        if path != null {
            let storagePath = storagePath . DIRECTORY_SEPARATOR . path;
        }

        return storagePath;
    }

    public function reset() -> <Bootstrap> {
        let this->bootstraped = false;
        return this;
    }
    
    /**
     * 驱动前置逻辑
     */
    public function bootstrap() {

        if !this->bootstraped {

           /**
            * 注册默认命名空间
            */
            this->loader()->registerNamespaces(["App": this->getAppPath()]);

            require this->getAppPath() . DIRECTORY_SEPARATOR . "bootstrap.php";

            this->loader()->register();

            this->registerServiceProviders();
        }

    }

    /**
     * 注册全局服务
     */
    private function registerServiceProviders() {
        var providers, provider, providerItem;

        let providers = this->_config->app->providers;
        if providers {
            for _, providerItem in providers->toArray() {
                let  provider = new {providerItem}();
    
                provider->register(this->getDi());
            }
        }
    }
}