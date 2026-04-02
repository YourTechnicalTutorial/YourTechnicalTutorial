const { MongoClient } = require('mongodb');
require('dotenv').config();

const uri = process.env.MONGO_URI;
const client = new MongoClient(uri);

async function run() {
  try {
    await client.connect();
    console.log("Connected successfully to Atlas");
  } catch (err) {
    console.dir(err);
  } finally {
    await client.close();
  }
}
run().catch(console.dir);
