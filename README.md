# faclabprojet0
 MAC OSX

  #####################################################################
  MYSQL CONF

    brew install mysql
    brew services start mysql
    mysql -u root
    CREATE DATABASE 'your_database_name'

    # Connect to the local server
    mysql -u root -h localhost -p  -e 'show databases;'
  #####################################################################



  #####################################################################

  CREATE your project                     
    rails new 1.2.3_Visiteurs -d mysql

  ####################################################################

  

  #####################################################################
  IN "Database.yml"

    default: &default
      adapter: mysql2
      encoding: utf8
      username: root
      password:
      socket: /tmp/mysql.sock        ### add this line
      host: 127.0.0.1                ### add this line
      port: 3306                     ### add this line

  Make sure
   database: your_database_name
  #####################################################################
