const { db } = require('./mysql')
const argon2 = require('argon2')
const jwt = require('jsonwebtoken')
const { TOKEN_EXPIRE, TOKEN_SECRET, ARGON2_SALT } = process.env

async function queryUserCellphone (cellphone) {
  const [dbCellphone] = await db.execute('SELECT cellphone FROM user WHERE cellphone = ?', [cellphone])
  return dbCellphone[0]
}

async function queryUserEmail (email) {
  const [dbEmail] = await db.execute('SELECT cellphone FROM user WHERE cellphone = ?', [email])
  return dbEmail[0]
}

async function signup (fullname, email, password, cellphone) {
  const dbConnection = await db.getConnection()
  await dbConnection.beginTransaction()
  try {
    const hashedPassword = await argon2.hash(password, ARGON2_SALT)
    const user = {
      fullname,
      email,
      cellphone
    }
    const accessToken = await jwt.sign(
      {
        fullname,
        email,
        cellphone
      },
      TOKEN_SECRET
    )
    user.access_token = accessToken
    const [result] = await dbConnection.execute('INSERT INTO user (hashed_password, fullname, cellphone, email) VALUES (?, ?, ?, ?)', [
      hashedPassword,
      fullname,
      cellphone,
      email
    ])
    user.id = result.insertId
    dbConnection.commit()
    return user
  } catch (err) {
    console.log(err)
    await dbConnection.rollback()
  } finally {
    await dbConnection.release()
  }
}

module.exports = {
  queryUserCellphone,
  queryUserEmail,
  signup
}
