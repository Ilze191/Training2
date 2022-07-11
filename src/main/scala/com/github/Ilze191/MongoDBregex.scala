package com.github.Ilze191

import com.github.Ilze191.Utlities.saveLines
import org.mongodb.scala.{Document, MongoClient, MongoDatabase}
import org.mongodb.scala.model.Filters.{and, equal, or, regex}

import scala.Console.println
import scala.collection.mutable.ArrayBuffer

object MongoDBregex extends App{
  val userName = scala.util.Properties.envOrElse("MONGOUSER","no user")
  val pw = scala.util.Properties.envOrElse("MONGOPASS","no password")
  val uri: String = s"mongodb+srv://$userName:$pw@cluster0.5pbaq.mongodb.net/$dbName?retryWrites=true&w=majority"
  //here we connect to the MongoDB cluster
  val client: MongoClient = MongoClient(uri)
  val dbName = "sample_restaurants"
  //connecting to the actual database - single cluster
  val db: MongoDatabase = client.getDatabase(dbName)
  val collectionName = "restaurants"
  //connecting to the collection(roughly similar to the table in sql)
  val collection = db.getCollection(collectionName)

  val resultsBuffer = ArrayBuffer[Document]()

  //TODO find ALL restaurants in Manhattan offering barbeque OR BBQ  in name (maybe try cuisine as well)

  val allRestaurants = collection.find(and(equal("address.borough", "Manhattan"),
    or(regex("name", ".*barbeque.*"), regex("name", ".*BBQ.*"),
      equal("cuisine", "barbeque"))))
    .subscribe(
      (doc: Document) => {
        resultsBuffer += doc
      },
      (e: Throwable) => println(s"Query error: $e"),
      afterQuerySuccess
    )

  println("Query is still Running - Data is not guaranteed to be ready")

  def afterQuerySuccess():Unit = {
    println("Closing after last query")
    //so idea is to close after last query is complete
    val allRestaurantDocs = resultsBuffer.toArray
    println(s"We got ${allRestaurantDocs.length} restaurants total")
    println("First restaurant")
    println(allRestaurantDocs.head.toJson())
    val savePath = "src/resources/json/restaurants.json"
    val restaurantJSON = allRestaurantDocs.map(_.toJson())
    saveLines(savePath, restaurantJSON)
    client.close()
  }
}
