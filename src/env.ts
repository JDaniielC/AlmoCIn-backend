export default class Env {
  public static ENV = process.env.ENV || 'DEV';
  public static PORT = process.env.PORT || 3000;
  public static MONGO_URI =
    process.env.MONGO_URI || 'mongodb://localhost:27017';
  public static MONGO_DB_NAME = process.env.MONGO_DB_NAME || 'test';
}
