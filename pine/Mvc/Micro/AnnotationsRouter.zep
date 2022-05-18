namespace Pine\Mvc\Micro;

use Phalcon\Mvc\Micro;
use Phalcon\Mvc\Micro\Collection as MicroCollection;
use Phalcon\Annotations\AdapterInterface;
use Phalcon\Mvc\Router\RouteInterface;
use Pine\Bootstrap;

/**
 * Micro 注解路由前缀解析
 *
 * Pine\Mvc\Micro\AnnotationsRouter
 *
 * A router that reads routes annotations from classes/resources for Micro
 *
 * ```php
 *  use Pine\Mvc\Micro\AnnotationsRouter;
 *  include "TestController.php";
 *  $di = new Phalcon\Di\FactoryDefault();
 *  $router = new AnnotationsRouter($di);
 *
 *  $router->group("/api", function ($router) {
 *      $router->register(TestController::class, "test"); // $router->handle("/api/test/index");
 *      $router->group("/v2", function ($router) {
 *          $router->register(TestController::class, null); // $router->handle("/api/v2/test/index2");
 *          $router->get("/{name}", function ($name) {
 *              echo "/api/v2/" . $name;
 *          });
 *      });
 *  });
 * ```
 */
class AnnotationsRouter extends Micro
{
    // protected groupPrefixStack = []; Exception: The argument is not initialized or iterable()

    protected groupPrefixStack;
    
     public function group(string prefix, callable callback) -> void
     {
        let this->groupPrefixStack[] = prefix;
        
        {callback}(this);

        if count(this->groupPrefixStack) > 0 {
            array_pop(this->groupPrefixStack);
        }
     }

    /**
     * regiser controller by prefix
     */
    public function register(string fullControllerName, string! prefix = null)
    {
        var collection, annotationsService, handlerAnnotations, container, annotations, annotation, 
        isRoute, classRouterPrefix,methodsAnnotations, method, name, route;

        let container = this->container;

        /**
         * get shared annotations service
         */
        let annotationsService = container->getShared("annotations");

        if !annotationsService {
            throw new \Exception("service 'annotations' not exist");
        }

        let collection = new MicroCollection();

        collection->setHandler(fullControllerName, true);
        
        let handlerAnnotations = annotationsService->get(fullControllerName);
        
        if typeof handlerAnnotations != "object" {
            throw new \Exception("Class " . fullControllerName . " is not exsit");
        }
        
        if !prefix {
            let annotations = handlerAnnotations->getClassAnnotations();
            for annotation in annotations {
                if annotation->getName() == "RoutePrefix" && annotation->numberArguments() > 0  {
                    let classRouterPrefix = annotation->getArgument(0);
                    break;
                }
            }
        } else {
            let classRouterPrefix = prefix;
        }

        collection->setPrefix(this->getPrefixedRoutePatten(classRouterPrefix));

        /**
         * 获取所有方法的注释对象
         */
        let methodsAnnotations = handlerAnnotations->getMethodsAnnotations();

        for method, annotations in methodsAnnotations {
            /**
             * 仅接受Action后缀的参数
             */
            if !ends_with(method, "Action") {
                continue;
            }

            for annotation in annotations {
                    let name = annotation->getName();
                    let isRoute = false;
                    switch name {
                        // case "Route":
                        //     let isRoute = true;
                        //     break;

                        case "Get":
                        case "Post":
                        case "Put":
                        case "Patch":
                        case "Delete":
                        case "Options":
                            let isRoute = true; 
                            break;
                    }
                
                    let route = annotation->getArgument(0);

                    if isRoute && starts_with(route, "/") {
                        let name = strtolower(name);
                        collection->{name}(route, method);
                    }
            }
        }

        this->mount(collection);
    }  

    /**
     * Maps a route to a handler that only matches if the HTTP method is DELETE
     *
     * @param callable handler
     */
    public function get(string! routePattern, handler) -> <RouteInterface>
    {
        return parent::get(this->getPrefixedRoutePatten(routePattern), handler);
    }

    /**
     * Maps a route to a handler that only matches if the HTTP method is POST
     *
     * @param callable handler
     */
    public function post(string! routePattern, handler) -> <RouteInterface>
    {
        return parent::post(this->getPrefixedRoutePatten(routePattern), handler);
    }

    /**
     * Maps a route to a handler that only matches if the HTTP method is OPTIONS
     *
     * @param callable handler
     */
    public function options(string! routePattern, handler) -> <RouteInterface>
    {
        return parent::options(this->getPrefixedRoutePatten(routePattern), handler);
    }

    /**
     * Maps a route to a handler that only matches if the HTTP method is DELETE
     *
     * @param callable handler
     */
    public function delete(string! routePattern, handler) -> <RouteInterface>
    {
        return parent::delete(this->getPrefixedRoutePatten(routePattern), handler);
    }

    /**
     * Maps a route to a handler that only matches if the HTTP method is PUT
     *
     * @param callable handler
     */
    public function put(string! routePattern, handler) -> <RouteInterface>
    {
        return parent::put(this->getPrefixedRoutePatten(routePattern), handler);
    }

    /**
     * Maps a route to a handler that only matches if the HTTP method is PATCH
     *
     * @param callable handler
     */
    public function patch(string! routePattern, handler) -> <RouteInterface>
    {
        return parent::patch(this->getPrefixedRoutePatten(routePattern), handler);
    }

    /**
     * 获取当前执行时的带前缀的路由信息
     *
     * @return string
     */
    private function getPrefixedRoutePatten(string routePattern) -> string 
    {
        if this->groupPrefixStack {
            return implode("", this->groupPrefixStack) . routePattern;
        }
        return routePattern;
    }
}