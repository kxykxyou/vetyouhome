const { db } = require('../models/mysql')

async function getAllVets () {
  const [data] = await db.query('SELECT id, fullname FROM user')
  return data
}

module.exports = { getAllVets }
