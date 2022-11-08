const inpatientsModel = require('../models/inpatientsModel')

async function getChargedPets (req, res, next) {
  const data = await inpatientsModel.getChargedPets()
  return res.status(200).json({ data })
}

async function searchInpatients (req, res, next) {
  const data = await inpatientsModel.searchInpatients(req.query)
  return res.status(200).json({ data })
}

module.exports = { getChargedPets, searchInpatients }