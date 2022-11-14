require('dotenv').config('../.env')
const mysql = require('mysql2')

const db = mysql
  .createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    timezone: '+00:00' // Asia/Taipei
  })
  .promise()

module.exports = { db }
