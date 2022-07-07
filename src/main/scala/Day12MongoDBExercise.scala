import org.mongodb.scala.{Document, MongoClient, MongoDatabase}
import org.mongodb.scala.model.Filters.equal

import java.lang.Thread.sleep

object Day12MongoDBExercise extends App{
  val userName = "IlzeP"
  val pw = scala.util.Properties.envOrElse("MONGOPASS","nopassword")
  val uri: String = s"mongodb+srv://$userName:$pw@cluster0.5pbaq.mongodb.net/$dbName?retryWrites=true&w=majority"
  val client: MongoClient = MongoClient(uri)
  val dbName = "sample_restaurants"
  val db: MongoDatabase = client.getDatabase(dbName)
  val collectionName = "restaurants"
  val collection = db.getCollection(collectionName)


  //PRINT ALL THE RESTAURANTS ON BROADWAY STREET

  val broadwayRestaurants = collection.find(equal("address.street", "Broadway"))
    .subscribe((doc: Document) => println(doc.toJson()),
      (e: Throwable) => println(s"Query error: $e"),
      () => println("Runs after query is complete")
    )

  sleep(5000)
  client.close()
}
