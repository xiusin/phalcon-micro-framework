namespace Pine;


class Env {
    protected static _putenv;     

    protected static _env;

    /**
     * 启用Putenv
     */
    public static function enablePutenv() {
        let Env::_putenv = true;
    }

    /**
     * 获取环境变量
     */
    public static function get(string name, var _default = null)
    {
        if isset(Env::_env[name]) {
            return Env::_env[name];
        }

        if isset(_ENV[name]) {
            return _ENV[name];
        }

        if (defined(name)) {
            return constant(name);
        }

        return getenv(name) ?: _default;
    }

    /**
     * 设置环境变量
     */
    public static function set(string name, string value)
    {
        if Env::_putenv {
            putenv(name . "=" . value);
        }

        if !Env::_env {
            let Env::_env = [];
        }

        let Env::_env[name] = value;
        let _ENV[name] = value;
    }

}