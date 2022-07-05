import com.redis.RedisClient

object Day11Exercise extends App {
  val port = 10017
  val url = "redis-10017.c250.eu-central-1-1.ec2.cloud.redislabs.com"
  val pw = Some(scala.util.Properties.envOrElse("REDISPW","nopassword"))
  //println(s"My password is $pw")

  val r = new RedisClient(host = url, port,0, pw)



  //TODO 3 more hackers with their scores/birthyear ( you can use your own or use the ones from redis.io example
  //TODO get all hackers born after 1960 -


  r.zadd("hackers", 1953, "Richard Stallman")
  r.zadd("hackers", 1949, "Anita Borg")
  r.zadd("hackers", 1965, "Yukihiro Matsumoto")

  //I DIDN'T DO ZRANGEBYSCORE

  //val youngerHackers = r.zrangebyscore("hackers"

  //TODO create a new hash key with at least 5 fields with corresponding values
  //TODO retrieve 3 of those values - you can use hget
  // alternative would be r.hmget

  r.hmset("animal:1",Array(("name","Jerry"),
    ("type","cat"),
    ("color","orange"),
    ("age", 4),
    ("food", "KiteKat")
  ))

  val animalName = r.hget("animal:1", "name").getOrElse("")
  val animalType = r.hget("animal:1", "type").getOrElse("")
  val animalFood = r.hget("animal:1", "food").getOrElse("")

  println(s"$animalName is a $animalType. His favorite food is $animalFood")
}
