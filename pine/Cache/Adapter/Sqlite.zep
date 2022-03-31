namespace Pine\Cache\Adapter;

use Phalcon\Cache\Adapter\AdapterInterface as CacheAdapterInterface;
use Phalcon\Storage\Adapter\AbstractAdapter;
use Phalcon\Storage\SerializerFactory;
use Phalcon\Db\Enum;
use Phalcon\Di;

/**
 * Sqlite 缓存组件
 */
class Sqlite extends AbstractAdapter implements CacheAdapterInterface {

    protected table_name = "cache";
    

    public function __construct(<SerializerFactory> factory, array options = [])
    {
        var createTableSql;

        parent::__construct(factory, options);
        let this->table_name = options["table_name"] ? options["table_name"] : this->table_name;
        let this->adapter = Di::getDefault()->getShared("sqlite");

        if (!this->adapter->tableExists(this->table_name)) {
            let createTableSql = "CREATE TABLE " . this->table_name . "(id primary key autoincrement, key_name VARCHAR(255), content TEXT, expired_at BIGINT NOT NULL);";
            this->adapter->execute(createTableSql);
        }

        this->initSerializer();
    }

    public function clear() -> bool
    {
        return this->adapter->execute("DELETE FROM  " . this->table_name);
    }


    public function has(string key) -> bool
    {
        var sql, row;
        let sql = "SELECT expired_at FROM " . this->table_name . " WHERE key_name = ? ";
        let row = this->adapter->fetchOne(sql, Enum::FETCH_ASSOC, [this->getPrefixedKey(key)]);
        if (row) {
            if (row["expired_at"] > time()) {
                return true;
            }
            this->delete($key);
        }
        return false;
    }

    public function get(string key, var defaultValue = null)
    {
        var sql, record;
        let sql = "SELECT content, expired_at FROM " . this->table_name . " WHERE key_name = ?";
        let record = this->adapter->fetchOne(sql, Enum::FETCH_ASSOC, [this->getPrefixedKey(key)]);
        if (!record) {
            return defaultValue;
        }
        
        if (record["expired_at"] < time()) {
            this->adapter->delete(this->table_name, key);
            return defaultValue;
        }

        return this->getUnserializedData(record["content"], defaultValue);
    }

    public function delete(string key) -> bool
    {
        return this->adapter->delete(this->table_name, "`key_name` = '" . this->getPrefixedKey(key) . "'");
    }

    public function getKeys(string prefix = "") -> array
    {
        var sql; 
        let sql = "SELECT key_name FROM " . this->table_name . " WHERE key_name like ? and expired_at >= " . time() . " ORDER BY expired_at DESC";

        return $this->adapter->fetchAll(sql, Enum::FETCH_ASSOC, [this->getPrefixedKey(prefix) . "%"]);
    }

    public function getAdapter()
    {
        return this->adapter;
    }


     public function increment(string key, int value = 1)
     {
         var data;
         if (this->has(key)) {
             let data = (int)this->get(key, 0);
             let data = data + value;
 
             return this->adapter->update(this->table_name, [this->getSerializedData(data)], ["data"], "key_name = '" . this->getPrefixedKey(key) . "'");
         }
         return false;
     }

     public function decrement(string key, int value = 1)
     {
        var data;
        if (this->has(key)) {
            let data = (int)this->get(key, 0);
            let data = data - value;

            return this->adapter->update(this->table_name, [this->getSerializedData(data)], ["data"], "key_name = '" . this->getPrefixedKey(key) . "'");
        }
        return false;
     }
}