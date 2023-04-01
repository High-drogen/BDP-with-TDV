package org.test.spark.remote
package remotetest

import org.apache.spark.sql.{SparkSession}

object Ingestion extends App {

  val spark = SparkSession.builder()
    .appName("Ingestion")
    .config("spark.master", "k8s://https://127.0.0.1:6443")
    .getOrCreate()

  val driver = "org.postgresql.Driver"
  val url = "jdbc:postgresql://192.168.212.48:5432/postgres"
  val user = "postgres"
  val password = "psql"
  def readTable(tableName: String) = spark.read
    .format("jdbc")
    .option("driver", driver)
    .option("url", url)
    .option("user", user)
    .option("password", password)
    .option("dbtable", s"polycmuql.$tableName")
    .load()

  val testAlertParquet = readTable("alert")
  testAlertParquet.show()

  val tables = List("medication", "allergy", "alert", "patient")
  tables.foreach(x => readTable(x).write.save(s"hdfs://192.168.212.48:9000/root_test_dir/HIV_TEST185/$x"))
}
















