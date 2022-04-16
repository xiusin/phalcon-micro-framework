namespace Pine\Support;

use Phalcon\Di\Injectable;
use Phalcon\Di\DiInterface;

class Facade {

    protected static di;

    protected static resolvedInstance;

    /**
     * 清理已经解析的实例
     */
    public static function clearResolvedInstances() -> void
    {
        let self::resolvedInstance = [];
    }

    /**
     * 设置di
     */
    public static function setDI(<DiInterface> di) {
        let self::di = di;
    }

    public static function getDI() -> <DiInterface> {
        return self::di;
    }


    /**
     * 动态调用门面方法
     *
     * @param  string  $method
     * @param  array  $args
     * @return mixed
     *
     * @throws \RuntimeException
     */
     public static function __callStatic(string method, array args)
     {
        var instance;
        let instance = self::getFacadeRoot();
 
        if (!instance) {
            throw new \RuntimeException("A facade root has not been set.");
        }
         
        return call_user_func_array([instance, method], args);  
     }

    /**
     * Get the root object behind the facade.
     *
     * @return mixed
     */
    public static function getFacadeRoot()
    {
        return static::resolveFacadeInstance(static::getFacadeAccessor());
    }

    /**
     * Resolve the facade root instance from the container.
     *
     * @return mixed
     */
     protected static function resolveFacadeInstance(var name)
     {
        
        /**
         * 如果传入参数为一个对象, 则直接返回
         */
        if typeof name === "object" {
            return name;
        }

         var service;
        /**
         * 检测是否已经解析过门面实例
         */
         if (isset(self::resolvedInstance[name])) {
             return self::resolvedInstance[name];
         }

         /**
          * 从di内解析服务
          */
         if (self::di != null) {
              let service = self::di[name];
              if (service) {
                let self::resolvedInstance[name] = service;
              }
              
              return self::resolvedInstance[name];
         }
         return null;
     }

    /**
     * 清除一个已经解析的门面对象
     *
     * @param  string  $name
     * @return void
     */
    public static function clearResolvedInstance(string name)
    {
        unset(self::resolvedInstance[name]);
    }

    /**
     * 获取门面访问对象
     */
    public static function getFacadeAccessor() 
    {
        throw new \RuntimeException("Please use subclass rewriting method getFacadeAccessor");
    }
}