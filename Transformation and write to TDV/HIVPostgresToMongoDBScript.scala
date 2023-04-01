package playground

import com.mongodb.spark.MongoSpark
import com.mongodb.spark.config.WriteConfig
import org.apache.spark.sql.types._
import org.apache.spark.sql.{Column, DataFrame, SparkSession}

object HIVPostgresToMongoDBScript extends App {

  val spark = SparkSession.builder()
    .appName("Lake to Mongo Example")
    .config("spark.master", "k8s://https://127.0.0.1:6443")
    .config("spark.mongodb.output.uri", "mongodb://vaati:hadoop@example-mongodb-0.example-mongodb-svc.mongo-ns.svc.cluster.local:27017")
    .getOrCreate()
//  spark.sparkContext.setLogLevel("WARN")


  val DEFAULT_TIMEOUT = 5 * 60000L
  System.setProperty("test.timeout", "DEFAULT_TIMEOUT")

  def sparkReader(filePath: String) =
    spark.read
      .option("inferSchema", "true")
      .load(s"$filePath")

  val alertDF = sparkReader("hdfs://192.168.212.48:9000/root_test_dir/HIV/alert/*")
  val medicationDF = sparkReader("hdfs://192.168.212.48:9000/root_test_dir/HIV/medication/*")
  val allergyDF = sparkReader("hdfs://192.168.212.48:9000/root_test_dir/HIV/allergy/*")
  val patientDF = sparkReader("hdfs://192.168.212.48:9000/root_test_dir/HIV/patient/*")

  import spark.implicits._

  import org.apache.spark.sql.functions._
  def formatJSONDF(dataFrame: DataFrame, alias: String, cols: Column) =
    dataFrame.groupBy('patient_id)
      .agg(
        collect_list(
          cols
        )
          .as(s"$alias")
      )

  import scala.reflect.runtime.universe._
  def classAccessors[T: TypeTag]: List[MethodSymbol] = typeOf[T].members.collect {
    case m: MethodSymbol if m.isCaseAccessor => m
  }.toList
//  classAccessors[Patient].map( x => map( lit(s"${x.name}"), col(s"${x.name}").cast(StringType) ))

  val seqBuilder: String => Seq[Column] = (x: String) => Seq(lit(s"$x"), col(s"$x").cast(StringType))

  val medicationMap: List[Column] = classAccessors[Medication].flatMap( x => seqBuilder(x.name.toString) )
  val medJSON = formatJSONDF(medicationDF, "medications", map( medicationMap:_*))
  medJSON.show

  val alertsMap = classAccessors[Alert].flatMap( x => seqBuilder(x.name.toString) )
  val alertJSON = formatJSONDF(alertDF, "alerts", map( alertsMap:_*))
  alertJSON.show

  val allergyMap = classAccessors[Allergy].flatMap( x => seqBuilder(x.name.toString) )
  val allergyJSON = formatJSONDF(allergyDF, "allergies", map( allergyMap:_*))
  allergyJSON.show

  val finalResult = patientDF
    .join(
      medJSON,
      medJSON.col("patient_id") === patientDF.col("id"),
      "full"
    )
    .drop("patient_id")
    .join(
      alertJSON,
      alertJSON.col("patient_id") === patientDF.col("id"),
      "full"
    )
    .drop("patient_id")
    .join(
      allergyJSON,
      allergyJSON.col("patient_id") === patientDF.col("id"),
      "full"
    )
    .drop("patient_id")
    .orderBy("id")

  finalResult.show(3, false)

  val ds2 = finalResult.select(
    $"id".cast(IntegerType),
    $"born_date".cast(TimestampType),
    $"created".cast(TimestampType),
    $"last_modified".cast(TimestampType),
    $"gender",
    $"gender_other",
    $"last_annual_examination".cast(TimestampType),
    $"last_consultation".cast(TimestampType),
    $"doctor",
    $"status".cast(IntegerType),
    $"born_city",
    $"city",
    $"country",
    $"culture",
    $"ethnical_origin",
    $"marital_status".cast(IntegerType),
    $"nationality".cast(IntegerType),
    $"occupation",
    $"state",
    $"zip",
    $"sexual_orientation",
    $"deceased_date".cast(DateType),
    $"born_country",
    $"xref_patient".cast(IntegerType),
    $"medications".cast( ArrayType(MapType(StringType,StringType)) ),
    $"alerts".cast( ArrayType(MapType(StringType,StringType)) ),
    $"allergies".cast( ArrayType(MapType(StringType,StringType)) )
  )
  ds2.printSchema()
  ds2.show()

  val writeConfig = WriteConfig(Map("spark.mongodb.output.uri" -> "mongodb://vaati:hadoop@example-mongodb-0.example-mongodb-svc.mongo-ns.svc.cluster.local:27017/",
    "database" -> "test",
    "collection" -> "hiv"))

  MongoSpark.save(ds2.write.option("collection", "hiv").mode("overwrite"), writeConfig)
}
