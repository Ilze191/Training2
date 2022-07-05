import com.redis.RedisClient

object Day10RedisClient extends App {
  println("Testing Redis Client Capability")
  //get port and connection utl from your Redis Cloud console configuration tab
  val port = 10017
  val url = "redis-10017.c250.eu-central-1-1.ec2.cloud.redislabs.com"
  val dbname = "Ilze-free-db"
  //val pw = Some("This should not be public") //best practise would be to load it from environment variable
  val pw = Some(scala.util.Properties.envOrElse("REDISPW","nopassword"))//need to fix
  println(s"My password is $pw")
  //println(scala.util.Properties.envOrElse("Goland", "No value"))



//  val host = scala.util.Properties.envOrElse("REDISHOST","no such host") //
//  println(s"My host is $host") //


  val r = new RedisClient(host = url, port,0, pw)

  r.set("myname", "Ilze")
  r.incr(key = "mycount")
  //we print values directly from database
  println(r.get("myname"))
  //or save into a value/variable
  val myCounter = r.get("mycount")
  val actualCounter = myCounter.getOrElse("0").toInt
  println(s"My counter is at $myCounter -> $actualCounter")

  val number = r.get("number") //gets Option[String] or None
  println(number)//will be None the first time
  val resultOFDecrby = r.decrby("number", 2)
  println(resultOFDecrby, r.get("number"))

//let's get all the present keys
  val keys = r.keys().getOrElse(List[Some[String]]())//if there are no keys give me empty List of Strings

//  keys.foreach(println)//
  println("My keys are")
  //keys.foreach(key => println(s"Key $key type is ${key.getClass} value: ${r.get(key.getOrElse(""))}"))
  keys.foreach(key => println(s"Key $key type is ${key.getClass} "))
  r.lpush("friends","Alice")
  r.lpush("friends","Bob")
  r.rpush("friends","Carol")
  val friends = r.lrange("friends",0, 10).getOrElse(List[Some[String]]())
  println("All my friends")
  friends.foreach(println)
  friends.foreach(friend=> println(s"Friend: ${friend.getOrElse("no friend")}"))
  //set example
   val addCount = r.sadd("superpowers", "flight", "x-ray vision", "freezing")
  println(s"Added to set ${addCount.getOrElse(0L)}")
  println(r.smembers("superpowers"))



}
