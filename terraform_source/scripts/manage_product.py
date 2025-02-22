import os
import logging
import sys
from sqlalchemy import create_engine, text, URL

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s = %(message)s')


def manage_records():
    host = os.getenv("db_host")
    port = os.getenv("db_port")
    user = os.getenv("db_username")
    password = os.getenv("db_password")
    name = os.getenv("db_name")

    logging.info(f"db connection at {host}:{port} via user {user}")

    table_schema = sys.argv[1]
    table_name = sys.argv[2]
    terraform_flag = sys.argv[3]
    table_fields = sys.argv[4:]

    table_fields_dict = {f"field{i}": (None if field == "__NULL__" else field) for i, field in enumerate(table_fields)}
    table_field_place_holders = [
        f"CAST(:field{i} as TEXT)" if table_fields_dict[f"field{i}"] is not None else "NULL"
        for i in range(len(table_fields))
    ]

    table_field_values = ', '.join(table_field_place_holders)

    query_template = f"""

DO $$
DECLARE
    terraform_flag CHAR := CAST('{terraform_flag}' as CHAR);
    __product_key CHAR(32);

BEGIN
    __product_key = MD5(CAST(:field0 as TEXT));
    if terraform_flag = 'N' THEN
    IF EXISTS(
            SELECT 1 from {table_schema}.{table_name} where product_key = __product_key
            )
            THEN
            --here we will update old record, we will mark it as inactive
            UPDATE {table_schema}.{table_name} 
            SET record_expiration_timestamp = CURRENT_TIMESTAMP,
                current_record_indicator = 'N',
                update_timestamp = CURRENT_TIMESTAMP
            WHERE product_key = __product_key
            AND current_record_indicator = 'Y';
            
        --Now we will insert NEW record as a new entry in the table
        
            INSERT INTO {table_schema}.{table_name} (
            product_key, create_timestamp, update_timestamp,
            record_effective_timestamp, record_expiration_timestamp, 
            current_record_indicator, product_code, product_name, 
            product_description) 
            VALUES (
            __product_key, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
            CURRENT_TIMESTAMP, '2099-12-31 23:59:59', 'Y', {table_field_values});
    ELSE
        --Now we will insert NEW record as a new entry in the table
        
            INSERT INTO {table_schema}.{table_name} (
            product_key, create_timestamp, update_timestamp,
            record_effective_timestamp, record_expiration_timestamp, 
            current_record_indicator, product_code, product_name, 
            product_description) 
            VALUES (
            __product_key, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
            CURRENT_TIMESTAMP, '2099-12-31 23:59:59', 'Y', {table_field_values});
    END IF;
    
    ELSIF terraform_flag = 'Y' THEN
        UPDATE {table_schema}.{table_name} 
            SET record_expiration_timestamp = CURRENT_TIMESTAMP,
                current_record_indicator = 'N',
                update_timestamp = CURRENT_TIMESTAMP
            WHERE product_key = __product_key
            AND current_record_indicator = 'Y';
    END IF;
END $$ LANGUAGE plpgsql;
"""

    logging.info(f"Inserting/Managing data for table - {table_schema}.{table_name}")

    conn_url = URL.create(
        drivername="postgresql+psycopg2",
        username=user,
        password=password,
        host=host,
        port=int(port),
        database=name
    )

    sqlalchemy_engine = create_engine(conn_url)

    query = text(query_template.format(table_schema=table_schema, table_name=table_name, terraform_flag=terraform_flag,
                                       table_field_values=table_field_values))

    try:
        with sqlalchemy_engine.begin() as connection:
            connection.execute(query, table_fields_dict)
            logging.info("query executed successfully")
        sys.exit(0)
    except Exception as e:
        logging.error(f"error in query - {e}")
        sys.exit(1)
    finally:
        logging.info(f"process complete for {table_schema}.{table_name}")


if __name__ == "__main__":
    manage_records()
