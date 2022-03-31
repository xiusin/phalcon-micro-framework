namespace Pine\Logger\Adapter;

use Phalcon\Logger\Adapter\AbstractAdapter;
use Phalcon\Db\Adapter\AbstractAdapter as DbAbstractAdapter;
use Phalcon\Db\Column;
use Phalcon\Db\Index;
use Phalcon\Di;
use Phalcon\Logger\Adapter\AdapterInterface;
use Phalcon\Logger\Item;

class Sqlite extends AbstractAdapter
{
    /**
     * @var DbAbstractAdapter
     */
     protected db;

     /**
      * @var string
      */
     protected name;
 
     /**
      * @var string
      */
     protected tableName;
 
     /**
      * Class constructor.
      *
      * @param string name
      * @param array options
      */
     public function __construct(string name, array options = [])
     {

        var createTableSql;

         let this->db = Di::getDefault()->getShared("sqlite");
 
         let this->name = name;
         let this->tableName = options["tablename"];

         if (!this->db->tableExists(this->tableName)) {
            let createTableSql = "CREATE TABLE " . this->tableName . "(id primary key autoincrement, name VARCHAR(255), type INTEGER NOT NULL, content TEXT, created_at BIGINT NOT NULL);";
            this->db->execute(createTableSql);
        }
     }
 
     /**
      * Closes DB connection
      *
      * Do nothing, DB connection close can't be done here.
      *
      * @return bool
      */
     public function close() -> bool
     {
         return true;
     }
 
     /**
      * Opens DB Transaction
      *
      * @return AdapterInterface
      */
     public function begin() -> <AdapterInterface>
     {
         this->db->begin();
 
         return this;
     }
 
     /**
      * Commit transaction
      *
      * @return AdapterInterface
      */
     public function commit() -> <AdapterInterface>
     {
         this->db->commit();
 
         return this;
     }
 
     /**
      * Rollback transaction
      * (happens automatically if commit never reached)
      *
      * @return AdapterInterface
      */
     public function rollback() -> <AdapterInterface>
     {
         this->db->rollback();
 
         return this;
     }
 
     /**
      * Writes the log into DB table
      *
      * @param Item item
      */
     public function process(<Item> item) -> void
     {
         this->db->execute(
             "INSERT INTO " . this->tableName . " VALUES (?, ?, ?, ?)",
             [
                 this->name,
                 item->getType(),
                 this->getFormatter()->format(item),
                 item->getTime()
             ],
             [
                 Column::BIND_PARAM_STR,
                 Column::BIND_PARAM_INT,
                 Column::BIND_PARAM_STR,
                 Column::BIND_PARAM_INT
             ]
         );
     }
}